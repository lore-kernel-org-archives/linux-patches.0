Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D3903DDDD5;
	Tue, 16 Jun 2026 19:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636862; cv=none; b=ZYpDVPvG3PpmMT95PIajAoxOvofzdD92qjlN9/Azdyq6oWR41muukwxLRagyYW8RWLW0idG7KShz0P1Bj5L5EAhG0Fv4TCBD3IhWTpKpXXbvN1IcW6DeEbxspxIPF+7/D/xANYl020ZA0GosMTc6fBtxOh5AFspM5GmJSA+yJZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636862; c=relaxed/simple;
	bh=I8L0CPy12vKmV098ZQQETW4KljdHIVm5bl7/ADQBF2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cc85okrxA7PUSRcWBFXv6XlvMPDjZfFvd1qQ83MHQKd8lroGbMc0hlDW/ACbNDSrqTHUMcqW+yqEn9eBzEy3JdW6SO7vlMPSgF5pvhUCr77CephrAP2nABBEYXq/cRmY3rmCUIdDomdmo4UcrmyHQHZFN9LRSlGoA4AErMLaa1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VamNrb+B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VamNrb+B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6226C1F000E9;
	Tue, 16 Jun 2026 19:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636861;
	bh=63RvxcQaUVvo4LhNBnpIjbrOhaAPTOWcvSxma8sk4Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VamNrb+Byel7XPBwQtcNGl1uYf+QEV5k7emzQ8/31JR7wRGhNtFQEve5kRArA2aap
	 oAPBB4ssvdRFcTYTW16xIkFqszpG6CHNCj2QG07wr1WSlEeGXAr1jivnAPiHfLKw9M
	 63imonsAGdhsszOAuf+FUVBvZLU+JzU3QlaFx7og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 318/342] ALSA: hda/hdmi: Add quirk for TUXEDO IBS14G6
Date: Tue, 16 Jun 2026 20:30:14 +0530
Message-ID: <20260616145103.350856660@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Erhardt <aer@tuxedocomputers.com>

commit d649c58bcad8fb9b749e3837136a201632fa109d upstream.

Depending on the timing during boot, the BIOS might report wrong pin
capabilities, which can lead to HDMI audio being disabled. Therefore,
force HDMI audio connection on TUXEDO InfinityBook S 14 Gen6.

Signed-off-by: Aaron Erhardt <aer@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://patch.msgid.link/20260218213234.429686-1-wse@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1973,6 +1973,7 @@ static const struct snd_pci_quirk force_
 	SND_PCI_QUIRK(0x1043, 0x86ae, "ASUS", 1),  /* Z170 PRO */
 	SND_PCI_QUIRK(0x1043, 0x86c7, "ASUS", 1),  /* Z170M PLUS */
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
+	SND_PCI_QUIRK(0x1558, 0x14a1, "TUXEDO InfinityBook S 14 Gen6", 1),
 	SND_PCI_QUIRK(0x8086, 0x2060, "Intel NUC5CPYB", 1),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", 1),
 	{}


