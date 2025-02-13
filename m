Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8494714658D;
	Thu, 13 Feb 2025 15:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460589; cv=none; b=dIIMy9i8syOzMf7+D93PLTxnQp0JZ6RTIUH9Fj5i0b5bOVZTzq4CCxOBIBIzqvJhBsO8DLmCI8i6yRYtZIkWauclzMGuIAy3T/FU2T9RujkyaO7fvEBjbNCK8+u+kNuukKTGtiQWJC2XgoDago1xoigSonzUhI8RrD4jivjsDBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460589; c=relaxed/simple;
	bh=Os1zRPr+ydvMWp5uqfPHdJfe4qcss/4YD97adtAS1aQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYq8Y8uMo2tgBqZI9s+F7oc2wON1JQciuO736jnM4+VJ92RbKZhlZ6TaYmTHWKuyuvPCZLeBEJCgxLdDI7Rj6dWP+2FYDwBcueTg3lOOoCxR8Aa41Jrwz96StOaU96mXCHq8xPhVXUR/dXub0GO+lv37woYdyLuqPX1OUhPuqQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIikvoSN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIikvoSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD181C4CED1;
	Thu, 13 Feb 2025 15:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460589;
	bh=Os1zRPr+ydvMWp5uqfPHdJfe4qcss/4YD97adtAS1aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIikvoSNZ+/IO7KiNCsSNI0qFBubbzNEFy7jikT4WFTxL5gcULreM4wlOUs7GKYl4
	 xF+N3GvTilHjMV3B+eb34sumIRNDjhlFlkAQ/aOQTJWeObsZ7YSF/gy+7ZhiE4Kgzb
	 SIlY0o8ue22CRs1XqdC7xhnWv6UBWBHCbtMZelJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 155/273] ALSA: hda/realtek: Enable headset mic on Positivo C6400
Date: Thu, 13 Feb 2025 15:28:47 +0100
Message-ID: <20250213142413.461878005@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

commit 1aec3ed2e3e1512aba15e7e790196a44efd5f0a7 upstream.

Positivo C6400 is equipped with ALC269VB, and it needs
ALC269VB_FIXUP_ASUS_ZENBOOK quirk to make its headset mic work.
Also must to limits the microphone boost.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250114170619.11510-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10402,6 +10402,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1849, 0x0269, "Positivo Master C6400", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),


