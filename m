Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1015A32FA3D;
	Fri,  9 Jan 2026 11:53:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959593; cv=none; b=f07tZ6AxouZOgBUAjxiyE356Y+PDMlupL3poavrrIVsx/lSApOO0+O7HnCWfezHmfKhm5ltSFA9c6+L1ZmY7LTFykHAp3eMhteCI7zfBKoVA8a2xyUM/a9hKP1Xk3W0VBOiTNuKKKRyJ2RUjWqOL5nz9QUhThN+dopkEOGZn0hI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959593; c=relaxed/simple;
	bh=5bTYUTKF7cNUPVGLGb65qED3gy3jba3kiyMhsmxrIVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gIkatCMN/wycx1dAzS5iYyzssa8XGSTrlRcY2x49K/mjqi5oG6vdFaK6QvEpOK5oy7ylbmWl/pLPHIxIP6+5xptK7m2pn5rJP3cJIZUS8VkPQn43nhTDeU2+XFvM1q+p8uiCgpQ6dMiBf8U4Khzgv6sSovBGMmKs1nkzO4Ju1Mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H20W1Pha; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H20W1Pha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946CBC4CEF1;
	Fri,  9 Jan 2026 11:53:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959592;
	bh=5bTYUTKF7cNUPVGLGb65qED3gy3jba3kiyMhsmxrIVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H20W1PhazBVor2c/cJ/iWc4dRu7OUwvyGvTtQTkVW/0LYXQfLq/AOeKd4du8OTDxG
	 m9iPSApdcgGpC3/4LsA0UkhFF9Y23KApZsNmXDy73jRokrCLG6Bo29wwJKtVVFbnCo
	 /xbG7ys2eOZoUnzwg+AtIEbT48ELV9eVpE6GRVSQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/737] iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member
Date: Fri,  9 Jan 2026 12:33:32 +0100
Message-ID: <20260109112136.742680663@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 35325d2e1ce6c..33b5c660103e4 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -381,7 +381,7 @@ enum st_lsm6dsx_fifo_mode {
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



