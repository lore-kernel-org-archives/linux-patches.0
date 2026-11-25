Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623899;
	b=QulhKmRBouFa7V2RoLC740fFcHcznfmJFqSSkQKjwqE3Mc8RzuQebwjnIb/tHYzZrFEN
	 Jf8+EQhZi0Ighc6RZMdBQt1UHpd7+A++5jrNiCbxvb1ewLYoLgFqDSCnpJLK0ddJpMig4
	 uPR0/gXpoCUwBpVXdO/13ODdQeX6KzaY2lj0yNYKiejO1ZD0pQpuW5hEutoHlRZpDaBCj
	 0C5iQVdyMK2+WqxF6x+/4C4S5xmS1T9r2UXt3hkD/lswj/RzxpaGrTlctrxUXHKBQZz0m
	 K4j94f5ro7wMg9dHWlZpsVwHQ1gRj50NoFzBWvMHijMoCEgwJlh5UH/3xAu3BMgwm9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623899;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O5BltV3HlIS7YRMoRfL/TBqpzq63q0wmq+sGKurfrbw=;
	b=fWVLZJW2h9qek/hpmvIx8hvXgzKkEaIwpiyymzyvBy3u3Xk6v+/KUGSDwlEgm2gKEDX7
	 8F1HcN4Kx1ffjzCgdZsMs4n4l+rNBPBkzSKtVQHNFRs7f8vOBKbqv9mBisLmzPS15IBDl
	 YO80Kq83gvLcCjXCxHFOZ9EmUhcEla7csBg5VFD0cJm4l1LyeV7PUcREKlROdJwgaLlcI
	 uQ/dPA44zogaGXr7ooE5ToL1cBMVHscindM7LsASq3HNu0Vn99ZBudmgw6nTD2UoalobJ
	 s94iPw/TJ4tQjNXFYVLRygWn+rcWviN/sBpv9HCvu6GW9MF38BIV65ycmAZNq9/geog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="R7/TX8Wi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB16606A31E;
	Wed, 25 Nov 2026 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R7/TX8Wi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC5A1F000C4;
	Wed, 25 Nov 2026 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623899;
	bh=O5BltV3HlIS7YRMoRfL/TBqpzq63q0wmq+sGKurfrbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R7/TX8Wi8z+VsrwjxvfU7OKHe9utxyHW0P+hEIKVbgS9jmi9f8d4QaPlh5GmYKb3p
	 ZEGcG2AXu1mmRkMlEStQM+lX4XhYVGYL4dM3GvBVzjlwvZ1qAAz3XFmn0HamILBRUm
	 nHTTiIjtlg9nJMTGr68Xo70O9+ToF/X4r8+OPMgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/816] Revert "drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts"
Date: Wed, 25 Nov 2026 15:26:09 +0100
Message-ID: <20261125143849.707228616@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 3bc8829ce42925dc384b4d5c4fb355e380ad1cb7.

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



