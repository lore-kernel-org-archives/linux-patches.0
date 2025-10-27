Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8335C32C93B;
	Mon, 27 Oct 2025 19:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591806; cv=none; b=kw+Kyqh+Ki2cxsYXCytp0ZfLsLbnYATIhRoloudRhLz9iW4mzMioLxWqqAjY02czzKOJE6ICeqEC1VXVyd7nlbPMenuoabPNTg6iBtL2Q2+4Q+02WxD+9q0tgGmMbrs5ArCAq73Bw29Kk40TCiKTrcPx0GL2RnHH/4a13oRcd70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591806; c=relaxed/simple;
	bh=QBe/dBF1l5QnwOfdtKmHyI23kTv5API/VVx3D1SMxSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gc4Rm7fyPc+SrkVXGrs+pexwvG+Eywyk8A7tK3dfdgJsU5BVKYi7q3qzCPV81vtjiuNLBbUYqguRBoOrtH4JbiOpg0QKHO7Y8zDQ3kg7oNJOAg+oneKFqFaBen383gyek76bM5XEb0UzVNU9bSv6XHcsIPDdzlkgMO7iQsFB7RA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWAquhKk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWAquhKk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F439C4CEF1;
	Mon, 27 Oct 2025 19:03:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591805;
	bh=QBe/dBF1l5QnwOfdtKmHyI23kTv5API/VVx3D1SMxSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWAquhKkYH6C6ZOV47zw+KNWCXbGDoRnISafXuXe9b/G7Qv8u/EJf/ilwVG6pK/oC
	 APZkYoGvYqEz5NWo1Rq+D2/jyJfdKpq4XxMJ/VTHhGDtJqLS6NxXOp0t/CWgE8S1WE
	 wulERDoWlXSwPcmcShW+T1KurvP4PD53T1LEAfqM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 308/332] iio: imu: inv_icm42600: use = { } instead of memset()
Date: Mon, 27 Oct 2025 19:36:01 +0100
Message-ID: <20251027183532.986901256@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 466f7a2fef2a ("iio: imu: inv_icm42600: Avoid configuring if already pm_runtime suspended")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c |    5 ++---
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  |    5 ++---
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -751,7 +751,8 @@ int inv_icm42600_accel_parse_fifo(struct
 	const int8_t *temp;
 	unsigned int odr;
 	int64_t ts_val;
-	struct inv_icm42600_accel_buffer buffer;
+	/* buffer is copied to userspace, zeroing it to avoid any data leak */
+	struct inv_icm42600_accel_buffer buffer = { };
 
 	/* parse all fifo packets */
 	for (i = 0, no = 0; i < st->fifo.count; i += size, ++no) {
@@ -770,8 +771,6 @@ int inv_icm42600_accel_parse_fifo(struct
 			inv_icm42600_timestamp_apply_odr(ts, st->fifo.period,
 							 st->fifo.nb.total, no);
 
-		/* buffer is copied to userspace, zeroing it to avoid any data leak */
-		memset(&buffer, 0, sizeof(buffer));
 		memcpy(&buffer.accel, accel, sizeof(buffer.accel));
 		/* convert 8 bits FIFO temperature in high resolution format */
 		buffer.temp = temp ? (*temp * 64) : 0;
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -762,7 +762,8 @@ int inv_icm42600_gyro_parse_fifo(struct
 	const int8_t *temp;
 	unsigned int odr;
 	int64_t ts_val;
-	struct inv_icm42600_gyro_buffer buffer;
+	/* buffer is copied to userspace, zeroing it to avoid any data leak */
+	struct inv_icm42600_gyro_buffer buffer = { };
 
 	/* parse all fifo packets */
 	for (i = 0, no = 0; i < st->fifo.count; i += size, ++no) {
@@ -781,8 +782,6 @@ int inv_icm42600_gyro_parse_fifo(struct
 			inv_icm42600_timestamp_apply_odr(ts, st->fifo.period,
 							 st->fifo.nb.total, no);
 
-		/* buffer is copied to userspace, zeroing it to avoid any data leak */
-		memset(&buffer, 0, sizeof(buffer));
 		memcpy(&buffer.gyro, gyro, sizeof(buffer.gyro));
 		/* convert 8 bits FIFO temperature in high resolution format */
 		buffer.temp = temp ? (*temp * 64) : 0;


