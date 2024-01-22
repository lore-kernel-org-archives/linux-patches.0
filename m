Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBCF60261;
	Tue, 23 Jan 2024 00:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970886; cv=none; b=CZhJd86jDNMDFstWvKQKEkwDFeZQEkb3fO4z7PyABZ9LHmAc4X1Cdk4EBhL++5+mFFha1FkViyfazgH6yVl9CBjuC9Jx9Qxx2XEFgIymrpv6pkdpK44R5iZGuYW1LQ/bE2JNcyxW9uzZCScsK4ErJI1OxRjl4sxUptp5/FTRlL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970886; c=relaxed/simple;
	bh=LQcR5VQBrWZdzEpAXor6+XkgHc18rPHHaZO7poUjhTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OssmZX/hzZoiJIa44LiEeEqmEWk1IL68rhzizaFQgsqwpSozOmoxWNcfyHj0WD4s0FjXBUhNHh0dLMFxmn8B0Om7omGoTPrHQt4B/hCvk+AYkN31VJWhMez+wn9pvs3v7mpMGfpUsnIbM+dW61xL0IITRxqLbomN/daHGcTAhrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RMTB2Hfa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RMTB2Hfa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69841C43394;
	Tue, 23 Jan 2024 00:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970885;
	bh=LQcR5VQBrWZdzEpAXor6+XkgHc18rPHHaZO7poUjhTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RMTB2HfaBd8aN8INDEdDenFWusuWs+3t4yUF/RKsuh2E3DoC546f/7HVU5cfGe1kZ
	 holf24KCKUx3rguXuyX3Rr/r3Ay5YANDY+mgNz5UjPJGDVykZ429ltbLuSQNsH20m6
	 XAMF4ocCQa/0Mqp9TKoHv0VHbTfMK9JlyFv4iOIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/286] ARM: sun9i: smp: fix return code check of of_property_match_string
Date: Mon, 22 Jan 2024 15:55:44 -0800
Message-ID: <20240122235733.482792955@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index b2f5f4f28705..f779e386b6e7 100644
--- a/arch/arm/mach-sunxi/mc_smp.c
+++ b/arch/arm/mach-sunxi/mc_smp.c
@@ -804,12 +804,12 @@ static int __init sunxi_mc_smp_init(void)
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



