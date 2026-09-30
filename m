Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD7551FCC3;
	Wed, 30 Sep 2026 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790916; cv=none; b=SHFJzVSAAVK8eVvdCOfQzk8a5aHsHGsdO8CkdeJoArXewEfetL0h9Cn2ig/rLmb7mIk0H0VuYbrw5Otk1FkB4IAwYTCAp2hblKI6j9+bILUFFd3wbg+sxCDOFXTB1H8Ww2SB7R3StaBxKxadfi1+VfmMDLJu/y/Men4cBCxaOuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790916; c=relaxed/simple;
	bh=29ZY8TIkZOgqAagAOoIF0Vz1Rjsx05UxHW8AHBnGthk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJlVWFSeYSdTbpGYRKiI/TpXl337vCJDdh9lsn7laFx+5tTn0nJzf7NqKoDxR3xTyTGJkFm2UGehIsIoyNa2oC1rZdpa+Q8vSL2dtvskgCTtqYWsoM8khoVVXITsqe8DTWD3SYDcI5+d4HWATt6KcLnQQ2ncQCb08Hj7NxZK3yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQ49Frl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQ49Frl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6621F000FF;
	Wed, 30 Sep 2026 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790915;
	bh=Oo/4pUFa8YRJl8avkIw/NgnRKFNHeHGaILMskrUJv6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MQ49Frl10F3c00jY/fDnHCGDfn4mz5tu5mkEPZ9dA9PyITcoLsKSZ1Z0I8l3+aN7c
	 QI2OxChbHYpuFcXwkWEEoye823Xvwd06TUyTm2zztGgXTIiRbJStswqJLp3HyNQ4F8
	 C1AXYkM0sOpz6ahHI7Lou42N8nACJpa5K5ZbHj4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Faleichyk <andrei.faleichyk@noogadev.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 117/752] ALSA: hda/realtek: Add quirk for ASUS VivoBook X509DAP
Date: Wed, 30 Sep 2026 17:19:47 +0200
Message-ID: <20260930152400.709808179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Faleichyk <andrei.faleichyk@noogadev.com>

[ Upstream commit 3580bc53520ce4efc94ece5886ad3670b93667ba ]

The internal microphone on ASUS VivoBook X509DAP (subsystem ID
0x1043:0x197e) is not detected without a quirk entry. Add
ALC256_FIXUP_ASUS_MIC_NO_PRESENCE to fix the issue.

Signed-off-by: Andrei Faleichyk <andrei.faleichyk@noogadev.com>
Link: https://patch.msgid.link/20260603213313.6298-1-andrei.faleichyk@noogadev.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index bd8878f4896c8..479e0fe7f7821 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9430,6 +9430,7 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x18f1, "Asus FX505DT", ALC256_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x194e, "ASUS UX563FD", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x1970, "ASUS UX550VE", ALC289_FIXUP_ASUS_GA401),
+	SND_PCI_QUIRK(0x1043, 0x197e, "ASUS VivoBook X509DAP", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1982, "ASUS B1400CEPE", ALC256_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19ce, "ASUS B9450FA", ALC294_FIXUP_ASUS_HPE),
 	SND_PCI_QUIRK(0x1043, 0x19e1, "ASUS UX581LV", ALC295_FIXUP_ASUS_MIC_NO_PRESENCE),
-- 
2.53.0



