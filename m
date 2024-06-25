Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4F0148315;
	Tue, 25 Jun 2024 09:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308259; cv=none; b=dNGptsigCc3jOE34vME4l9nJJhnu/yQDK48d1LLMq8g5sGHE5H0KAhbUP+5Rgi+6t4Dq+PC11P86T4+1cBIQKshR5Z0J6ITt55rSAMVxF4Bj1iTxfig4mPLyxP926RYAqKgZN/4gk143GBsxVbNS/IXDx5U1Zucnf88/r/c6s30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308259; c=relaxed/simple;
	bh=UatcdDQs92xXvTfmi2CE79TQB1XD70WTQwP+VqCRv3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cx3yyS23Wh04Kf9aGF7i9Qzz2s+nxS+FgtT5BhFY3ILpRptHUTfq62uV0lF7KiRyOi4iigf2h2Falxa0K0piumxjHqHftH52VyPsGFAL2poUZBNHTA7upXtiJhBIsVA/4ApgVpmMNfspg1ZnoxgAkXvpIBnVUdfx6jURd8RatPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTEAhMsY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTEAhMsY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8C2C32781;
	Tue, 25 Jun 2024 09:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308259;
	bh=UatcdDQs92xXvTfmi2CE79TQB1XD70WTQwP+VqCRv3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTEAhMsYLziPOI6exvXtScRj0WLbBRgraJKZ305W7N1+IDwD9EXaU0fDnNZJlpcS/
	 cI+PGkF5cRySbr/7Y8xmw5lhuwH4OJuP7b+uKHudbYTn0hob4JxJiyGZe8qjQbDf5y
	 1aD2sTvnYwmV2kEXjV/O8sULcRzYvxvYhMNxsLm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Binding <sbinding@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 059/250] ALSA: hda/realtek: Add quirks for Lenovo 13X
Date: Tue, 25 Jun 2024 11:30:17 +0200
Message-ID: <20240625085550.328574618@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Binding <sbinding@opensource.cirrus.com>

[ Upstream commit 25f46354dca912c84f1f79468fd636a94b8d287a ]

Add laptop using CS35L41 HDA.
This laptop does not have _DSD, so require entries in property
configuration table for cs35l41_hda driver.

Signed-off-by: Stefan Binding <sbinding@opensource.cirrus.com>
Message-ID: <20240423162303.638211-3-sbinding@opensource.cirrus.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 152ad2c429a61..1e77bbba8de11 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10501,6 +10501,8 @@ static const struct snd_pci_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x17aa, 0x3852, "Lenovo Yoga 7 14ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3853, "Lenovo Yoga 7 15ITL5", ALC287_FIXUP_YOGA7_14ITL_SPEAKERS),
 	SND_PCI_QUIRK(0x17aa, 0x3855, "Legion 7 16ITHG6", ALC287_FIXUP_LEGION_16ITHG6),
+	SND_PCI_QUIRK(0x17aa, 0x3865, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x17aa, 0x3866, "Lenovo 13X", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x17aa, 0x3869, "Lenovo Yoga7 14IAL7", ALC287_FIXUP_YOGA9_14IAP7_BASS_SPK_PIN),
 	SND_PCI_QUIRK(0x17aa, 0x386f, "Legion Pro 7/7i", ALC287_FIXUP_LENOVO_LEGION_7),
 	SND_PCI_QUIRK(0x17aa, 0x3870, "Lenovo Yoga 7 14ARB7", ALC287_FIXUP_YOGA7_14ARB7_I2C),
-- 
2.43.0



