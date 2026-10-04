# Soil Moisture Forecasting — USDA SCAN Network

Dự báo độ ẩm đất ở độ sâu 8 inch tại 22 trạm USDA SCAN (Southern Plains,
2023–2026), so sánh 5 mô hình học máy với baseline persistence.

## Kết quả chính

Persistence là baseline rất khó vượt: MAE chỉ 0.629 ở horizon 24h.
Trong 5 mô hình, chỉ LSTM vượt được (0.542, cải thiện 13.8%) — bốn mô
hình tabular đều thua baseline. Hệ thống cảnh báo hạn đạt recall 97.8%.

## Cấu trúc

- `src/` — code xử lý dữ liệu và huấn luyện mô hình
- `sql/` — truy vấn DuckDB cho feature engineering
- `data/` — dữ liệu thô và feat.parquet
- `report/` — bảng kết quả và biểu đồ
- `Paper/` — bài báo hoàn chỉnh

## Chạy lại

Chạy data pipeline trước (~5 phút) để sinh `feat.parquet`, sau đó chạy
benchmark (~50 phút vì có LSTM).

Lưu ý: giữ numpy ở 1.26.x và cài Python từ python.org, không dùng bản
Microsoft Store.


