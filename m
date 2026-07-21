Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F067C282F31;
	Tue, 21 Jul 2026 21:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668841; cv=none; b=bh7G3TdIyMBv7+48u8ErBz9mtlJqSbgc9r5uf8JrLf/DLJbT8YzTxy0dnlLeDhwnlnuZke5S3B+AzGSqQHBjnYY7G4yf8TJw/0alkQ4sq10tb1iMigDt7aEE8FDKZTb8d0VTGRvd4Z5leqmSf9WMDskhWln6xx5SvLK/mZOeRB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668841; c=relaxed/simple;
	bh=LMiCwwh+K/bPq6I/HRcS1Te3zzC0jKMyx0pMOE6jZIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7/bSqg4oSaKBdfIcejj0uM9Qzd3H3Jhk00OT896iuG7x4SBjhvAxl5su+s+TrshSHKIOJRNnryNX9vOhvNmprCcEhwZcDs5uprY2xaW2ZrhcV838nFiRR8SvaeUhLAEUdrIVB7kQJyUZyiA3XKMOJ3zglutVX4Jr33SXaxCh18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lEIqFrrV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lEIqFrrV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619B41F00A3A;
	Tue, 21 Jul 2026 21:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668839;
	bh=RXfKEeMLCJFgoOCAjO9GfXX6b/x96EWKfh5thT/F7tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lEIqFrrV9cRr3/urTxcuSkfXbgAPniPZ+OXFW0sb+1pL8qKwI0We0OHPP1yn/ULEr
	 oPMGj7+j/OVKP8l9xJWS/F1FrsgYEVFFciLj4GVt9lsjuUJGjpIBiMhwm3XZQRaZYU
	 RVGrDL+eRC5HekbGKGeqGkSM1Sr53aAHQrE9FgJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0326/1067] bus: sunxi-rsb: Always check register address validity
Date: Tue, 21 Jul 2026 17:15:27 +0200
Message-ID: <20260721152431.883930353@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 226e87b85116ea..21e7d8a4cc5aae 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -442,6 +442,9 @@ static int regmap_sunxi_rsb_reg_write(void *context, unsigned int reg,
 	struct sunxi_rsb_ctx *ctx = context;
 	struct sunxi_rsb_device *rdev = ctx->rdev;
 
+	if (reg > 0xff)
+		return -EINVAL;
+
 	return sunxi_rsb_write(rdev->rsb, rdev->rtaddr, reg, &val, ctx->size);
 }
 
-- 
2.53.0



