Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF80C3BFE3C;
	Thu, 15 Jan 2026 17:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497341; cv=none; b=dHc8dS0t4XBr2sK+S5m9j2/QWRnlt7AveRoEF8UJo0631eYvpQYNpScVrBm4GEOUBwV1Acz5SYeWFjw9E4IqXW+2Tn/e4lR9NJF3kxPt2X7x0MMgDkNnOkLM2l64gq1fvYyaijKxYurtdW68Na3xJCOr+46UtwpfZjJSFYiSep4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497341; c=relaxed/simple;
	bh=7EB+fkiWR6kZl+o7QbKc58jqiLUzyMYW5jxSe+BB78I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f11Va+ggkUWpqaMcjFU517viwrwCBGvIf+LoCoOFvuPEGzahY9/iqJna/iLofeep+Nc+MzUUed9NjgpWEcaFNreeVJj2tF8xT66XY0TOed1L6llBcGW/lAUJh1YjAtrpUCXNulydEchHEJBIV907+vRdZbJo1hQZeQ4tKTZpFMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8ze92Nw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8ze92Nw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49277C4AF09;
	Thu, 15 Jan 2026 17:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497341;
	bh=7EB+fkiWR6kZl+o7QbKc58jqiLUzyMYW5jxSe+BB78I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8ze92NwS7/24xzizHTTw7NZXbzb7+xZUanIeBsqOxrWtcbfTYnM1keo84QkLBeMM
	 HOmCeqH8NDCNhvkIVF/6uHZArQuK0YTFcKZVLfHHuBfFkDfnQnXSKozbyl7djEEXl+
	 e0Seqj0eiMTLX/lH7bZbwN7k7iS705XeTobxAyHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/554] iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member
Date: Thu, 15 Jan 2026 17:41:53 +0100
Message-ID: <20260115164247.949146648@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Lavra <flavra@baylibre.com>

[ Upstream commit c6d702f2b77194b62fb2098c63bb7f2a87da142d ]

The `odr` field in struct st_lsm6dsx_sensor contains a data rate
value expressed in mHz, not in Hz.

Fixes: f8710f0357bc3 ("iio: imu: st_lsm6dsx: express odr in mHZ")
Signed-off-by: Francesco Lavra <flavra@baylibre.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
index d448c802572eb..5fce038b61e03 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -348,7 +348,7 @@ enum st_lsm6dsx_fifo_mode {
  * @id: Sensor identifier.
  * @hw: Pointer to instance of struct st_lsm6dsx_hw.
  * @gain: Configured sensor sensitivity.
- * @odr: Output data rate of the sensor [Hz].
+ * @odr: Output data rate of the sensor [mHz].
  * @samples_to_discard: Number of samples to discard for filters settling time.
  * @watermark: Sensor watermark level.
  * @decimator: Sensor decimation factor.
-- 
2.51.0



