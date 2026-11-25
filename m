Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620818;
	b=MDcHt/Of96n0LScSGYGdlnVD3GqQSc8BaDQbQUdCSIf/mOxNEebT7qf3QbE3mzJuOLVI
	 O6f4F7GoBsfOHyakofepe12P3lYLqVORCZTTDNXljh2SXfsyEiVlNN9K0JJd4C9VGyuTE
	 mEPoD0YFgZIFRjUGVAd5Wa6hYsh48/W8+BRlC+MfJe7PXnYtzcAU8DDu5rdC9ZGU5WEF9
	 qDlnuvU+CKIC4y6ROKJKZmz2ru5feMtDGUPQYzxwK9vUXUmraGwCuEX8yNahcdn7vUW5c
	 /nlmP2TxfuwBTz5oRRPYCLyiSvHV0jCnreZ+PQ8r4VWFX9Nxe9JS0YucM2tcMC+4KPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620818;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q7uiJ6V/ZkKwbeW0RE20zYl8ibBjpgTzOHlZ1+y7qts=;
	b=QUYG/gNtF7scL9IXmJ1DtOGR3FImrFECSt+NNDBFvnh8pvtxISYeLaSYm12Bc7oLHoVh
	 0WSyYflA2TgWJ2rm1cIhNkZGt31wlD5TMfNXii6gBlrghMT15eoRwJ2spqHvh1NZED7Cj
	 3sXUbZ55PVQOUlQg01hyFpnRGqgibXFFTIzGPg30RsLiy6mhcIQ0DImoDHn7hU4gm/Hos
	 PNoGWGV3eskGz08rrNLaAMglfQDT2O17SRARI2fMUHv1ELmsQj7ipoNwu9HvsITZPIGQB
	 gDVJU9LNFzJZ/k+f1pIKREac7rpaKsZzqmIYP4ZjIrgqbfuknyrQ5O1Pv5m0vRCMkSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rxksw2Lm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BBB4606A31E;
	Wed, 25 Nov 2026 15:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rxksw2Lm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C941F000C4;
	Wed, 25 Nov 2026 15:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620817;
	bh=q7uiJ6V/ZkKwbeW0RE20zYl8ibBjpgTzOHlZ1+y7qts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rxksw2Lmjv2jH1PgPEr8D+rc2DULkAiNSsKqVvBHwAm95aVGA5eJsCsI5hYThOhfu
	 8vJCh+MI0wrj2GbUQ0WJ0Uv0LyFUt40CeZdfkplB2euzvvAmXVTidV3QA/7hSgw9ac
	 /MZNYC6hjnaP3ZgToq/KEwtW1fU9LahQUIWQVj8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 033/990] Revert "drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts"
Date: Wed, 25 Nov 2026 15:23:20 +0100
Message-ID: <20261125143822.864816633@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 15465d681517c6180e709d749c50fba34c4ef419.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/nouveau/nvkm/subdev/devinit/gf100.c   | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
index 186e09ea0cb10..5368e705e7fd6 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
@@ -27,7 +27,6 @@
 #include <subdev/bios/init.h>
 #include <subdev/bios/pll.h>
 #include <subdev/clk/pll.h>
-#include <subdev/vga.h>
 
 int
 gf100_devinit_pll_set(struct nvkm_devinit *init, u32 type, u32 freq)
@@ -100,25 +99,6 @@ gf100_devinit_preinit(struct nvkm_devinit *base)
 	 * can use it as a reliable way to know whether we should run devinit.
 	 */
 	base->post = ((nvkm_rd32(device, 0x2240c) & BIT(1)) == 0);
-
-	/*
-	 * However some VBIOS init sequences miss this bit. So fall back to
-	 * the nv50 method of checking if the bit is not set. Running the
-	 * VBIOS multiple times may have detrimental effects.
-	 */
-	if (base->post) {
-		u64 disable = nvkm_devinit_disable(base);
-		/* magic to detect whether or not x86 vbios code has
-		 * executed the devinit scripts to initialise the
-		 * board. only works if there's a display engine.
-		 */
-		if (!(disable & (1ULL << NVKM_ENGINE_DISP))) {
-			if (nvkm_rdvgac(device, 0, 0x00) ||
-			    nvkm_rdvgac(device, 0, 0x1a)) {
-				base->post = false;
-			}
-		}
-	}
 }
 
 static const struct nvkm_devinit_func
-- 
2.53.0



