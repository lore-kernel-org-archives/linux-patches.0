Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228AD18B49E;
	Tue, 10 Sep 2024 09:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961356; cv=none; b=oTRTxH2xEkxEDvhN9z7LavagP6abHsnYHQaJxFkyVRLtmH+keumtz9JegdsmbEJ53SgK00gmoI0MaJwOEsQRUVEoC9nrPienCO9Wc++zL/9D6GKNcfaXWA7UMA7njPZ0enawU0tW6Ke2lvfo7IP2eHuPDwHUNgUd56AS8234zDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961356; c=relaxed/simple;
	bh=W1oPZ0x2JuGtnXmLLt6IYlCqf4mgQUP+lKfUDt/ikBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlQFRe1Pd4cxkiRAErwxfimE6BIauMYFhqyDkeaSDIft2qZPJ18IhL24CW7HaU8sVkHzGHE/eJJ30AoQArh9IvjIwjCfiy42tHDG43OKkpx3Y/RDLeTGVMaTAaGAS9i0bgDYJUHoB6097AkLc1lA+mt/ww0EmX+p40QLD2rsP3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H5ngKwVf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H5ngKwVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95FDDC4CEC3;
	Tue, 10 Sep 2024 09:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961356;
	bh=W1oPZ0x2JuGtnXmLLt6IYlCqf4mgQUP+lKfUDt/ikBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H5ngKwVfHzgVG9Coh3b8Dj4DsO08xuMblIpCykvdqj9k8gBZWc1x4IA4bdTmFB63F
	 ZDBR9cBvPZDuOqJsromUSjE9hVoFssjNgHDbK1VH+78VmW190BeUzmef4t28HzrIFQ
	 Sq1LxugQLKIxDgVd0LzOvSlIDoyyssVbkpkJXeAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maximilien Perreault <maximilienperreault@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 015/375] ALSA: hda/realtek: Support mute LED on HP Laptop 14-dq2xxx
Date: Tue, 10 Sep 2024 11:26:52 +0200
Message-ID: <20240910092622.778649005@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
@@ -10105,6 +10105,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x103c, 0x87f5, "HP", ALC287_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x87f6, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
 	SND_PCI_QUIRK(0x103c, 0x87f7, "HP Spectre x360 14", ALC245_FIXUP_HP_X360_AMP),
+	SND_PCI_QUIRK(0x103c, 0x87fd, "HP Laptop 14-dq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x87fe, "HP Laptop 15s-fq2xxx", ALC236_FIXUP_HP_MUTE_LED_COEFBIT2),
 	SND_PCI_QUIRK(0x103c, 0x8805, "HP ProBook 650 G8 Notebook PC", ALC236_FIXUP_HP_GPIO_LED),
 	SND_PCI_QUIRK(0x103c, 0x880d, "HP EliteBook 830 G8 Notebook PC", ALC285_FIXUP_HP_GPIO_LED),


