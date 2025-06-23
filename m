Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7D9219E0;
	Mon, 23 Jun 2025 21:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713543; cv=none; b=Uhoiq1Ss2O05DZuE/lyXfaNw7VzeMknwEJDutj6bnkhYFkvPJ/FYiVyXmkHoeWKPdy3t0VJLnnUZRby3HQoKRmY0GGQoLQGfsMQZ9rilsQO/tXad85eo2tcCbKRIu7aaSdxQQr8Xi9bkNtKlG3yKX832bhErHHrnYxz6xj83bzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713543; c=relaxed/simple;
	bh=iNQtKNkD2Lxblk9OhBTv6Unk2GNXXeygOoPPPPrlx2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ERGlKakn64E/dDM8gfaCJciHMRWUc3kvCIBk7SwZvEHOCiTPziQbazLA5TR5E8oKQM5G/6Uh9p8DtExjcCI+C8RPi70Sb0xERO4aFJS2kZoWC3cG2h+xALLT3I5FBhblCWqngd+kF3E2XVpYWc1j5GKba2qoiXnFdMVHBC8yrX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/x0zeHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/x0zeHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13D17C4CEEA;
	Mon, 23 Jun 2025 21:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713543;
	bh=iNQtKNkD2Lxblk9OhBTv6Unk2GNXXeygOoPPPPrlx2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/x0zeHvnl3VryiRgCHC2NLdqpV64ccAENnu3qKQQbiRgaZk2qqWYdhWjkEP5wsky
	 fx/eh0R+/wSf73QUoBXnTqolIsPoA5WZ9BxzlnJAc+EeDUZStpmokf39MWyuZjPF1c
	 galZ4IaTfVWb2gvZUqGtf4q4dUSaGPC8py4KpBO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hector Martin <marcan@marcan.st>,
	Neal Gompa <neal@gompa.dev>,
	Alyssa Rosenzweig <alyssa@rosenzweig.io>,
	Sven Peter <sven@svenpeter.dev>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 333/592] i2c: pasemi: Enable the unjam machine
Date: Mon, 23 Jun 2025 15:04:51 +0200
Message-ID: <20250623130708.375756594@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit 88fe3078b54c9efaea7d1adfcf295e37dfb0274f ]

The I2C bus can get stuck under some conditions (desync between
controller and device). The pasemi controllers include an unjam feature
that is enabled on reset, but was being disabled by the driver. Keep it
enabled by explicitly setting the UJM bit in the CTL register. This
should help recover the bus from certain conditions, which would
otherwise remain stuck forever.

Signed-off-by: Hector Martin <marcan@marcan.st>
Reviewed-by: Neal Gompa <neal@gompa.dev>
Reviewed-by: Alyssa Rosenzweig <alyssa@rosenzweig.io>
Signed-off-by: Sven Peter <sven@svenpeter.dev>
Link: https://lore.kernel.org/r/20250427-pasemi-fixes-v3-1-af28568296c0@svenpeter.dev
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-pasemi-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-pasemi-core.c b/drivers/i2c/busses/i2c-pasemi-core.c
index bd128ab2e2ebb..27ab09854c927 100644
--- a/drivers/i2c/busses/i2c-pasemi-core.c
+++ b/drivers/i2c/busses/i2c-pasemi-core.c
@@ -71,7 +71,7 @@ static inline int reg_read(struct pasemi_smbus *smbus, int reg)
 
 static void pasemi_reset(struct pasemi_smbus *smbus)
 {
-	u32 val = (CTL_MTR | CTL_MRR | (smbus->clk_div & CTL_CLK_M));
+	u32 val = (CTL_MTR | CTL_MRR | CTL_UJM | (smbus->clk_div & CTL_CLK_M));
 
 	if (smbus->hw_rev >= 6)
 		val |= CTL_EN;
-- 
2.39.5



