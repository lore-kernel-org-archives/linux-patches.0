Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC89519F49C;
	Thu, 15 Aug 2024 14:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730474; cv=none; b=C4OKgbp9OBaT2MzSOV+QwQfINNhCMiZtiPmc30OR0GVf12wLS9/w0CKUT4wv5DqB56KqiYpeK3FNMHgBET3Xzls+2u/juJkM+/UdffP8EgLLICG8RrvJ+4NXwEAYdFySaW9QSzWqh1f1Khvg1MQw7H0ijcKNCyWYisOTahOX/4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730474; c=relaxed/simple;
	bh=dVGMWwahBpEr9LDrzFQA9AptyDV0LYXLZnACkK0ugSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UDIotvzQdSQv5ixI1GKhK0B9L0TU2xq4008Y6TOA+glt9IS0FB+elR7odGE5NYT569kI4hwXLI7rNsCkfEkPAHA0SSqfu3qUO+5Jq4rtrUmVv8JhLCC4Me+KQ3rHdtPAEm9xKxVG91htHzVJULeeYFSx1Ocq1eaNOgxJAENu/40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAIGSe10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAIGSe10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0F3C32786;
	Thu, 15 Aug 2024 14:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730474;
	bh=dVGMWwahBpEr9LDrzFQA9AptyDV0LYXLZnACkK0ugSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAIGSe10j+LOh1voKMPl6ftAESde4+LYrmCLoPCAA09ikY3DyOUQ9mvWDhUg2rWXY
	 7a1bSKKOJVDp/3cG4hinoBzXSkan039Hi/MjabgRo9YWIau6X8iqusmBrWT3FOctCo
	 HFL7ZKzYUX67EKSpKS+3ofsxVchF1eAzEvMY2p2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 419/484] ALSA: hda/hdmi: Yet more pin fix for HP EliteDesk 800 G4
Date: Thu, 15 Aug 2024 15:24:37 +0200
Message-ID: <20240815131957.640250197@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 176fd1511dd9086ab4fa9323cb232177c6235288 upstream.

HP EliteDesk 800 G4 (PCI SSID 103c:83e2) is another Kabylake machine
where BIOS misses the HDMI pin initializations.  Add the quirk entry.

Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240806064918.11132-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1960,6 +1960,7 @@ static int hdmi_add_cvt(struct hda_codec
 }
 
 static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x83e2, "HP EliteDesk 800 G4", 1),
 	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),


