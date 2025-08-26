Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C26327797;
	Tue, 26 Aug 2025 11:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207846; cv=none; b=VwsHdnVJ4+W5TwbH0CiQ+VGHfW907Z3zXraqBX9GtnOvQpwZYiRchSVbtstYvQn8OCuTMmEIZC3bPt5d0W9dYDWEbOQVRD3yV+VBlyJP8lVceSTk00B4oejrOCYaiiXkiZEwIgOjMokA5Dib1DxZ10DTw7qBWh3sfGiphlddT3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207846; c=relaxed/simple;
	bh=j1mZUhgRemMEpXl8yQKA6x3zLv34vay4JfA0i8RaMXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Fpbz4Q+XJG2//4DIOlSl4RsxOdliGp89xPcbhT0nEtYpdQ+N/Ydw+4oM0i8+AbqBHRMS4Wexq3rCRwvgrEvG9I5E3LjZRpOeb6QEp0olmobqklLhq8ch+GD60/Myb12Cde12GnCve05WRp8MiGSqwfp4Cvu7rmLXUCRpwUJZVes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ah5Tkid2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ah5Tkid2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35340C4CEF1;
	Tue, 26 Aug 2025 11:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207846;
	bh=j1mZUhgRemMEpXl8yQKA6x3zLv34vay4JfA0i8RaMXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ah5Tkid2N2ERh6OQC9RvMZzCZ9pmWIbZuwq+dGJ3r4Ej5IKlVOXJBPzz45hSnZzxd
	 gBsLuSLo+hBGwtu9QQ8k7R0sgV0zLPkXwxlYFjAVeYAchBiP4z1HlYXiolxZeXBUL3
	 JaCOQNVlbKdZjLe4L/zJUt8b5UfMfmf/CiQ21wYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 339/457] iio: imu: inv_icm42600: use = { } instead of memset()
Date: Tue, 26 Aug 2025 13:10:23 +0200
Message-ID: <20250826110945.708629923@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 352112e2d9aab6a156c2803ae14eb89a9fd93b7d ]

Use { } instead of memset() to zero-initialize stack memory to simplify
the code.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20250611-iio-zero-init-stack-with-instead-of-memset-v1-16-ebb2d0a24302@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: dfdc31e7ccf3 ("iio: imu: inv_icm42600: change invalid data error to -EBUSY")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c |    5 ++---
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -902,7 +902,8 @@ int inv_icm42600_accel_parse_fifo(struct
 	const int8_t *temp;
 	unsigned int odr;
 	int64_t ts_val;
-	struct inv_icm42600_accel_buffer buffer;
+	/* buffer is copied to userspace, zeroing it to avoid any data leak */
+	struct inv_icm42600_accel_buffer buffer = { };
 
 	/* parse all fifo packets */
 	for (i = 0, no = 0; i < st->fifo.count; i += size, ++no) {
@@ -921,8 +922,6 @@ int inv_icm42600_accel_parse_fifo(struct
 			inv_sensors_timestamp_apply_odr(ts, st->fifo.period,
 							st->fifo.nb.total, no);
 
-		/* buffer is copied to userspace, zeroing it to avoid any data leak */
-		memset(&buffer, 0, sizeof(buffer));
 		memcpy(&buffer.accel, accel, sizeof(buffer.accel));
 		/* convert 8 bits FIFO temperature in high resolution format */
 		buffer.temp = temp ? (*temp * 64) : 0;
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -806,7 +806,8 @@ int inv_icm42600_gyro_parse_fifo(struct
 	const int8_t *temp;
 	unsigned int odr;
 	int64_t ts_val;
-	struct inv_icm42600_gyro_buffer buffer;
+	/* buffer is copied to userspace, zeroing it to avoid any data leak */
+	struct inv_icm42600_gyro_buffer buffer = { };
 
 	/* parse all fifo packets */
 	for (i = 0, no = 0; i < st->fifo.count; i += size, ++no) {
@@ -825,8 +826,6 @@ int inv_icm42600_gyro_parse_fifo(struct
 			inv_sensors_timestamp_apply_odr(ts, st->fifo.period,
 							st->fifo.nb.total, no);
 
-		/* buffer is copied to userspace, zeroing it to avoid any data leak */
-		memset(&buffer, 0, sizeof(buffer));
 		memcpy(&buffer.gyro, gyro, sizeof(buffer.gyro));
 		/* convert 8 bits FIFO temperature in high resolution format */
 		buffer.temp = temp ? (*temp * 64) : 0;


