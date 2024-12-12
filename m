Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14B0213E97;
	Thu, 12 Dec 2024 15:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016135; cv=none; b=KvEgNeNtu2uhbKo4+VTmng+awPBVzg/7+5L8v8CQRPeCI0gjXUa3L6MK4wXSqpBy9T8KRGjzhUcJBlY5IF8wpJjlt8CIu7ral9LykjdebjlM9Q6WibjXoWOm7tBUTCk/r9inTAGBbXMTtG4Rv1ihCKXUrmuivwTAn4PcTnROR5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016135; c=relaxed/simple;
	bh=w2e8Cz+/6Hu41jB3L12DSH6RU2NsLyxXhxvcwRn1rX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EH0VT8mIhRJ7Re9Db8ouK/nzPI7f6XngdT3dzobLWNU5EQTUoPIscUxvTSiiD2/RJIbL5Jnx5/pky6Jyqphupg4iT5lVH4b1E+Jk0pbZZdyTOwBMf/CWscsY1dohwKgOD2CeA8mIfcfEnrCtEiGxpeLEy5BnG5njnVUx5tVv4G4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZjgyRm9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZjgyRm9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E375C4CECE;
	Thu, 12 Dec 2024 15:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016134;
	bh=w2e8Cz+/6Hu41jB3L12DSH6RU2NsLyxXhxvcwRn1rX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZZjgyRm93VEDAnUO78g9EHqcAfeM8oXr+VmKchSiC07QjCya28fyPQKMa28EO0Ixp
	 gUZkwzrvvMQdQ4MuU5wp2e+CGK0Kcfr5VzhFRQWceNAb3LaNUNT0htsRvL2RdOy8EM
	 6txHl0xBfgb55fi2TSIucBVAq7R2pF8mBkkxcWiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nazar Bilinskyi <nbilinskyi@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 143/466] ALSA: hda/realtek: Enable mute and micmute LED on HP ProBook 430 G8
Date: Thu, 12 Dec 2024 15:55:12 +0100
Message-ID: <20241212144312.446094333@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nazar Bilinskyi <nbilinskyi@gmail.com>

commit 3a83f7baf1346aca885cb83cb888e835fef7c472 upstream.

HP ProBook 430 G8 has a mute and micmute LEDs that can be made to work
using quirk ALC236_FIXUP_HP_GPIO_LED. Enable already existing quirk.

Signed-off-by: Nazar Bilinskyi <nbilinskyi@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20241130231631.8929-1-nbilinskyi@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10411,6 +10411,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87b7, "HP Laptop 14-fq0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87c8, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87d3, "HP Laptop 15-gw0xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
+	SND_PCI_QUIRK(0x103c, 0x87df, "HP ProBook 430 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e5, "HP ProBook 440 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87e7, "HP ProBook 450 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f1, "HP ProBook 630 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),


