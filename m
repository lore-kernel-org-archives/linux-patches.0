Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CCE17C;
	Fri, 23 Aug 2024 00:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724371525; cv=none; b=guYrpq3M4NRo896Rb185yG2j2TjnUWwbq2nP5sj04XRKnvhRdSFpRZ9VtTsnEIHOf/UI698UTilSVzKVv3JJarKhzoEsxL7mK3V3tTenton915MYyX4EPb+U1QsHrGypNsQte8NZB56qgLUJviR2wEGAa78j6kPahIzxCMeKhNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724371525; c=relaxed/simple;
	bh=vXoCjmpAz9/mZBkhiiu2lMYzNQWeQcsKbtbhcAOPHo8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=HgfThaedAoaxazPN/Jb6fI5h9lCPSsHPzhewvRc8tuexPolYvGA/+Una13TSi/z9H9LyQrvGpLtCL3Ajd+lZW1s+plkZ3qgdOO+u9OCmz1159WDE6UQsZ+Yi744Nq4azLdl1VVy+daLhUsS4QzFdliwT/dFAZzhBaHV26zmlNvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U4c9ax7g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U4c9ax7g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73A13C32782;
	Fri, 23 Aug 2024 00:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724371525;
	bh=vXoCjmpAz9/mZBkhiiu2lMYzNQWeQcsKbtbhcAOPHo8=;
	h=From:Date:Subject:To:Cc:From;
	b=U4c9ax7gbfsZ32xF6t+gKLL2KoHjCG/821DDfaIgRjZwMulBwgZA8Y0KKNDMpXF9C
	 geOvQ1B299lvQZhXa9uYBdh+oqK24i9+3wj1XMpIneqYZDbuPraCJ94S5Fp7MzEsxK
	 Xm8uT5vaf2UF8zUIUxDLzJKKRIu01KdS9WbmGmGADXy3UkNsZDd77uLGwOznh9O40G
	 9XvNoVAOvwb3SeGa6t4/Bxi7xxrF3fEz7mIWcx4tPTT3MVQJgZo8YNnMH3VJXiY5Zy
	 gs9zOJ/YrKtnMUONls47P6OGEVYvPpXuyHXHOKGNfFo5uUa6fa4wfrDcjvuupKTOmU
	 0aoY4Js4pYdFQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 22 Aug 2024 17:05:17 -0700
Subject: [PATCH] ARM: imx: Annotate imx7d_enet_init() as __init
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240822-imx7d-mark-imx7d_enet_init-as-init-v1-1-8dfadee3bed4@kernel.org>
X-B4-Tracking: v=1; b=H4sIADzSx2YC/yWNSwqAMAwFryJZG+hHsHgVESk2apBWaUUE6d0tu
 po3mzcPJIpMCbrqgUgXJ95DEVlXMK02LITsioMSqhFGKWR/tw69jds/Rwp0jhz4RJvwo9BOTNq
 QltJAOToizXx/kX7I+QXqg7YSdAAAAA==
To: Shawn Guo <shawnguo@kernel.org>, Sascha Hauer <s.hauer@pengutronix.de>, 
 Pengutronix Kernel Team <kernel@pengutronix.de>, 
 Fabio Estevam <festevam@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1431; i=nathan@kernel.org;
 h=from:subject:message-id; bh=vXoCjmpAz9/mZBkhiiu2lMYzNQWeQcsKbtbhcAOPHo8=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGnHL7lsVpRbXGxxtEnqkrBgxYdJy9UXLb60imni45N/D
 xp77t2t1FHKwiDGxSArpshS/Vj1uKHhnLOMN05NgpnDygQyhIGLUwAmIjOB4X+B1aG1uxdNPS9k
 przRSzzXpI/v/u3ly//JfT93lOmG/vM7DP8DFmbPqIvv9CsJ4D+YtqHb6vm02EX5+qJ/D9b8/Gt
 uzsANAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

After a recent LLVM change [1] that deduces __cold on functions that
only call cold code (such as __init functions), there is a section
mismatch warning from imx7d_enet_init(), which got moved to
.text.unlikely. as a result of that optimization:

  WARNING: modpost: vmlinux: section mismatch in reference: imx7d_enet_init+0x20 (section: .text.unlikely.) -> imx7d_enet_clk_sel (section: .init.text)

Drop the inline keyword (which does not guarantee inlining) and replace
it with __init, as imx7d_enet_init() is only called from __init code,
which clears up the warning.

Link: https://github.com/llvm/llvm-project/commit/6b11573b8c5e3d36beee099dbe7347c2a007bf53 [1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/arm/mach-imx/mach-imx7d.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-imx/mach-imx7d.c b/arch/arm/mach-imx/mach-imx7d.c
index 9587885fb1ac..87632ae0201c 100644
--- a/arch/arm/mach-imx/mach-imx7d.c
+++ b/arch/arm/mach-imx/mach-imx7d.c
@@ -48,7 +48,7 @@ static void __init imx7d_enet_clk_sel(void)
 	}
 }
 
-static inline void imx7d_enet_init(void)
+static void __init imx7d_enet_init(void)
 {
 	imx7d_enet_phy_init();
 	imx7d_enet_clk_sel();

---
base-commit: 47ac09b91befbb6a235ab620c32af719f8208399
change-id: 20240822-imx7d-mark-imx7d_enet_init-as-init-03d0c38e3118

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

