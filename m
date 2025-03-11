Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7307A1494BB;
	Tue, 11 Mar 2025 15:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706875; cv=none; b=p85G8Pcec7KQhaWFVrwW5V0sEM0L9ZzhzAcjalAHuTN43RWaA9HE5qPNAoJakPt4OXvt4p4hwUbiRwG4wuEYHp7YCbdneAeBo8RbA5uAwo6DesjGpCgj+qwt7mq1ZZiMt7REesFzs+n+QpT+82MwCjC529G/KEydZsqmjUC5aUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706875; c=relaxed/simple;
	bh=joht2hkW01JWYFz1n+Bon+tK8wkXeuZ3Z6+RwS9QpI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu3W3Tnp70gm/CBc3bCXhccP3DGgUnjoNM7vTOhdbtaUwXPoyEscr/sgV7cQRElTpRqqc4Lb0RsDp2Oie4A2tTmB1yTwFqYlO1C3C7Xv/hr1lVD3Z+HYIyYLvjYRrZ8UhorhPN0HiXq2FrOdQ3yDWQJY2y1JiRQohyvKKizOiUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BvRgnPjL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BvRgnPjL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2DCC4CEE9;
	Tue, 11 Mar 2025 15:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706875;
	bh=joht2hkW01JWYFz1n+Bon+tK8wkXeuZ3Z6+RwS9QpI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BvRgnPjLvL3lQS7UBYKJLwtuJSdZY8WizBQMLXT8pmJj4X5vZw6H/LVzdUaOFuiHf
	 Z4Zpj3Vyt4xt1AM227zdkh2wl5GcJZMx0w2+zjXCH6bi6mwZfKt53NVymkNwGvcl/3
	 udR5ej4ZZFWF2lUCyZcUnE9YPmQrSlehzZLB60N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 197/462] ALSA: hda/realtek: Enable headset mic on Positivo C6400
Date: Tue, 11 Mar 2025 15:57:43 +0100
Message-ID: <20250311145806.138876752@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9435,6 +9435,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x17aa, 0x511f, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x9e54, "LENOVO NB", ALC269_FIXUP_LENOVO_EAPD),
 	SND_PCI_QUIRK(0x17aa, 0x9e56, "Lenovo ZhaoYang CF4620Z", ALC286_FIXUP_SONY_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1849, 0x0269, "Positivo Master C6400", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1849, 0x1233, "ASRock NUC Box 1100", ALC233_FIXUP_NO_AUDIO_JACK),
 	SND_PCI_QUIRK(0x1849, 0xa233, "Positivo Master C6300", ALC269_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x19e5, 0x3204, "Huawei MACH-WX9", ALC256_FIXUP_HUAWEI_MACH_WX9_PINS),


