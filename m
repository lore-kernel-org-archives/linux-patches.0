Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 166982F39C2;
	Wed,  8 Apr 2026 18:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674680; cv=none; b=gBOf60BbHSCsyQCzVTIOlH3ZH1KIZMXM5WtyL5jwWiDs9bSfqdd4pHLuOfI8r/WgzA4aNHKv4DvTzhzdlYm42daeRCDIj2A0CljoVKKBDiRnufZAbp3f0N/zjxSgUv+vROyqQIsPCnjEhcJnoaJX9dSVXtkFcizUtSxnQHJMY4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674680; c=relaxed/simple;
	bh=ROxwJ+2EIVG51ougz3/PwhgRhiqr5LwarUdhCcASsGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C+vj9bN32tvEPcxCWG6FJHSXCGpXR5K9ldR61Xq/SODsrcbMhoxJhhlEkDbv1ld+73GABs9KY2PQ3L6tXJ4dwGJxiD0FBY5bPO1T4HVUtunWEcaAuh6LnEgcZNxprwUF4mwW91JbWaAMJmRsz22hjkdk3qscz/wWwvFIRdpEPr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgWI+wr8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgWI+wr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A27B3C19421;
	Wed,  8 Apr 2026 18:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674680;
	bh=ROxwJ+2EIVG51ougz3/PwhgRhiqr5LwarUdhCcASsGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgWI+wr8EeH0KMqsWR0U5ChO0TJh32CBq0cl0C8kc10kGOT8EBtPJh6tWbzoGmEZn
	 PAhcn/BQuQcMf7lpjdDTRwSGQrvIVOo7sVuGPl5e8txfQ5TlPe3F5rrvhT+RyrUkJo
	 0AYhx6IkpIRNOpiyEhYa8WnEAjthpqojPxELEQck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 174/311] ALSA: hda/realtek: add quirk for Acer Swift SFG14-73
Date: Wed,  8 Apr 2026 20:02:54 +0200
Message-ID: <20260408175945.903846948@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Heng <zhangheng@kylinos.cn>

commit dd9b99b822684f421f9b7e1e5a69d791ffc1d48f upstream.

fix mute/micmute LEDs and headset microphone for Acer Swift SFG14-73.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220279
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260331094614.186063-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6685,6 +6685,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1025, 0x1597, "Acer Nitro 5 AN517-55", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1025, 0x169a, "Acer Swift SFG16", ALC256_FIXUP_ACER_SFG16_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x171e, "Acer Nitro ANV15-51", ALC245_FIXUP_ACER_MICMUTE_LED),
+	SND_PCI_QUIRK(0x1025, 0x173a, "Acer Swift SFG14-73", ALC245_FIXUP_ACER_MICMUTE_LED),
 	SND_PCI_QUIRK(0x1025, 0x1826, "Acer Helios ZPC", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x182c, "Acer Helios ZPD", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1025, 0x1844, "Acer Helios ZPS", ALC287_FIXUP_PREDATOR_SPK_CS35L41_I2C_2),


