Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BDD23D7CF;
	Wed, 25 Feb 2026 01:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983693; cv=none; b=G7OG0kkFpfQLaewk43ZjRi3uy2MUX9Pcpn2nctr7pwT0GWYm4jwi6KgKNCR+blFo+dGBf6/AIw5hoVBBoMD0G25gDK82yc839jqndTyJTOiOMENRtY05uDLuskECXsNUWWrobE4x54n03aO/I8UWmi0Kvhf0A4CRlkx9ow7TRdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983693; c=relaxed/simple;
	bh=FjJjZCogl1K1hcwX4Q1lRtPuyakLk0XFbX9g6XOtwBI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHl3tdZaDTrYPigqMShqv+uTUj7K+3UhbRMAfUAb739HCZvsGRbdeimt0FOC7/ivxqifNdwjRsiuXSaHLAlWe5ngPFCtMcNh2AgZ43WMyeeq4hi6KlXKBWPAqXBFFn5qKn83J9jh8BCB+tjXlx7esodSRXBPxs4QIeiO4L5vfmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TlJNpoxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TlJNpoxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BA3C116D0;
	Wed, 25 Feb 2026 01:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983693;
	bh=FjJjZCogl1K1hcwX4Q1lRtPuyakLk0XFbX9g6XOtwBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TlJNpoxDJLegZE63qFhDn+o3NOPjVEH8BZy40m9IjPyeiVQ10KNrPD3fKox4AsTWN
	 N0vMpa7KY5ER/etYDtIzG75EQyxPnlGltSk9/3GZyNTcfKIusDH7ViP4G+TSa5c8c3
	 rRGfNWhZzGghOWIjwRqKMvonuIp62a0qATYxpq7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Naim <dnaim@cachyos.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 775/781] ALSA: hda/realtek: Add quirk for Gigabyte G5 KF5 (2023)
Date: Tue, 24 Feb 2026 17:24:44 -0800
Message-ID: <20260225012418.724594668@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Naim <dnaim@cachyos.org>

commit 405d59fdd2038a65790eaad8c1013d37a2af6561 upstream.

Fixes microphone detection when a headset is connected to the audio jack
using the ALC256.

Cc: stable@vger.kernel.org
Signed-off-by: Eric Naim <dnaim@cachyos.org>
Link: https://patch.msgid.link/20260210093403.21514-1-dnaim@cachyos.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/hda/codecs/realtek/alc269.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -7057,6 +7057,7 @@ static const struct hda_quirk alc269_fix
 	SND_PCI_QUIRK(0x144d, 0xc886, "Samsung Galaxy Book3 Pro (NP964XFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1ca, "Samsung Galaxy Book3 Pro 360 (NP960QFG)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1cc, "Samsung Galaxy Book3 Ultra (NT960XFH)", ALC298_FIXUP_SAMSUNG_AMP_V2_4_AMPS),
+	SND_PCI_QUIRK(0x1458, 0x900e, "Gigabyte G5 KF5 (2023)", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),


