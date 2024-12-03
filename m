Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D231F7545;
	Tue,  3 Dec 2024 15:14:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238854; cv=none; b=ecAdD9n9zVaARQFEXhXLLxbGDKs+Jy95rVcywGoVKbwo7ghOVQXf3NIBGwEckkXTYDz7iJl4NOnYA8uqT0ag4RFPeH3Rz4O2nJDMj4p2yeCc81Wgyh7cmJwSLg+NNVdzVDcOBG96C2E8dNMi8q8KH4c8C5fgQToh2fJtdd3C9Lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238854; c=relaxed/simple;
	bh=tra5ktCJm1gMKMr1j7+8mg+Zr/FHKuv5CgynZjMdMXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cH704vge50nyuHjmktcfYWVzKCTWzZlNkkXe99xNgRmjukQglh0oMkycdByJ5bKEUnwV9GNUNlQrO5sadl4Ocl+8XQQmhbFc98V+w1Tidxh1aIDgqNi4nmuEW1nIj64/B8yBCvEfYGCWm2EUX/PKPu7rRg/aiJSojlFR1Ch0MwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AspitTfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AspitTfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E09BC4CECF;
	Tue,  3 Dec 2024 15:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238853;
	bh=tra5ktCJm1gMKMr1j7+8mg+Zr/FHKuv5CgynZjMdMXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AspitTfPwa2cEbx9UilYjvTsGnVZtv36zIpMHEv+2ml+INOA3uEf0XFcDSuajfW5S
	 b2KBbGGrb5CSnV+Yc4TondcYaJmSTLh0Nce9/L2EzXF0L1LUgX/LXR9J8O/fZAINK4
	 TTzw4TKFwyIyUHDUr7Cw/hLPFEu/8V0YkWPtPnW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andre Przywara <andre.przywara@arm.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 420/817] clk: sunxi-ng: d1: Fix PLL_AUDIO0 preset
Date: Tue,  3 Dec 2024 15:39:52 +0100
Message-ID: <20241203144012.273669220@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andre Przywara <andre.przywara@arm.com>

[ Upstream commit e0f253a52ccee3cf3eb987e99756e20c68a1aac9 ]

To work around a limitation in our clock modelling, we try to force two
bits in the AUDIO0 PLL to 0, in the CCU probe routine.
However the ~ operator only applies to the first expression, and does
not cover the second bit, so we end up clearing only bit 1.

Group the bit-ORing with parentheses, to make it both clearer to read
and actually correct.

Fixes: 35b97bb94111 ("clk: sunxi-ng: Add support for the D1 SoC clocks")
Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Link: https://patch.msgid.link/20241001105016.1068558-1-andre.przywara@arm.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun20i-d1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun20i-d1.c b/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
index 9b5cfac2ee70c..3f095515f54f9 100644
--- a/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
+++ b/drivers/clk/sunxi-ng/ccu-sun20i-d1.c
@@ -1371,7 +1371,7 @@ static int sun20i_d1_ccu_probe(struct platform_device *pdev)
 
 	/* Enforce m1 = 0, m0 = 0 for PLL_AUDIO0 */
 	val = readl(reg + SUN20I_D1_PLL_AUDIO0_REG);
-	val &= ~BIT(1) | BIT(0);
+	val &= ~(BIT(1) | BIT(0));
 	writel(val, reg + SUN20I_D1_PLL_AUDIO0_REG);
 
 	/* Force fanout-27M factor N to 0. */
-- 
2.43.0



