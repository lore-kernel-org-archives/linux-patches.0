Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027138;
	b=JZrbMR6E30ZQbEYXFPdudv0mZKqmYN2W8BR5g81jLDY+Z1j9QPfS/0jGmGukx3/gF+DC
	 NXrdjM8MVU8emC9JDlPD4NNnX10jwBtmZlY2ZDxKbULhWsTuuA4RJjIMC1eIV4ijH1CTd
	 3wK6Zo543SY05gGJ+yfwfGc14cIeSV/ESlKd1mWT6glHS12bjhKIghVcwsq7Sp8qA/+k9
	 9CFeo6OIoEcYpmJtkidgyRN67kcLcG26yO0K/NxKHB+Jq8l9+i4f9rlV/oRIsO2UpNt4t
	 VRcLNhhajoeGEFfRiomQVRi16wONdKzJIHZt7osMS+CUI121kily8haJ9UyYppuQWZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sIqWoSnE3riybh7mkPkdbXBHoPpKBYQkH3LEFPOFEys=;
	b=mUsRUn3VPO3oi286SsbTLG3UPlUpQ8wc1YVYEfxjTsyC7/jxrsMNTCNGHpd9xdcK6n/J
	 qhbyP+G6sUJtmAOcGteoWxaz/qVrYD1JSloWUZYcZYsrHhpFM9iEHABOFGrVycs1lH5f1
	 D3PPPC3783pK9lChZVRs57Cf52T88uzoHMSbH/+xpXrV4TinJHbnTlOMcOaWrJfge7Rww
	 GyVcp+32v9CM5aSwoTi9rBHAt0q3g/50kYBuXS6bLKcSfX5vh6gkqOHcLFC6SD2iec6hT
	 NhZ/h28mwJppZ7d9bbtP94q557tvmWYDP1vQ9TsY0Nucxs0zr0bq+pxfUobIq7oW1AA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZtlAQAOD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC10606A325;
	Wed, 18 Nov 2026 18:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZtlAQAOD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054051F000C4;
	Wed, 18 Nov 2026 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027137;
	bh=sIqWoSnE3riybh7mkPkdbXBHoPpKBYQkH3LEFPOFEys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtlAQAODD/jXiVv7HXUZ8LfdeHMnWpFwREgjZuS6uAePatr0PS2eKyNfareX+laoL
	 z28e+COVS6TdZS42ul8wy8By/hGXoD6N08+zSEqXAb6+qxUON0z5uG/TlDY0SPPWsE
	 4+ezA5qWykd2LdW9b/E3gQTcgn19qlJAYPJIUvUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jackie Dong <xy-jackie@139.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1682/2151] ALSA: hda/realtek: ALC269 fixup for Yoga/Legion Mic noise
Date: Wed, 18 Nov 2026 15:56:57 +0100
Message-ID: <20261118150223.101349645@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jackie Dong <xy-jackie@139.com>

[ Upstream commit 6cd3d2c82651a9e77aa5b1b9c12aa918c0d6c0a9 ]

Lenovo Yoga Pro 7 15ASH11 and Legion 7 15ASH11 use the same audio
subsystem implementation and support only analog microphone.

Limit Amp-In Vals to 0x00 and 0x01 for the internal microphone to reduce
recording noise. Values 0x02 and 0x03 introduce significant noise on
them.

Fixes: 17065203e1bc ("ALSA: hda/realtek:ALC269 fixup for Yoga Pro 7 15ASH11 mic mute LED")
Signed-off-by: Jackie Dong <xy-jackie@139.com>
Link: https://patch.msgid.link/20260804123637.21001-1-xy-jackie@139.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 2fc28b1186d6 ("ALSA: hda/realtek: Fix hiss/crackle on Lenovo Xiaoxin 14 GT (17aa:3912)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 1f65e80b23163..987f770a66d77 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -3451,6 +3451,16 @@ static void alc287_fixup_yoga9_14iap7_bass_spk_pin(struct hda_codec *codec,
 	}
 }
 
+static void alc_fixup_yoga_pro7_audio(struct hda_codec *codec,
+				      const struct hda_fixup *fix, int action)
+{
+	/* Reuse the DAC routing selected for ThinkPad X1 Gen7 */
+	alc285_fixup_thinkpad_x1_gen7(codec, fix, action);
+
+	/* Limit the internal mic boost to 0 or 1 to avoid noise */
+	alc269_fixup_limit_int_mic_boost(codec, fix, action);
+}
+
 static void alc295_fixup_dell_inspiron_top_speakers(struct hda_codec *codec,
 					  const struct hda_fixup *fix, int action)
 {
@@ -6071,8 +6081,7 @@ static const struct hda_fixup alc269_fixups[] = {
 	},
 	[ALC287_FIXUP_LENOVO_YOGA_PRO7] = {
 		.type = HDA_FIXUP_FUNC,
-		/* Reuse the DAC routing selected for ThinkPad X1 Gen7 */
-		.v.func = alc285_fixup_thinkpad_x1_gen7,
+		.v.func = alc_fixup_yoga_pro7_audio,
 		.chained = true,
 		.chain_id = ALC269_FIXUP_LENOVO_XPAD_ACPI,
 	},
-- 
2.53.0



