Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1B033F8AA;
	Mon, 20 Apr 2026 16:06:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701195; cv=none; b=ZaB5J50tjCs3gs1hcHFNATpCEUr1L6gnM+IvkADPMw3Rs6j546DzY9XE31erforYXhIiFqZ/LtV+yiMW3kyHw7W7B1lmaWp0yGwne9xUw2c51cs+yh5cPeQhyrOWxDopAqIJ/VHlNd1pYcJsXy6i5cmTVCSESdyrce6LSKWzOgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701195; c=relaxed/simple;
	bh=Q1iSAtKYqSl3xEuiS+I1QY4w4FurT36i1vb6W6v0glg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfMAsy1DxpjQYEGN4LhZhCiTnc2GdYbW+tgAjlQTFloTRwBXtANy2SXYgQlYFDwae0q0Y1T0o0pFvlZQu+00fDcAZRPeibOtPp+41hVu0XO/lH2fiacqp5HRAOiW9iCLXevyqIryUvzJ2/6V8jmuwNCpTK5BIuVw7WLjJ6lZkBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTFY4nmP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTFY4nmP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E78C19425;
	Mon, 20 Apr 2026 16:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701195;
	bh=Q1iSAtKYqSl3xEuiS+I1QY4w4FurT36i1vb6W6v0glg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTFY4nmPW0vBaAFdDlYUvwOcfuNVHsRzAyNGk/dcIBOs7PAa8cv42n245i44fbnyi
	 9vN1fJOTLRoLkFKcvD12OR78xHw3fBoZfs49SCSoKUWWprb5knf7Ox1K3wT41hnVh4
	 lFIvWflhUHcZzYZCCEEZqLOblIhn3ISDoM5safRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Throw <zakkabj@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/162] ALSA: hda/realtek: Add quirk for Samsung Book2 Pro 360 (NP950QED)
Date: Mon, 20 Apr 2026 17:40:52 +0200
Message-ID: <20260420153927.752320229@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ea31be8a2c8c99eac198f3b7f2dc770111f2b182 ]

There is another Book2 Pro model (NP950QED) that seems equipped with
the same speaker module as the non-360 model, which requires
ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS quirk.

Reported-by: Throw <zakkabj@gmail.com>
Link: https://patch.msgid.link/20260330162249.147665-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 2a32e1ead5e86..04e10da997b53 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -11335,6 +11335,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x144d, 0xc176, "Samsung Notebook 9 Pro (NP930MBE-K04US)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc189, "Samsung Galaxy Flex Book (NT950QCG-X716)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc18a, "Samsung Galaxy Book Ion (NP930XCJ-K01US)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc1ac, "Samsung Galaxy Book2 Pro 360 (NP950QED)", ALC298_FIXUP_SAMSUNG_AMP_V2_2_AMPS),
 	SND_PCI_QUIRK(0x144d, 0xc1a3, "Samsung Galaxy Book Pro (NP935XDB-KC1SE)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a4, "Samsung Galaxy Book Pro 360 (NT935QBD)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc1a6, "Samsung Galaxy Book Pro 360 (NP930QBD)", ALC298_FIXUP_SAMSUNG_AMP),
-- 
2.53.0



