Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 838001494B8;
	Mon, 12 Aug 2024 16:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480460; cv=none; b=n35zBcwJCsPAQkciaid9oFEuMU57DQ+7VqxcS0waKQmKU5zHsCgYrClIiD3S3ryMR9PW/x2RkUC7m+QGjq0aUApH+HokRjexrDJ6dgvGsWkYN1MipVPaK8KqupPWTxeBef7stCjXPnCyrEg4QfPoVWm6UOgZWRgOyIIIa4eOk0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480460; c=relaxed/simple;
	bh=wjsMksbrt90KSprd65lgx4GVCsqMTJ2IJJ71hZy6c/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TOJJoznc9HXzd5kIGv8oNkFrJ7hHUrwMZdX2vbHpe4oOLF6lQGDnK+RZNnHRNQ1VLuKqtRgmgbCZbjNMMZbAmRihgVIFAPmWfOG8etAEKic61Y3rTMW7nSDvJQn1qnCfCnt6nZuB+IVlQGfxomm5QRIjK83OBetAIljbfZm3nKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xym+S++; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xym+S++"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4368C32782;
	Mon, 12 Aug 2024 16:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480460;
	bh=wjsMksbrt90KSprd65lgx4GVCsqMTJ2IJJ71hZy6c/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xym+S++1Hrq0N+zGV8ZNglYW4ZyZLJvo31BDyBkDUKKcg8wbN5H+xOzCvs9bCUD3
	 z3RktB5VRkHavgPgfMNRFcPAkyqjj6E6nO1Xck7mdJ+3wWDYfeztyJSIvBvJ4lgghP
	 AqDrJHEuOixFpaaRaW6i8aH8RtTMHFCnVtc/igEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 185/263] ALSA: hda/hdmi: Yet more pin fix for HP EliteDesk 800 G4
Date: Mon, 12 Aug 2024 18:03:06 +0200
Message-ID: <20240812160153.627959121@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1989,6 +1989,7 @@ static int hdmi_add_cvt(struct hda_codec
 }
 
 static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x83e2, "HP EliteDesk 800 G4", 1),
 	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),


