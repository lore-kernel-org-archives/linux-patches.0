Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B66746A5FB;
	Tue, 21 Jul 2026 17:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655952; cv=none; b=a4J959Ydx5bXdLjWoVphB6Ve0ktZywMyPzBrF8WmlEMgHSAhrxg7y5SOqUl7wHSn0t6R0JEWhQPOgA2n2litANUfnlGdIgC5dD4JAHmh9u6AsxSFoMQNs788ZpQlhRwbhjPB5Hg/FjPC/yPATYu2sSMH7NuFmByY+2WJP+XW8ck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655952; c=relaxed/simple;
	bh=Jl6zglAEowK0YhdUaa7xK/sfPdnEJ1W7HlTlXHDT63I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USbXKFR0wB+0CzVQ0D21GiRQIZswyr/acbUsPMpiY1MBTCx6MRgm1e0byTQ1Yrxxr3mm4BFpVOfsVh9PyTX634Eo9ab7yhXBYP4nZJW0pJO/FagBBWjFtj5p3OQlSKjlLSBfdyji9ZXX8Hr6a7uFk5HIwiVnabZjzXUWIG5c2gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOhwp9tw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOhwp9tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896CB1F000E9;
	Tue, 21 Jul 2026 17:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655951;
	bh=0FyLuTxTrfgFd8o89YlBR8UELZ0v1ygrecUwvvYpQFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nOhwp9twnR6Y6WdBfw91s7Hi93e4ypPhEIg6WiwNCyUscTnFepkdXhoFQQhNsI8dk
	 Dde1GbKJiUB8ztysNf9YzyqpRPtJDRqSmrywxqaU3lBXpSHogvpTFdbCElDBCFaO8v
	 d8ZU71PQa6KdlsajfUG8YjndVZsKtpRcn4KM1B7k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0204/1611] bus: sunxi-rsb: Always check register address validity
Date: Tue, 21 Jul 2026 17:05:20 +0200
Message-ID: <20260721152519.555910116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 7a33c3b31d1e94..9e007fa4c75dec 100644
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



