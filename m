Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E767814D431;
	Tue, 10 Sep 2024 10:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963468; cv=none; b=ZA2kKxXOlkYhqCjUORI8wM3pAJFArEyiWO29m2Y/oDB3z9dDaZWovnuPW0VJyM+Fo/JNNBVZ6ZUqRUywSM7Sr1AQwkgekgvo4mzuIW7QzY5pqDXHWMoCbMI5RVniJn75t9Zjse3+L9l9jLRtRtEoj4/FZzy/C7lfmGwez4uHofU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963468; c=relaxed/simple;
	bh=T3egVNj0GnVN3z4hze2XhPcDi1jsZYhPUGpYEdHRzyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyM3jLeDkdFsZW+8b9yP05zRBmDl7HCw5KZ4m3jRRus7Le0IzlSJXjoR5DoMvF0pplr5C8F01J92bjgALktc5eawmYPPTBVjAhVat0gFo2zE656P+AKvQbkGy7GEaG1kN/5c58dtf2jfyPxplMY9x73bhE9ZnOXji8MW/hSOobo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNeQa0nh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNeQa0nh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B668C4CEC3;
	Tue, 10 Sep 2024 10:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963467;
	bh=T3egVNj0GnVN3z4hze2XhPcDi1jsZYhPUGpYEdHRzyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNeQa0nhp9/4f6hVUWZeDZxZNal3NfwD7VTsucZgtpR9yKmnVmfYwKOmrv1XgGUOU
	 JpXhiSku/U176Tw9viIVXcIfsZYXPAi1rlU55jZjOm2yMseBFRUH3JtjJKQJGgPdS7
	 OxwKb3TU27JjyXOlhPLGiE0UcqN9AKGxj8iG5Ea8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilien Perreault <maximilienperreault@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 068/214] ALSA: hda/realtek: Support mute LED on HP Laptop 14-dq2xxx
Date: Tue, 10 Sep 2024 11:31:30 +0200
Message-ID: <20240910092601.527250762@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Maximilien Perreault <maximilienperreault@gmail.com>

commit 47a9e8dbb8d4713a9aac7cc6ce3c82dcc94217d8 upstream.

The mute LED on this HP laptop uses ALC236 and requires a quirk to function. This patch enables the existing quirk for the device.

Signed-off-by: Maximilien Perreault <maximilienperreault@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240904031013.21220-1-maximilienperreault@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9177,6 +9177,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f6, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
+	SND_PCI_QUIRK(0x103c, 0x87fd, "HP Laptop 14-dq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87fe, "HP Laptop 15s-fq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8805, "HP ProBook 650 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),


