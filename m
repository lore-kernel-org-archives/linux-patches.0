Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512D8183CD9;
	Mon, 12 Aug 2024 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478986; cv=none; b=J6Kz/vdknCcjM2gmnHJXUeyig5qcybLk1y8bEfDj8sNOVlvFgGoXEJaakX11jo2GuDv183eUcyNlULbAlap1LkO+8PEyMQfdZkvujsdOTTqovJV6SoYyiifyS4Hky4NM0VX/EYLwAj2vkMvAzp0HHqZDYFp4xmtJaOGrn0H8b4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478986; c=relaxed/simple;
	bh=FGdDpWmOxzs5Yw20QJajsgSrXB+5jfQcvyiHITvHLO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lz3Iwf7YEKs7NeKu1H+xFFyvIiRPTdSnd6O756WRnNRf2CS6Ilr6ycCZ7JYK8yTTLeVbt8IaMFFZ6zzVqyq1AxLYYWuXezd0NZGVsINBaUeagdcCF5jPCW/kCGGZVQiZ9blpgw+VXkagkfUnH9PQ1nu27gwK9E7FdhBf+ix/k+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZgaw7f5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZgaw7f5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA623C32782;
	Mon, 12 Aug 2024 16:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478986;
	bh=FGdDpWmOxzs5Yw20QJajsgSrXB+5jfQcvyiHITvHLO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZgaw7f5msSapgAEUUymNfi+iTvTpappChhcx1fpZXyiUyfoYeRmkOw6b9V+IDb5E
	 MnVKkKWMTsT97DBOqXDA/I+A6o0PXboGxW3USp5tiltAomDGYx6CJaRhmfP+7IDAbC
	 s+BlxO9l2L3FUYENdSxmlea9wO7yzQtjm1HbnFIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Steve Kendall <skend@chromium.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 090/150] ALSA: hda: Add HP MP9 G4 Retail System AMS to force connect list
Date: Mon, 12 Aug 2024 18:02:51 +0200
Message-ID: <20240812160128.638679339@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1989,6 +1989,7 @@ static int hdmi_add_cvt(struct hda_codec
 }
 
 static const struct snd_pci_quirk force_connect_list[] = {
+	SND_PCI_QUIRK(0x103c, 0x83ef, "HP MP9 G4 Retail System AMS", 1),
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),


