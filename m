Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620788;
	b=n5/1+SersIAtrslnBcMSEqau5BiYqQ6ynw9xmD0neNJfKtPZXhyh7QbN3RktpJtnBDbk
	 EA/DWlkOMpK7fuIhICBHv0IESF/cLPn0EhGWXZUJXKOE900x+isENNaa7f4ZPIJnMnbh1
	 f0K7fKxFR5R9dpZ95ljh18Z8LUGPBQbvYC7d9dF/JALqBr0Zuo5TqAzkrp1hBVMgVio2J
	 wVk7+8uWIZz+mNfOlImlOesdUQetv2/6XVEjOUXvVnnM/iL+Lk2TguChclo8jpNEqLE//
	 TZZpdUB4xdNKCZmgIGCkTQ/kmDrx+YJIOaJ0BZCaI9X5J++XGlnxwSLOz1Ai3TYzlBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620788;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YQyB8WJxvuAej6+SxLB4ntMG2IJDpek6oiae5A6ignA=;
	b=1NkynvbKw/UhWKAj+3ExOl03bRCUVu64oUCGgxuk7nZgqq5BixPOCSLnINdkVbYsThpK
	 HeKwil7VS0YcNjsLoUhHdOXzlQS02ZWI7b1ssXo3A+KzhoNnDKrQxnEyYJCu5iXWwRjuM
	 2ZA+ob84lPz/Ht0JsJy9Oi5kcNWGieguE8CH63Z53XuqTP/KKVAtxvPAp8oT2Hf5riYjQ
	 j3gjXf9zcqTFJ64QK0usftCDj6rLDKHrGS0BNVUaDKnyD3IyJoOSvCZLL6/Qh3E8QnRL7
	 tE10lymQ0EyC6TnO0UexRcnuBecEt+A69z3C32hDqcmb3SHVa/DvXELlru5VmP5ZDFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="w/2n+RiF";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298BB606A31E;
	Wed, 25 Nov 2026 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w/2n+RiF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF421F000CF;
	Wed, 25 Nov 2026 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620787;
	bh=YQyB8WJxvuAej6+SxLB4ntMG2IJDpek6oiae5A6ignA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w/2n+RiFLXWkrUZJKVvMcaK+B+Lxd2rBIZjwWPZfgtrFTbJI+Jo7xLBSahZlV6s2l
	 Jn83niud4Jzs4Ua+5nC7K8PuAOVXaNhZh00GDz1m6v/9tNcro9QqEae+INBDvuYSBZ
	 0rFOMRhxz5j24lHqXMqFCyaV41xfU1jN/OJoxMRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 024/990] ALSA: hda/tas2781: Prevent throwing away custom calibration addresses
Date: Wed, 25 Nov 2026 15:23:11 +0100
Message-ID: <20261125143822.654407054@linuxfoundation.org>
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
index dc4e42fd88484..c44dfa2757b1a 100644
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



