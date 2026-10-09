Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16E5C4E36C4;
	Fri,  9 Oct 2026 14:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556322; cv=none; b=dPuqe4c75GArTVbJvAXyqY2+mw9bvhi+/2RoWNAQXhkdDjgStEN0ZC9tjgyVAJYmdFhYduMBrGX6WsOO9wurwY0b6bw7sg0cFPPVA+zIMnWSnFnTD8hachTqhL2DZqdJuBarctCRmsjsr8K+TZOlsqRW0VsCfWtvMDl4FvMS5So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556322; c=relaxed/simple;
	bh=rGv+Pqsf8YqfI056peRJja0dtFsiepBuL73OPbgNF+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZe0S7SCowBDWD1/CeS3Sa6ViJTLxgYU6ETeH05jm2P0/6/7575uAIutqwpBB9bkzBxbBAMwEgXFA1SgrdCi9TOuQJE05v6uDMpbJ4/P0zPY7C7aM+4Axx/vbwcSwMia0PaY3oJ5BjA4+XlLXhJ9WyXE0eaokrA6P8z3O5Fi/4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=witzoY+C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="witzoY+C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E601F000FF;
	Fri,  9 Oct 2026 14:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556319;
	bh=+aw4DlbT8QoUOHTklGSxDF0oHVQwhoR5JosGYdV6nyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=witzoY+CemHfbVV9z14VR7qJwhSgtc/MwGIBquxQI4L87blmJu5ZmNmlmzFIqIRsr
	 HeJuKCxrAs2bTtAca0J8YEdkIRKKL/z9JKQFT5eaw5UE00xhHBplBXoe+DUuTsHC+u
	 DBm8m2TlrDOp6k7p+OHpXLkZX3+r9WExnRTw4vc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baojun Xu <baojun.xu@ti.com>,
	Antheas Kapenekakis <lkml@antheas.dev>,
	Aleksei Arsenev <alesharik4@gmail.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 215/403] ALSA: hda/realtek: Fix square wave output on ASUS Strix G615LR
Date: Fri,  9 Oct 2026 16:09:36 +0200
Message-ID: <20261009140957.170663923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

commit cfc0a117d773eb585ca7e87d20c50d1c415058e5 upstream.

ASUS ROG Strix G16 G615LR (PCI SSID 1043:3f20) outputs a loud
full-scale square wave from internal speakers since the TAS2781
amplifier driver started loading. The quirk was using
ALC287_FIXUP_TXNW2781_I2C which chains to the ThinkPad headset
jack fixup, but this is an ASUS device that should use
ALC287_FIXUP_TXNW2781_I2C_ASUS which chains to ALC294_FIXUP_ASUS_SPK
for proper EAPD and pin configuration.

Fixes: f7cede182c96 ("ALSA: hda/realtek: Add Asus quirk for TAS amplifiers")
Cc: stable@vger.kernel.org
Cc: Baojun Xu <baojun.xu@ti.com>
Cc: Antheas Kapenekakis <lkml@antheas.dev>
Reported-by: Aleksei Arsenev <alesharik4@gmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=222045
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260923121640.272509-1-zhangheng@kylinos.cn
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7236,7 +7236,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1043, 0x3ef0, "ASUS Strix G635LR_LW_LX", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x3f00, "ASUS Strix G815LH_LM_LP", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x3f10, "ASUS Strix G835LR_LW_LX", ALC287_FIXUP_TXNW2781_I2C),
-	SND_PCI_QUIRK(0x1043, 0x3f20, "ASUS Strix G615LR_LW", ALC287_FIXUP_TXNW2781_I2C),
+	SND_PCI_QUIRK(0x1043, 0x3f20, "ASUS Strix G615LR_LW", ALC287_FIXUP_TXNW2781_I2C_ASUS),
 	SND_PCI_QUIRK(0x1043, 0x3f30, "ASUS Strix G815LR_LW", ALC287_FIXUP_TXNW2781_I2C),
 	SND_PCI_QUIRK(0x1043, 0x3fd0, "ASUS B3605CVA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x3ff0, "ASUS B5405CVA", ALC245_FIXUP_CS35L41_SPI_2),


