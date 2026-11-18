Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059148;
	b=IoDVuPNa5eVP+Ct99LHa/eZbPigyV9g5+TQFNE4NOMssa8X/ITkQE0hZG1opUziTz4vB
	 ++8qlrXkQ219sZkJC7en9vRQuF3nQAI8gnsusDAdNXKuhnenYpAWbsI+9H6vFliN9Dmwc
	 EAl4+pLq3vT2FoCRsLsLISTDf4mUNJYb2rqg7mdJTQGGx9n7mXJYDZIdoBlUrCJOWHPrg
	 zmc48+/jwkxnkEHK2SEJk7yNHPxJtrABL9dGT8p1UD7EEND+tR/KxeMBGEFjuwWsLSuVK
	 Z0XTu4I18OZZDWoCMwdvrXTEAuwc+1yGRRqVi93dLO1yPqznFZybswZOltW3vameOQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059148;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x4LEaioedHV3LjmHFC5M8aMXjLZXzwWLbUfKpSulqbg=;
	b=vi4Jj6Z7uK/xTPDmJ4ceUgwLfuosdbbYhFk2hPib7oRTSEPMiDOIHWNb2lZ6SgvozQnf
	 8ZP0FH9NPWgyZjb5yKqGwhk0TTX3BUSjoTS/f0oDotKc6BPRATdzqFKFFdXVB7MbjSGia
	 ys9fft3J7I0BfwdyZbdpviYUI2p/PnC5HzNSvi+346RvwsWnoT8zPLR9XRmja9dNv3Qbl
	 wpF6G18rEUQ/5WOzgb2l/WvOGd+DxadveONR4h8h1X4+s1uMjwyXUrW0vqdbZ+J0B5xll
	 ZO7jdflQTUoeNKCEYVs655wxFQnlanMPXTE6hNbLkJ3ikwLqp9Eco/xbgvYPiEuqDhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfFU0y5w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D824F606A320;
	Thu, 19 Nov 2026 03:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zfFU0y5w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314371F000C5;
	Thu, 19 Nov 2026 03:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059148;
	bh=x4LEaioedHV3LjmHFC5M8aMXjLZXzwWLbUfKpSulqbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zfFU0y5wJI/JzPjiN8WDlITIx0iGPaSJ6JNNgBx9xGdjq21eGtLPKGMGwK/CJN0+O
	 5KMUzwXx4EzS5RYi6DErM/0BvC7GlwblOoVg9yo90MHWol2CD7o6Z90oBog/APZXy9
	 T2n8bxWaVbwgGd0uTePtml3kLkCdgpQz0oL3qu74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilia Mirkin <imirkin@alum.mit.edu>,
	Dave Airlie <airlied@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0738/1848] drm/nouveau/devinit/gf100-: try to avoid double-running vbios scripts
Date: Wed, 18 Nov 2026 15:46:16 +0100
Message-ID: <20261118145947.255095708@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Mirkin <imirkin@alum.mit.edu>

[ Upstream commit 2139cb633d48ebbbaec88d2e5a8ebe8e774df4fb ]

Turns out some VBIOSes don't actually set the bit in question in 2240c.
Use the nv50-style detection to try avoiding running the vbios twice.

Fixes: a6a0f67ca7aa ("drm/nouveau/devinit/gf100-: detect if BIOS invoked devinit")
Link: https://bugs.freedesktop.org/show_bug.cgi?id=97620
Cc: <stable@vger.kernel.org> # v4.6+
Signed-off-by: Ilia Mirkin <imirkin@alum.mit.edu>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Link: https://patch.msgid.link/20170128205347.17453-1-imirkin@alum.mit.edu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/nouveau/nvkm/subdev/devinit/gf100.c   | 20 +++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
index 8b1b34c3ad262..686f788baa725 100644
--- a/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/devinit/gf100.c
@@ -27,6 +27,7 @@
 #include <subdev/bios/init.h>
 #include <subdev/bios/pll.h>
 #include <subdev/clk/pll.h>
+#include <subdev/vga.h>
 
 int
 gf100_devinit_pll_set(struct nvkm_devinit *init, u32 type, u32 freq)
@@ -102,6 +103,25 @@ gf100_devinit_preinit(struct nvkm_devinit *base)
 	 * can use it as a reliable way to know whether we should run devinit.
 	 */
 	base->post = ((nvkm_rd32(device, 0x2240c) & BIT(1)) == 0);
+
+	/*
+	 * However some VBIOS init sequences miss this bit. So fall back to
+	 * the nv50 method of checking if the bit is not set. Running the
+	 * VBIOS multiple times may have detrimental effects.
+	 */
+	if (base->post) {
+		u64 disable = nvkm_devinit_disable(base);
+		/* magic to detect whether or not x86 vbios code has
+		 * executed the devinit scripts to initialise the
+		 * board. only works if there's a display engine.
+		 */
+		if (!(disable & (1ULL << NVKM_ENGINE_DISP))) {
+			if (nvkm_rdvgac(device, 0, 0x00) ||
+			    nvkm_rdvgac(device, 0, 0x1a)) {
+				base->post = false;
+			}
+		}
+	}
 }
 
 static const struct nvkm_devinit_func
-- 
2.53.0



