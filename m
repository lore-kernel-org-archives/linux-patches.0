Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1422241E9;
	Thu, 18 Jan 2024 11:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575715; cv=none; b=peQKZATWr+YY5PNIcCpOW/1C9UtM/Y3kBTF9Dd08WqZiqIYqMz4GFJ0RrY/eG6TSE/rptgp8UYdyFyM6l55YY6Kl8aaur6lm7WmwvM8IXYz4+cwh3RaN9nyQIiDCM2DPF5JT2AQvRcG0b3yDPIJIHwKFmCks9Kh9woJmgiJ8w9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575715; c=relaxed/simple;
	bh=AjoJOwUdDOduSpuVNiB8ax3+N4+OuESuNlHxbB6Hdn8=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=gKYepyq7i7L/gQ+0xjsgAilRSXnU+PnrB5wpL1Pq4bFu4QzdrcRHjtsmGnhLAKQft2bJk730LjU3LojNGWvEWFxXcGC1dPg1ga65sYzVbQYKXGzcflBGaRqRSMfmRsWd3M0T6wPGEJMS5TeEit4u2WM3/ojiO3pzkWZ1kSgtUdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J9mlp5Br; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J9mlp5Br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 541D7C433C7;
	Thu, 18 Jan 2024 11:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575715;
	bh=AjoJOwUdDOduSpuVNiB8ax3+N4+OuESuNlHxbB6Hdn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J9mlp5Breb+lUD7EgCIAQaVOCWo/FQw9/jwKhgDJzhHN57YBYBxvM9EKzHicZ4Yxg
	 O1Rd14/0qJpmYkM5/v0HfmGPH+vidrHD87m3rBslYjWOWc02/qVKPpBqgF80HVIeMG
	 LnuYl1NfrWMJVMczfSAgjbbOvXFbSYCSYBLaDNOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nick Desaulniers <ndesaulniers@google.com>,
	Stefan Wahren <wahrenst@gmx.net>,
	Chen-Yu Tsai <wens@csie.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 080/100] ARM: sun9i: smp: fix return code check of of_property_match_string
Date: Thu, 18 Jan 2024 11:49:28 +0100
Message-ID: <20240118104314.381397901@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



