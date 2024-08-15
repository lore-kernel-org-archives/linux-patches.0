Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895231AC893;
	Thu, 15 Aug 2024 14:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732844; cv=none; b=g3CMdNzn3vdxq3jvIcgfN6xE73BoICDioPc3gxVI6iOdXn3qwet/neXk8NYgLGMUKL+4uYX6BSk7Cl2TapPqGIz9Pe638OIerUbc88YnxzHvxdvd5BCNECN5IZ3CfxZ+Q88FvSe7DezmkVmQ3YawaSGJeThWtNFlZOnbMdKxosI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732844; c=relaxed/simple;
	bh=CIDWdY4woRPBlNgsMAO2G4j5Gz0tdi8Bw5/LJEppyGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+kVJZAxSo7Oy0MzgAWnuT2L0I9+wmSae03g3DyXO52XapCbOY0bew1923kbYaqcAokafaLx/nX4v8AetYJ8xxIBLGFE1GyKnb7e6cRnMtR+pBquZir3PeDQ2d7lQyJi4CwfXuF+q8fP1TIQLYJ3MEUMRVZPcdmpZ0AyKfwQNyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8v/pPxh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8v/pPxh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145F1C32786;
	Thu, 15 Aug 2024 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732844;
	bh=CIDWdY4woRPBlNgsMAO2G4j5Gz0tdi8Bw5/LJEppyGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8v/pPxhWGDiA17UN4NQ4Sc5wa3piEZWm4M+WoRbkv4OHWaNT+ry0fN01R2o1lzoU
	 EVVNf6LBUukuVpgTAueZqfcy2/L7ZvxcT73PdjaYawVSOVJ1W+Cb5dz3Spp9793EJ9
	 xXR95ZE0Su3nwgllK2KdTyZzPxGXr/PK7Iz+7yYs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Steve Kendall <skend@chromium.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 303/352] ALSA: hda: Add HP MP9 G4 Retail System AMS to force connect list
Date: Thu, 15 Aug 2024 15:26:09 +0200
Message-ID: <20240815131931.171070502@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven 'Steve' Kendall <skend@chromium.org>

commit 7e1e206b99f4b3345aeb49d94584a420b7887f1d upstream.

In recent HP UEFI firmware (likely v2.15 and above, tested on 2.27),
these pins are incorrectly set for HDMI/DP audio. Tested on
HP MP9 G4 Retail System AMS. Tested audio with two monitors connected
via DisplayPort.

Link: https://forum.manjaro.org/t/intel-cannon-lake-pch-cavs-conexant-cx20632-no-sound-at-hdmi-or-displayport/133494
Link: https://bbs.archlinux.org/viewtopic.php?id=270523
Signed-off-by: Steven 'Steve' Kendall <skend@chromium.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240806-hdmi-audio-hp-wrongpins-v2-1-d9eb4ad41043@chromium.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1963,6 +1963,7 @@ static int hdmi_add_cvt(struct hda_codec
 }
 
 static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),


