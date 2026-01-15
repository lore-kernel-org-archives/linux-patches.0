Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB474A3C;
	Thu, 15 Jan 2026 17:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498899; cv=none; b=N33h2+iEVhzdUwWe2qWB6/ufwTCKAkOwvWP1ITUOCbqJNJb2ZCwRvRNCEND4UOMmuCdBez+zR7ZJ6QoNovLxdM5azY4wP+i+KuurXCVOFTkMBA5oZf8Qx0GHVG4vMdsbW8NYvw229ngB5QGzhBXAhRJBfWC0JKliV4tjZyLXS7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498899; c=relaxed/simple;
	bh=HMlLbiTCNPsUoFqXUWRYcdUsmEfkXgs2fpjGuFvJZQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QXVzjsScHQ4S6WlN4OzK6sBGKuJbXW0zukHuMhZxmcS7ZkIXaYpcLBVi5jf5SSxn5GD3XMPSuyhfbnEDrTaPnCF9G9lTnA1JiHEIqrk3GCYSsn4r+BxNrjN+v24o4tQHTiNx4qIyWPqd94nF/4EdwO2OxySuKr3A6sj4YGTBUmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvk6UKIP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvk6UKIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DED6C116D0;
	Thu, 15 Jan 2026 17:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498899;
	bh=HMlLbiTCNPsUoFqXUWRYcdUsmEfkXgs2fpjGuFvJZQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvk6UKIPITFO/O3bttLFfrWjebQ9nxcNkFNoXKkEkJcw3A3pbxVRyn1fAGSyVUCIv
	 Z3UeI6FIAnAtCMKWXvbrm3zSjL6ZbpDHtSutPQKAof+L/aCeatC5mB4sZK4COSS1Tr
	 TpbX2BFfl38O2HrUX2SYWxO3rXg5NDS6ZBAynUl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lavra <flavra@baylibre.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/451] iio: imu: st_lsm6dsx: Fix measurement unit for odr struct member
Date: Thu, 15 Jan 2026 17:43:58 +0100
Message-ID: <20260115164232.233931917@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3c0ade6ab0d2e..f6df7ed86b4b9 100644
--- a/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
+++ b/drivers/iio/imu/st_lsm6dsx/st_lsm6dsx.h
@@ -344,7 +344,7 @@ enum st_lsm6dsx_fifo_mode {
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



