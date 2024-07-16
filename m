Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD871DDCE;
	Tue, 16 Jul 2024 16:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145933; cv=none; b=QZtF8IFk9XyJ5D5WblZFgShr+QNzo4vdoVeCrnd/lkgiEhs0ulvSmKGrPxVtAu8oj1cGjwBLL6Z4fIBa52xCuM5vyHWZGnS/IFRSW2yDAEnV3b5tL+5Up1o+DT7b7sQ6pZT6l6/XwY8Cseqz59IOYjELS+T4YVPjsqsfpAjFWms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145933; c=relaxed/simple;
	bh=xFxjtpsvD1th8UMLY69wYKYUhqAEBVcOKaBM2fjdjnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cudd37GEjgB+sWaPC6ZsHOhurPIIxjTpcYjQRpmgd3WcBFLgsCa+AVs2zNhx9tkNUeC+Qme4TuY/vm6qPHNdk1tiEfAV4gQo02dZt3ZUAOJaaEyRRX+mUXpxkesADrqOsTIlexXfvc7+5fwheMy/IIiv9c+bvWQfIZ4Lxktr0po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yFZMcB/Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yFZMcB/Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E891C116B1;
	Tue, 16 Jul 2024 16:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145932;
	bh=xFxjtpsvD1th8UMLY69wYKYUhqAEBVcOKaBM2fjdjnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yFZMcB/Yb8uHMJCw3cA9UFPzjByTQehf747+7uyE6xR/xh9GuK8auXqG4whj+fOH9
	 U3+mWwWZVCGbY9ze6j8tH8OXlS0peKLQgFSkO8SMGbJG5GPCPaRCpKNKgIUW1aT4yr
	 cGitRdx5DFGFACnA4nT8RAIE/FAjCrI9maIGGjes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.6 086/121] ALSA: hda/realtek: Limit mic boost on VAIO PRO PX
Date: Tue, 16 Jul 2024 17:32:28 +0200
Message-ID: <20240716152754.636343032@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

commit 6db03b1929e207d2c6e84e75a9cd78124b3d6c6d upstream.

The internal mic boost on the VAIO models VJFE-CL and VJFE-IL is too high.
Fix this by applying the ALC269_FIXUP_LIMIT_INT_MIC_BOOST fixup to the machine
to limit the gain.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240705141012.5368-1-edson.drosdeck@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10087,6 +10087,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x10cf, 0x1845, "Lifebook U904", ALC269_FIXUP_LIFEBOOK_EXTMIC),
 	SND_PCI_QUIRK(0x10ec, 0x10f2, "Intel Reference board", ALC700_FIXUP_INTEL_REFERENCE),
 	SND_PCI_QUIRK(0x10ec, 0x118c, "Medion EE4254 MD62100", ALC256_FIXUP_MEDION_HEADSET_NO_PRESENCE),
+	SND_PCI_QUIRK(0x10ec, 0x11bc, "VAIO VJFE-IL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x10ec, 0x1230, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x124c, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
 	SND_PCI_QUIRK(0x10ec, 0x1252, "Intel Reference board", ALC295_FIXUP_CHROME_BOOK),
@@ -10340,6 +10341,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1d72, 0x1901, "RedmiBook 14", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1945, "Redmi G", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1d72, 0x1947, "RedmiBook Air", ALC255_FIXUP_XIAOMI_HEADSET_MIC),
+	SND_PCI_QUIRK(0x2782, 0x0214, "VAIO VJFE-CL", ALC269_FIXUP_LIMIT_INT_MIC_BOOST),
 	SND_PCI_QUIRK(0x2782, 0x0232, "CHUWI CoreBook XPro", ALC269VB_FIXUP_CHUWI_COREBOOK_XPRO),
 	SND_PCI_QUIRK(0x2782, 0x1707, "Vaio VJFE-ADL", ALC298_FIXUP_SPK_VOLUME),
 	SND_PCI_QUIRK(0x8086, 0x2074, "Intel NUC 8", ALC233_FIXUP_INTEL_NUC8_DMIC),


