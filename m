Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326C8149C53;
	Wed,  5 Feb 2025 14:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764886; cv=none; b=uk7yofZe69FA6YttQiG+R9+Os1SA86tpdr3WR+kQxEOXIp7UkYp3Fx3EAHWWx0EIjFT2IILNXV6l7+TmY3AzXAauFCBvFjb80459/EFDsjCdO5+k65/6C2hmJg42LtPZ2GdgJBOZjMq72ZxoNcCYOWPeambM2DE/jIAUvf2l1Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764886; c=relaxed/simple;
	bh=qQYyA0rvYavuxddvyRrIM5UVXCFmH8x7bEtXnru7s8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NNFv75o/4GnzoAUTxiXICdifqVqKZPfX8j1M0rqyc1/9MrODZwk438Ongi21Smojfm9bcC2vAflidhi21YOJnLwlD9v8hyZJhYW4mgfx9MdA36WHHAY7o6suPMVUWbr+U0sXLi9txgx6+G8qLJ2e0M+KeGxr7Mg987yEbib2EO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0VhaJUA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0VhaJUA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9777CC4CED1;
	Wed,  5 Feb 2025 14:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764886;
	bh=qQYyA0rvYavuxddvyRrIM5UVXCFmH8x7bEtXnru7s8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0VhaJUANS7wVuy4mihPakIhFH0QQqVS4bJh9IOp7BKhQUL6QSV7MW6qsdPODfCov
	 HzxRE4m4+x/8UvUoJCTKHBkETxlt1ZH+bL2ww6B0teqzJgDjW8Ey6GaIJT9VYPC0Xg
	 u2pC7c2S+uHIejKw9MTWDL/XD8ALpfhoa8jDUYo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 166/590] clk: ralink: mtmips: remove duplicated xtal clock for Ralink SoC RT3883
Date: Wed,  5 Feb 2025 14:38:41 +0100
Message-ID: <20250205134501.633659808@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 830d8062d25581cf0beaa334486eea06834044da ]

Ralink SoC RT3883 has already 'xtal' defined as a base clock so there is no
need to redefine it again in fixed clocks section. Hence, remove the duplicate
one from there.

Fixes: d34db686a3d7 ("clk: ralink: mtmips: fix clocks probe order in oldest ralink SoCs")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20250108093636.265033-1-sergio.paracuellos@gmail.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ralink/clk-mtmips.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/ralink/clk-mtmips.c b/drivers/clk/ralink/clk-mtmips.c
index 76285fbbdeaa2..4b5d8b741e4e1 100644
--- a/drivers/clk/ralink/clk-mtmips.c
+++ b/drivers/clk/ralink/clk-mtmips.c
@@ -264,7 +264,6 @@ static int mtmips_register_pherip_clocks(struct device_node *np,
 	}
 
 static struct mtmips_clk_fixed rt3883_fixed_clocks[] = {
-	CLK_FIXED("xtal", NULL, 40000000),
 	CLK_FIXED("periph", "xtal", 40000000)
 };
 
-- 
2.39.5



