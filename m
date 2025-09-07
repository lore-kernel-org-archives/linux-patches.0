Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485DA1DE8AF;
	Sun,  7 Sep 2025 20:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277297; cv=none; b=czc4VTJBVAH86Dnfp3/I+ViyAAhsqJu/pcsljpOS9JS/JOankrcGhPqdJs4cegwpwULTU2Fs9LssJuVP697KxEa+fZ3R10GuPZbzvW/aIz7onfGHamt/BzRK0i/sg0030VIeudj3AtsG26GfUNzrimH2jEPo56VO1/9M6jIqbrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277297; c=relaxed/simple;
	bh=FGLJ7y+Z3n/aLc6xYhP6sFcHIVfSz2x/iOchRL5E4UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bj3Za3Ppb7mIwIyXuOGAi16uykxqH4QMvDFRtiy9QtM32ebjMP5gqvGgDFaP2vfPoNlKTq+DlSuUZ9lNCqev6DqiQwS1EiEZUvkuUSQ28c7dX5KJOrMfAAAd/GBThPRN14rH2btM9NI0erMpn1hSKnZeB/dpDLRo5WuKpYPEhLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLtLKlgD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLtLKlgD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF622C4CEF0;
	Sun,  7 Sep 2025 20:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277297;
	bh=FGLJ7y+Z3n/aLc6xYhP6sFcHIVfSz2x/iOchRL5E4UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLtLKlgDYnqjzA31jYvAUlG0gPXrXI+cDg+bQlljjniumX0kzu4Mk5+jcUWbTlgTE
	 ROHb9Ikad/7vm4oHRaErhlzJp6cAyw/6ZppF8w5b8R/hInpQpIAMHJj/B0rtxKOgjH
	 gQ9HaPLW3HGNUYN+gMDX3tCsl8TV0lhJEY23ChzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Erhardt <aer@tuxedocomputers.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 148/175] ALSA: hda/realtek: Fix headset mic for TongFang X6[AF]R5xxY
Date: Sun,  7 Sep 2025 21:59:03 +0200
Message-ID: <20250907195618.356615348@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195614.892725141@linuxfoundation.org>
References: <20250907195614.892725141@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aaron Erhardt <aer@tuxedocomputers.com>

commit 051b02b17a8b383ee033db211f90f24b91ac7006 upstream.

Add a PCI quirk to enable microphone detection on the headphone jack of
TongFang X6AR5xxY and X6FR5xxY devices.

Signed-off-by: Aaron Erhardt <aer@tuxedocomputers.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20250826141054.1201482-1-aer@tuxedocomputers.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11328,6 +11328,8 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x1d05, 0x121b, "TongFang GMxAGxx", ALC269_FIXUP_NO_SHUTUP),
 	SND_PCI_QUIRK(0x1d05, 0x1387, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d05, 0x1409, "TongFang GMxIXxx", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x300f, "TongFang X6AR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1d05, 0x3019, "TongFang X6FR5xxY", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d17, 0x3288, "Haier Boyue G42", ALC269VC_FIXUP_ACER_VCOPPERBOX_PINS),
 	SND_PCI_QUIRK(0x1d72, 0x1602, "RedmiBook", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1701, "XiaomiNotebook Pro", ALC298_FIXUP_DELL1_MIC_NO_PRESENCE),


