Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E7C3E316C;
	Tue, 31 Mar 2026 16:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974294; cv=none; b=LS3uAqEAKgR9VydbwWlKTKer1xbCSo7tRIYd3qxYluhB7AChKzrOlvASO74FXSFPlMof+aZ+35ltu1MtfWYKb+6p50tbA3troi9dPRcfnjZD2Rf59Is5u1+i2Oh2CM/0/mM5QYhNO7Sv0lEPz7X0d/Swi+qkJ0ihC0PayFFCsSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974294; c=relaxed/simple;
	bh=pUqU9+b/jFhLcIpeodJB2fPLD3i1y3vAT4jZTTp/UE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYb1T3youwIeVYOLC8hP75wjN/4o6kzZhMBfCEIo1Fz6aLeFkQa15lq1yIaZbwbOyWfYBIb/l7aqC7+Wo+dG3Hpxe5gAawFxjW6WnZjSkePW8KE8v4dHL1LH6X1fytEBi1FX9wlTXdvt9elmGzQV1ggPsJnPxJi5VCViEfOobj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FXPuY1G8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FXPuY1G8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8725C2BCB2;
	Tue, 31 Mar 2026 16:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974294;
	bh=pUqU9+b/jFhLcIpeodJB2fPLD3i1y3vAT4jZTTp/UE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FXPuY1G83WN8roWQk603ECQMrmaPonObBseDQvRYRMWqDgfjARle+RAyGALf2GZWP
	 p+BzX94grnAmvwrNJYYMODftdpcfE36JFdlQD3bYyHbkQD0QWC8DyuXO+mUESmVZHV
	 LI/N3nxm64P7q2FBq3niLo5z+BGzVD7wVb0dAXAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uzair Mughal <contact@uzair.is-a.dev>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 029/175] ALSA: hda/realtek: Add headset jack quirk for Thinkpad X390
Date: Tue, 31 Mar 2026 18:20:13 +0200
Message-ID: <20260331161730.857604130@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uzair Mughal <contact@uzair.is-a.dev>

[ Upstream commit 542127f6528ca7cc3cf61e1651d6ccb58495f953 ]

The Lenovo ThinkPad X390 (ALC257 codec, subsystem ID 0x17aa2288)
does not report headset button press events. Headphone insertion is
detected (SW_HEADPHONE_INSERT), but pressing the inline microphone
button on a headset produces no input events.

Add a SND_PCI_QUIRK entry that maps this subsystem ID to
ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK, which enables
headset jack button detection through alc_fixup_headset_jack()
and ThinkPad ACPI integration. This is the same fixup used by
similar ThinkPad models (P1 Gen 3, X1 Extreme Gen 3).

Signed-off-by: Uzair Mughal <contact@uzair.is-a.dev>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260307012906.20093-1-contact@uzair.is-a.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 908028d060c8d..1a5e2fb0c842b 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10520,6 +10520,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x224c, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x224d, "Thinkpad", ALC298_FIXUP_TPT470_DOCK),
 	SND_PCI_QUIRK(0x17aa, 0x225d, "Thinkpad T480", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
+	SND_PCI_QUIRK(0x17aa, 0x2288, "Thinkpad X390", ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x2292, "Thinkpad X1 Carbon 7th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x22be, "Thinkpad X1 Carbon 8th", ALC285_FIXUP_THINKPAD_HEADSET_JACK),
 	SND_PCI_QUIRK(0x17aa, 0x22c1, "Thinkpad P1 Gen 3", ALC285_FIXUP_THINKPAD_NO_BASS_SPK_HEADSET_JACK),
-- 
2.51.0



