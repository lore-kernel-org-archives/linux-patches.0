Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9ACF70838;
	Mon, 23 Jun 2025 21:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712968; cv=none; b=PAVfuCeHhoNNkKOtcT4IkNpX9df6oXUP2QK3Ho1kFy2+nZFkvhneSjIuYfOxlxBmu/NZFQZD8dRGPMl+hDvepdiDWHTB/0tILLWjjt1MMF3A4DYAR+Rb4sM35TRE/I5VTOlfQ4gC6Wz45hbAJg5KezpPO+sTw1/NpCLBBYN1NjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712968; c=relaxed/simple;
	bh=/jiBKIQ3tpcAhvLcIXEditknz2z2wbouulhjk9QeOKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bwfvt2mfIN2stuX6O6F0v2GZYsx/z0wIcC+v7ORFr/SX1A+EKJ1NI8PFnKB68EiDGoe+VpIgKxugLaDQJC0qL9LE11ZCqIle7zf7Fm3WE1/CuqzcyEjKnHTHhsiaSPg3U3cnQTTf44qmdqFWX/7jwHBfJC47NQr+2jJ9XrWeDZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RG3WV8g/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RG3WV8g/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81FECC4CEEA;
	Mon, 23 Jun 2025 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712967;
	bh=/jiBKIQ3tpcAhvLcIXEditknz2z2wbouulhjk9QeOKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RG3WV8g/oi27owGwtLtlhqWe8yT0Wka8UpPSkn9TB4Z9P3QrholWaudHZHHR9niGC
	 HlVkxKUbBirlF7FtBOxB6MLue/Rbp1Pqh+rJUuD3nAvpqeVbpZv6qCTAIHXFs3v1oU
	 zNLryKRvqwaNqM2pXi6WqbP4AS6i6/BoCMi9eQgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Chippa <shravan.chippa@microchip.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 303/592] media: i2c: imx334: update mode_3840x2160_regs array
Date: Mon, 23 Jun 2025 15:04:21 +0200
Message-ID: <20250623130707.603660365@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shravan Chippa <shravan.chippa@microchip.com>

[ Upstream commit 35132d039c566b0e9d8e53f76f512b22607c2405 ]

The 3840x2160 mode operates with the imx334 reset values.
If we switch to other modes and then return to the 3840x2160 mode,
it should function correctly. so updated the mode_3840x2160_regs
array with the imx334 reset values.

Signed-off-by: Shravan Chippa <shravan.chippa@microchip.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/imx334.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/media/i2c/imx334.c b/drivers/media/i2c/imx334.c
index 63d812a41542f..b47cb3b8f3689 100644
--- a/drivers/media/i2c/imx334.c
+++ b/drivers/media/i2c/imx334.c
@@ -352,6 +352,12 @@ static const struct imx334_reg mode_3840x2160_regs[] = {
 	{0x302d, 0x00},
 	{0x302e, 0x00},
 	{0x302f, 0x0f},
+	{0x3074, 0xb0},
+	{0x3075, 0x00},
+	{0x308e, 0xb1},
+	{0x308f, 0x00},
+	{0x30d8, 0x20},
+	{0x30d9, 0x12},
 	{0x3076, 0x70},
 	{0x3077, 0x08},
 	{0x3090, 0x70},
-- 
2.39.5



