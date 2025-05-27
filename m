Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD98B86347;
	Tue, 27 May 2025 17:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365411; cv=none; b=N1DXiphqyJRinrNruY4Tdb89yjLjIQ9Op0wI6u/tmgckeJfrNFWlmY8JM0xhBfEeNO0HwiLqhW2PTqUdqm0WQT2yS8JeuCrTBqbpt4ZgBCeoQTkF6PUlsit6f51UkCFJ22AsTQ2RPT4PLriO0iULpSNBPS6LVfrVASGRvIMd/Pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365411; c=relaxed/simple;
	bh=SlcwXPZmSeftt4WBx1obQezHocuZSshdRcD8L+A9uts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=caeMLe82jjf1Ftne6O+EEVC/Wz0sxh7dEbqaxLEsvLNBSFzNfEtAqQ5hsylolk/hN/bwLTTpmsGZpT1DkNzrzeYwrpM5Rh0bS5ariQI2xzJU46pQvC2R1pcZNj2zT5kDnRfp+jEOIPiznnVAM+pPBjbU/+G06aPaErBorEXlmm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbwIOPdy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbwIOPdy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 332FDC4CEE9;
	Tue, 27 May 2025 17:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365411;
	bh=SlcwXPZmSeftt4WBx1obQezHocuZSshdRcD8L+A9uts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WbwIOPdye55tM22kqmltz2V9KHal0G1E0n0vgKp0aTvHqDYowJqtxik2KOlvgkjhA
	 j4vSQCbNWPt2Tog/8rf0BJoPFuCeYVIRKV5wGiPZflYHgdhjVafKGqoJlChVXsf6R3
	 beAKXHQjCrAXQEBizK5IsO8FuA9sND8VDrsO+0ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Plowman <david.plowman@raspberrypi.com>,
	Jacopo Mondi <jacopo.mondi@ideasonboard.com>,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 367/626] media: i2c: imx219: Correct the minimum vblanking value
Date: Tue, 27 May 2025 18:24:20 +0200
Message-ID: <20250527162459.935207363@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Plowman <david.plowman@raspberrypi.com>

[ Upstream commit e3b82d49bf676f3c873e642038765eac32ab6d39 ]

The datasheet for this sensor documents the minimum vblanking as being
32 lines. It does fix some problems with occasional black lines at the
bottom of images (tested on Raspberry Pi).

Signed-off-by: David Plowman <david.plowman@raspberrypi.com>
Reviewed-by: Jacopo Mondi <jacopo.mondi@ideasonboard.com>
Reviewed-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Signed-off-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx219.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/imx219.c b/drivers/media/i2c/imx219.c
index 906aa314b7f84..eaa1496c71bb2 100644
--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -74,7 +74,7 @@
 #define IMX219_REG_VTS			CCI_REG16(0x0160)
 #define IMX219_VTS_MAX			0xffff
 
-#define IMX219_VBLANK_MIN		4
+#define IMX219_VBLANK_MIN		32
 
 /* HBLANK control - read only */
 #define IMX219_PPL_DEFAULT		3448
-- 
2.39.5



