Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606DE1774B;
	Thu, 18 Jan 2024 10:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575491; cv=none; b=XBWGiRm0PSpshgCG5r3ESoEfJXEG1K4n5dkqBxx9Q9x6ZmRinP9K7gITUfr80dUKhznEqtCTURsWedMmXjw3YeO6DEEbOYS8ZFJ+mNwgS5Xhq5BM48KbAVuheCxtP7LjwZ9trM7bGaQj30V08MhSFQaTgZaS2Z8Ngo80Om4STnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575491; c=relaxed/simple;
	bh=HRJfZZJJMrxtp/kwooVRPNEuPQxk873WaqP0MpatvFI=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=QQSWdOvhffM/AmG9gUTT0rPCfovR4Nsa2ZLG3tb8P9fScb7iTLv20S4OzcQWXYAeiQQZ532tqRpWp30Xm2S5MX7tGRioNs+RyDfT+yNPndZ/pRKB1Y0RvTy6dM3h6wGg6+Sz26xu0v0WAe40jqRZMp6N93QxIowX8/wshv4tblE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azA+HLQi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azA+HLQi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D771BC433F1;
	Thu, 18 Jan 2024 10:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575491;
	bh=HRJfZZJJMrxtp/kwooVRPNEuPQxk873WaqP0MpatvFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azA+HLQiUx0jdsvSFi7Z/cPKGXZAo1quO+QF6p6fD6j4x9NqtNBZEWpcEV7RhFIwI
	 BEx1KJ01bdEkiGHxWpFYsSsqD5efblrC5Qe6nkH8N9LnJZDL1MsSxsoRvfgN3RXWbG
	 j0mVmITkNWhQa8j8H8yGcSiYqjUO2OD0svhZgs9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 125/150] ARM: sun9i: smp: fix return code check of of_property_match_string
Date: Thu, 18 Jan 2024 11:49:07 +0100
Message-ID: <20240118104325.835853789@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 643fe70e7bcdcc9e2d96952f7fc2bab56385cce5 ]

of_property_match_string returns an int; either an index from 0 or
greater if successful or negative on failure. Even it's very
unlikely that the DT CPU node contains multiple enable-methods
these checks should be fixed.

This patch was inspired by the work of Nick Desaulniers.

Link: https://lore.kernel.org/lkml/20230516-sunxi-v1-1-ac4b9651a8c1@google.com/T/
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://lore.kernel.org/r/20231228193903.9078-2-wahrenst@gmx.net
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-sunxi/mc_smp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-sunxi/mc_smp.c b/arch/arm/mach-sunxi/mc_smp.c
index 6ec3445f3c72..277f6aa8e6c2 100644
--- a/arch/arm/mach-sunxi/mc_smp.c
+++ b/arch/arm/mach-sunxi/mc_smp.c
@@ -803,12 +803,12 @@ static int __init sunxi_mc_smp_init(void)
 	for (i = 0; i < ARRAY_SIZE(sunxi_mc_smp_data); i++) {
 		ret = of_property_match_string(node, "enable-method",
 					       sunxi_mc_smp_data[i].enable_method);
-		if (!ret)
+		if (ret >= 0)
 			break;
 	}
 
 	of_node_put(node);
-	if (ret)
+	if (ret < 0)
 		return -ENODEV;
 
 	is_a83t = sunxi_mc_smp_data[i].is_a83t;
-- 
2.43.0



