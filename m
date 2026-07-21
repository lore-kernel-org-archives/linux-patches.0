Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440F046D555;
	Tue, 21 Jul 2026 15:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648681; cv=none; b=BXBqpRIN2A3BaFMpnn8mI/7/txUrnCIaerJKPWfZp+71vYqF7HCALZLtxDOv7dFn/nL43IW1y5CA+2w6qff+AMf50VBdrHosZytoUT/Pokua/FBJM+Tcp9761ICrVWZCMK1y9V9QIfb5YF5RMiLlRiiAC6hpivi3SA5poD2y9Aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648681; c=relaxed/simple;
	bh=keGUU2Fg8s9OctuOu5UIBPYNx5BoWD/uj4AYR1TiTew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEFzYbu7ni0mxJ1Sfp3fAKJyV6BpfOI0vPkg6glwBa5E0VCOMwUw4k53TMj5iNFmrPYYvnvdyrXruurucNgGYMqpr+CcBuNiaUSkAHVLq7JNzNFGEGuNJtFVEXOuh0ISh9VNbJgStvXhuSPlwuVaXur5E3mLx9pLtt6k4pz5icE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K30ZCHV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K30ZCHV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D361F000E9;
	Tue, 21 Jul 2026 15:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648680;
	bh=6DAne551cy9F8O7N0PXs1xNdud57gZkXp5IaiqRHQA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K30ZCHV9MueDSAv7pvZ3k7pjaALXkxD5p757UijekYWx9EUKnmDxuOaDaguonITKe
	 0CUV3V2vOIUjIEZV8VYXURTJaL95uP8RvMIgcVy+wGdkxJ0/xhY/6Ds7+ZBsbTQOss
	 g7UbrmCS88VLgyeE4v5zG5f/JBwHa4vZtGZN9Vs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0291/2077] bus: sunxi-rsb: Always check register address validity
Date: Tue, 21 Jul 2026 16:59:24 +0200
Message-ID: <20260721152559.540651668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 61192938a5870ac36edae81e4775b680dcf02c61 ]

The register address was already validated for read operations in
regmap_sunxi_rsb_reg_read before being truncated to a u8. Write operations
have the same set of possible addresses, and the address is being truncated
from u32 to u8 here as well, so the same check is needed.

Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Fixes: d787dcdb9c8f ("bus: sunxi-rsb: Add driver for Allwinner Reduced Serial Bus")
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20260301144939.1832806-1-andrej.skvortzov@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/sunxi-rsb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index b4f2c64ac1810f..daf0ea563e4773 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -445,6 +445,9 @@ static int regmap_sunxi_rsb_reg_write(void *context, unsigned int reg,
 	struct sunxi_rsb_ctx *ctx = context;
 	struct sunxi_rsb_device *rdev = ctx->rdev;
 
+	if (reg > 0xff)
+		return -EINVAL;
+
 	return sunxi_rsb_write(rdev->rsb, rdev->rtaddr, reg, &val, ctx->size);
 }
 
-- 
2.53.0



