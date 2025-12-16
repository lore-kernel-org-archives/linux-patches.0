Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A201A3491CF;
	Tue, 16 Dec 2025 11:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885161; cv=none; b=m64cxVT4exrrabzonBemfpy+a7TsF48ze9UDyqC/qwrMOApMfL13Qw+8APda5L0ajz4jOAtncFPAA1ws9EL40nOt7Lwslvy2lkoa2aMg4wViU6YW/CT7Wjza+qSNiz/orcYBCPPKdRZIF/ewa3tLZoi0Ql51X1du9szhu3R3NLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885161; c=relaxed/simple;
	bh=xmJcuaMufgc3GYvM+u3Xey4Yc7N2xXBeRLpEikD0cHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cFAxVRgmnIGJDuGsZ/zB4dd/+rW7MB+vIFIuIIEMwBk/8FROZa+otj9HpyZP8cJLXpxs2sP3r9xTXrrDBtfBaFZ4UyeS1yaauoqGbH/p58zoeYPS7NVMxcPih4DQE5Nte7Fb+5yRnJYY9DgjsmWrqW9FhHd0ogUkei4BfcieYuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEcq0o1E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEcq0o1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9586C4CEF1;
	Tue, 16 Dec 2025 11:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885161;
	bh=xmJcuaMufgc3GYvM+u3Xey4Yc7N2xXBeRLpEikD0cHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEcq0o1EwdFWBTRgD9LR3eK2oWaQkCfu3uSzmrlSdvwZITVda3gFuKl9a74SgqTsx
	 yWesfs5djEGheMydAmEzEHl7wC9Dv2WP1faj/MwX9Viyd3KH12S+6whC5FM2iQnbA9
	 dLZYwhm0kMdj34AYHIJeaveKSo8GYqJLhY31ELbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 055/507] iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member
Date: Tue, 16 Dec 2025 12:08:16 +0100
Message-ID: <20251216111347.537063043@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



