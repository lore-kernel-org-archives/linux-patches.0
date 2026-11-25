Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617584;
	b=Ret6FjfdZ1aExvy0zPyQtKcoqRbKZ562Hh0gfntWS8GAchUKzXNHJzhS4Yw1moC787OP
	 rRpgBMy5beuG7N8vaY5r8ZrFXvUaFAGfzI4XiGtlTqrUzKsET13NzL3pHSQ3hPzKBFBhj
	 UuOrjpvQDeblQniQ2PFbOkUFnQ6uyYjvIpTjEs0gCO2amij9m9imPQa9Io/vzF3k8jwg2
	 +9YdsRTE4IlUXGt5QbxAsMrZKzGvJhlUxTcgOc7wgnCODbaBJsmoGFeoBYLQoKQd6BRo5
	 hTC0cxhfjldez3HDQhbwniQbfau1UKcMiLCOnJrCByvvOanOIHKb1amJknZV2jFuqlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617584;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3c1HPq3zjBNrW3Q8UB5ce5Mb0qts/IG2leLrTZ8gP5U=;
	b=A3oMKUOmWWCwPhegSZsi980zWNl8Osy1YbrkPWat8wDz9ANBglYNaBplM0g+l/PaLLHo
	 bXGK3LC/k43cC2wkeuVKsqdiEFamBYWeB4IiCXpUNyHxTMX3y1BaJeTtoxKD/owEEmi9u
	 gqSNJmilTWRcQpDd55nJ17ATiJ4n7JbBrRklrXeU+qS7cV503pcFc+/kFegIELjxsW9YP
	 vr+l4MAn2BRxDMjpDNhmqi4kd8bNoeiE+daWmoCAT0zvstSTsxWdzG/Z8QZrO/TkyN0Yy
	 8FTBT/QjwKGaJaEA8ZSsz2xjeYC3P12V0pF0Ysh0S9fWG9X+GvvictwBihQS0VDx9AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnHiRxcV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1943C606A31E;
	Wed, 25 Nov 2026 14:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FnHiRxcV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284201F000C6;
	Wed, 25 Nov 2026 14:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617583;
	bh=3c1HPq3zjBNrW3Q8UB5ce5Mb0qts/IG2leLrTZ8gP5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnHiRxcV7psK/m95L4TiHWC8X+CRAgVxW8MHpu92qcBgYCMdfukAIwENXtigUCjyx
	 hib0JcPW8QYUJR8DxShee++VbA6+Rg/mVbtODUyqAyA1ShrxRvcmZ7PdYU370ZULA7
	 mzOMPl+bh4T7UQz+0539hAVVRxExUNV8Eltx5gB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0012/1005] Revert "drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts"
Date: Wed, 25 Nov 2026 15:22:30 +0100
Message-ID: <20261125143822.024868803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 992f7f5f34f803144c9cac31d49ff853d8e861a9.

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



