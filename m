Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DDFE4195C9;
	Tue, 21 Jul 2026 20:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665762; cv=none; b=EjMRni7PDE+FGq21Z+bA+GhsXRpldYN/2fU7zK18R1k105YEgLdV35bK3HacExeWy92+/jm1ethR59RZJWq888+CEc/zqWGXiTGlGCr5BTXuUfP8zBwdA/xWyz4y8Ht9zyibyedJDqObl3ZHtuqDTt+Tzoy5jaK+Mspr4Oj7/g0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665762; c=relaxed/simple;
	bh=zjSRAhjLXf4CBIYbOJAjzmGv2IbqroCMCw9TvDCQqyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e9DwKJDgbjSe3pBCRiCv2r1fykhWn3nzBvK6oI1s+mxQ2T6r+hgxkCj+PHBxQqjRr7S3e57oOldw+o2RZ9biCv9FwHEwqjaZ6ryjC2yfOab8W5DgiNVBXLzeKbxU8S8LcS0WXpYpGjLlw7wudR2Lyt3ESdJbzCgZVS+r8J6qjQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vgcVVobr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vgcVVobr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38431F000E9;
	Tue, 21 Jul 2026 20:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665761;
	bh=kaaBsSejQ9zzuyqSmStuH0+E2RWiVJHxCNLY7SpIBa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vgcVVobrTkUDwaGC3sRU+p+jQ4cOqn2Q0sE6BlHmoY2sfAd7+mbTc1KpLzM1SeiKm
	 3ltXGF1AP6cCuHopBXjKDIynACgAcOUs8uFa/zdXvNMNZySD2QwjuClO3KqKedVuEf
	 Wjvxyw2fWZtK1KRIBliwPGvjE9thOEIaGkVGLuT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0427/1266] bus: sunxi-rsb: Always check register address validity
Date: Tue, 21 Jul 2026 17:14:24 +0200
Message-ID: <20260721152451.395583615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index db0ed4e5d315fa..c2b2e56331d1bc 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -447,6 +447,9 @@ static int regmap_sunxi_rsb_reg_write(void *context, unsigned int reg,
 	struct sunxi_rsb_ctx *ctx = context;
 	struct sunxi_rsb_device *rdev = ctx->rdev;
 
+	if (reg > 0xff)
+		return -EINVAL;
+
 	return sunxi_rsb_write(rdev->rsb, rdev->rtaddr, reg, &val, ctx->size);
 }
 
-- 
2.53.0



