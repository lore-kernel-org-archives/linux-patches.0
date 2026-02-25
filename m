Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E279831352F;
	Wed, 25 Feb 2026 06:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002791; cv=none; b=KcIAeWseZTmZzuxpB6gKh5ozAC6KvkO9cGR+2TT9UgVIE3ggXNLDgyFOUfldYENHMlcAcpE+bdhi2xnHmwvaVH7W7DwcrlquSYVQEwybm+uylXwSULL0fft0za/96PKtaMn8xxYGqXk1503Mcg6Vgf6bxmlo/5v+R89L1sxo2q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002791; c=relaxed/simple;
	bh=/KtdpCE2NB3syAXeYs9wiLDMdV4FauQcsuZitcuCeT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g4onrCBv+A6bbU74Fxp+NBsfuKuiF12OO/3I7Z0XFmW1l+6OtSKdn1z3e4UY54NN16wDLfXagGAuRmRbkKMiPGAJmTR6pSuaeIJgLy1ppbpViNwzqRuJ1TvL4Lb2EQTRY+C7CV0BBV8kp63VP8DZ0MsQ6kmYB+kh8jG27P5wyJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQEvxJHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQEvxJHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC4BAC116D0;
	Wed, 25 Feb 2026 06:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002790;
	bh=/KtdpCE2NB3syAXeYs9wiLDMdV4FauQcsuZitcuCeT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQEvxJHbT2mNHaRxWi/1z6ycVMfOXKgzO0e8aRDQMrdGw3HrtTzKv0jtl4n00bEvw
	 DyklAGsBIXVIYW11Jvo1+Lx5erUZZyZRgh3Xs91oiaO+pi2R62F2RO71qg+C2BTAYH
	 VhZroMPBJSMjZ2WIuDK78uI7rhXb1PVMykRub7LE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lewis Mason <lewis@ocuru.co.uk>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 634/641] ALSA: hda/realtek: Add quirk for Samsung Galaxy Book3 Pro 360 (NP965QFG)
Date: Tue, 24 Feb 2026 17:26:00 -0800
Message-ID: <20260225012403.868838693@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lewis Mason <mason8110@gmail.com>

commit 3a6b7dc431aab90744e973254604855e654294ae upstream.

The Samsung Galaxy Book3 Pro 360 NP965QFG (subsystem ID 0x144d:0xc1cb)
uses the same Realtek ALC298 codec and amplifier configuration as the
NP960QFG (0x144d:0xc1ca). Apply the same ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS
fixup to enable the internal speakers.

Cc: stable@vger.kernel.org
Signed-off-by: Lewis Mason <lewis@ocuru.co.uk>
Link: https://patch.msgid.link/20260210231337.7265-1-lewis@ocuru.co.uk
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6951,6 +6951,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x144d, 0xc872, "Samsung Galaxy Book2 Pro (NP950XEE)", ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc886, "Samsung Galaxy Book3 Pro (NP964XFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1ca, "Samsung Galaxy Book3 Pro 360 (NP960QFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
+	SND_PCI_QUIRK(0x144d, 0xc1cb, "Samsung Galaxy Book3 Pro 360 (NP965QFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1cc, "Samsung Galaxy Book3 Ultra (NT960XFH)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x1458, 0x900e, "Gigabyte G5 KF5 (2023)", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),


