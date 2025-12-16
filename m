Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149363469FA;
	Tue, 16 Dec 2025 12:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886903; cv=none; b=pyzJLk6jKAL1IgXf29sMAYKoywD0PUJAyOJywYcCLHTdV2HzYVQ14UImxNNojRShfVqK/azXaWjr1mpukeDsccF7OPGDr8hireFUtIQIUFtIpai8PYcCasViF3e9RszDUbVr7+WIPfqgA4N2IR6W29fI1vV7+CrE+nLK9hBxqXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886903; c=relaxed/simple;
	bh=Fc59Jp9VtR2m5VeG4aaFDFBpLjbGaecUChy/btoUCe4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+JLhwGWP87kLecMNHmiswkr+202bX0Ex0k5BW8bufIMdPt3L4UT6cQ7nW2QaBd/yruD5zP9LA2G+TGMjwiUFJR1WNivRVYT5SCs+D0AWWFc5kno08Dj8ctiC/3AWRFRD4t/xUbYl+8xyhEfBKcJxDZYtWIl7bjb0BhhtcrUfGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HmwSZdI2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HmwSZdI2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEB9C4CEF1;
	Tue, 16 Dec 2025 12:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886902;
	bh=Fc59Jp9VtR2m5VeG4aaFDFBpLjbGaecUChy/btoUCe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HmwSZdI2LfFBLoipOeXUrxbfyifayxjnVCETCz7cKtSieiGm5mlgBbD46qw3KFcmc
	 YajyAauXQK1hT/iv6QiURduBTNvv39ZPrGJ1PJWER4Qc+BXq5lPJFpy3DFs+4uirzD
	 R7hZwNTC3fRBgNfU+VewwHEXv5sf28vRSTIbGwHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/614] iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member
Date: Tue, 16 Dec 2025 12:07:07 +0100
Message-ID: <20251216111403.486509558@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 381b016fa5243..56244d49ab2fc 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -383,7 +383,7 @@ enum st_lsm6dsx_fifo_mode {
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



