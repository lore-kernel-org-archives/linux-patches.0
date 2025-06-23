Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AA94409;
	Mon, 23 Jun 2025 22:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716061; cv=none; b=IcLGH4X3QCh3BX7oyqCFVR/jerazpH+q1hf0YsQmjna6GVUOrKil1pLlE/N5ujnk5YPnLSF57KGAh6V/zvLO9kGO4A3VBL006hi0nBDp7KlLl5AFcHDqRncmmEMS1nOsQZGUbRO1CEnPjBZ/cljNv1zlO8xbLdkL0gKPdjnWZoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716061; c=relaxed/simple;
	bh=AfcH3J8OMY6A1P/3ZssPem7TmE43P27wttjjcvhOf4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iHcCQ6yvdoZQcNX8oBoAypxn12IByz0b3kQ68Vv9MGjupAOg0Z9sdRfU+ZcaXg5jcu8hCVFc2Onzeealc49yAR57ejGND0LQb8viBj9rCnGVlf6R2b4MTM6H3GifdChl2FVn6g+am8tpzW3KrAzlvq9P8R+Ekv7BB2MAkGkdPE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ae1Gy4NE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ae1Gy4NE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAFC0C4CEEA;
	Mon, 23 Jun 2025 22:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716061;
	bh=AfcH3J8OMY6A1P/3ZssPem7TmE43P27wttjjcvhOf4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ae1Gy4NEr8L3sy7N0Ie1wa4JWICPb0AcGVfeD8kTdtt+WozeyqmAzfbYkP0PJsqn7
	 N1ojFCnTYrN+4+eKBXcyWFRh8xHUz1TnWxw12pheL7fvowz4Qqhjhwmzn0Dyy2c+cl
	 yz/nHxrptJfJO6WGajvalmDlvzkul3Bf14yzyoUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shravan Chippa <shravan.chippa@microchip.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 300/411] media: i2c: imx334: update mode_3840x2160_regs array
Date: Mon, 23 Jun 2025 15:07:24 +0200
Message-ID: <20250623130641.199602273@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index af09aafeddf78..88ce5ec9c1822 100644
--- a/drivers/media/i2c/imx334.c
+++ b/drivers/media/i2c/imx334.c
@@ -168,6 +168,12 @@ static const struct imx334_reg mode_3840x2160_regs[] = {
 	{0x302c, 0x3c},
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



