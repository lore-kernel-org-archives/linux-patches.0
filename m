Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617578;
	b=lZzWE5gOpTRt+tbvLu7PyZNZZ2DFz0uwrG6l6PCR2NfFyJZG0e2z9clypkXL5c1cC5f3
	 jsFMbSrYdJzyhCMwlOR7vYInWAiNFPNCJv4tNmNda4XWykVWmtoB+PdpG39t7z4gpdKgJ
	 K2gn43549tsn1uw2xcQFN6MH1SHFJm5nYNp+3URLAZNaT0yePRG7ybJDNA5j/g4yqm307
	 a67ApcB7+gg1Pd+E/kzmknLC29oCkLyYx1QRvh4X0APQ1USWV2Hh20pQdIaTEHcCUY/u7
	 b5kQMjhYyLP+RFWWWXnRR3vZ8f/NrupmCKM61yoJ0iN8s1xsCf4MLOiDyn3xStP19mA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617578;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZNNJuCQIkM0uYnnJgaRyv/d1fcwplLGBJPk+N3crYv8=;
	b=Jl28aupdwzkdU+DRKIvHqrGorbewTSxg3SW37uKqmpTh71Y9nj0Xu/IdfzIJkgeQ+U4D
	 EhrJHVcVALkunC7U10+yWHOvj5hrRTA2c2AUmImUIGCLYzbpNICAgx4gZUWE3kh8TDNqj
	 AVO6opOKPEmZAYT+y53vThg251cY7sOTudWrbaqp8Y3F477m0RYUCMsHEK6Cg1mHn/o3C
	 XWiewpYLkOEknwcgTFA+LR0BatS3LvYd7SzLlN/57SbNFPTvxYmNcGmy6lSBod17ztd86
	 Lm23J7eF2btsF+P69ZAvKjazWKqhg2v7GyNE62VA/xNCeLQ+6enhxiH6RmDRxFr00og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9GgSUNS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D2F606A31E;
	Wed, 25 Nov 2026 14:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=X9GgSUNS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A39B91F000D1;
	Wed, 25 Nov 2026 14:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617577;
	bh=ZNNJuCQIkM0uYnnJgaRyv/d1fcwplLGBJPk+N3crYv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X9GgSUNSMy48AUbN44xT4EGTK1H5I+5PeO+o+Zksz20Rg9Vdwcm6QV1TfyKR/4g/Z
	 DIXRSdZx7y5i8kJ4kvCVY7OLBWbSrb6noWwnfwzJhGfSRcMFtKKCL8kJPBz9H/Ywal
	 ASRCZNmoWyXDVf2sbSilS3dDiQWKxHmaLLFDR1yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0010/1005] ALSA: hda/tas2781: Prevent throwing away custom calibration addresses
Date: Wed, 25 Nov 2026 15:22:28 +0100
Message-ID: <20261125143821.979121243@linuxfoundation.org>
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

From: Antheas Kapenekakis <lkml@antheas.dev>

[ Upstream commit ba39a31448857da3b848174c9130b466b3ccddba ]

The V2 UEFI spec for per-device calibration data in TAS allows for
manufacturers to specify up to five custom calibration register
addresses and values to optimize per-device in factory.

A basic description of the spec is found in a comment in function
tas2781_apply_calib(). However, currently, for the condition of
p->dspbin_typ != TASDEV_BASIC, if custom calibration addresses have been
provided by the manufacturer, they are ignored and the ones listed in
firmware are used.

In case the manufacturer chose to change different registers other than
the default ones (r0, invr0, r0_low, pow, tlimit), this causes the
UEFI calibration data to scratch different registers and cause the
firmware to misbehave. This is true in the Xbox ROG Ally X, for one of
the firmwares, where it pops and has audio dropouts after the
calibration data is applied.

Therefore, add a new bool to indicate that UEFI supplied custom
calibration addresses, and if so, use them regardless of dspbin_typ.

Closes: https://lore.kernel.org/all/179122346529.6.9250312386131579603.1671009695@8alias.com/
Co-developed-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Antheas Kapenekakis <lkml@antheas.dev>
Link: https://patch.msgid.link/20261102174052.1216670-1-lkml@antheas.dev
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda.c b/sound/hda/codecs/side-codecs/tas2781_hda.c
index 9162173ccb105..b9b6e44f8791a 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda.c
@@ -89,6 +89,7 @@ static void tas2781_apply_calib(struct tasdevice_priv *p)
 		TASDEVICE_REG(0, 0x18, 0x7c),
 	};
 	unsigned int crc, oft, node_num;
+	bool custom_addr = false;
 	unsigned char *buf;
 	int i, j, k, l;
 
@@ -129,6 +130,7 @@ static void tas2781_apply_calib(struct tasdevice_priv *p)
 		for (j = 0, k = 0; j < node_num; j++) {
 			oft = j * 6 + 3;
 			if (tmp_val[oft] == TASDEV_UEFI_CALI_REG_ADDR_FLG) {
+				custom_addr = true;
 				for (i = 0; i < TASDEV_CALIB_N; i++) {
 					buf = &data[(oft + i + 1) * 4];
 					cali_reg[i] = TASDEVICE_REG(buf[1],
@@ -188,7 +190,7 @@ static void tas2781_apply_calib(struct tasdevice_priv *p)
 		}
 	}
 
-	if (p->dspbin_typ == TASDEV_BASIC) {
+	if (custom_addr || p->dspbin_typ == TASDEV_BASIC) {
 		r->r0_reg = cali_reg[0];
 		r->invr0_reg = cali_reg[1];
 		r->r0_low_reg = cali_reg[2];
-- 
2.53.0



