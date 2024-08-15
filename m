Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B2E719F473;
	Thu, 15 Aug 2024 14:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731785; cv=none; b=moxpWiNswjmNh2qkXbtsXFhE+eNmqrUIFiiYzXvZbt2z2DusR8u9cJRFx4/U2YM5c2JhN/hTdffOmwo39cvMIY/MT2wPV8WeNW7JY4H8s/mAgQsRRLixUT1aLoXzAcAjut0qKJLAsaZUzArcrDhak8EAlYAa7c8D+Vw2FSH6ZjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731785; c=relaxed/simple;
	bh=jdpp0bYqDjSzIl0rJtDel5iIcFVTQlzpafLcUOEYmcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a25g9ACizz8gAJl9yavTvjQ+mnjQZIT9On8LoVVmNXb1BXWeL2tMgAWRnQQjb9F8HaqEwiARAhacEvswF4O6jWl1PFcMtoHhko05SshjfHdv3St0ckRiB++hSSR/a24pIu/RAPkksz4XV2QUtA/AoGeRgYsVrj+IgiQHeAxbBNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDL1hsdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDL1hsdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01916C4AF0C;
	Thu, 15 Aug 2024 14:23:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731785;
	bh=jdpp0bYqDjSzIl0rJtDel5iIcFVTQlzpafLcUOEYmcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDL1hsdFjEaAwdWGJdn2w5PTpNnP4CLqQ9IbG7c2iIFsHxeiYg825gangw+ksdSyc
	 56tDugkdgvDmTTa4j19L2KaBz4pt1K7b13FwDer49UMCDA43/GhFWnPOvhzeHMXD81
	 zy8OMWPzcf1DdbdEbDxnBsH+bEGCyZxeXrZ/vDnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 230/259] ALSA: hda/hdmi: Yet more pin fix for HP EliteDesk 800 G4
Date: Thu, 15 Aug 2024 15:26:03 +0200
Message-ID: <20240815131911.660826340@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1818,6 +1818,7 @@ static int hdmi_add_cvt(struct hda_codec
 }
 
 static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x83e2, "HP EliteDesk 800 G4", 1),
 	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),


