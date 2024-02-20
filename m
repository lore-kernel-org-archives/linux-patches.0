Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256F4446C9;
	Tue, 20 Feb 2024 21:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465120; cv=none; b=Su9lF0lFp/XsNy78pD1nFKpXvMteFzJUr/aDXhYsHCGzvJlJrAVPFNKeBbUDqiJRYfmoUv60nJ/4GYI9JjZB15VUycIJPA10wICqQvOqROD7h1prnrtiwms4jLXsVWSCZWuVf6iWy9r3P0+ji9RJaQ3WEjStVbc+GQ61Kz7B3pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465120; c=relaxed/simple;
	bh=u0395+UQfa+IoEgioWe7wbQ2v/QUBspVjH8V/mi3Rl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKF192PFOfRlbxNCPW1m3li5rBKkH3YXPlLDMZGrWm0T91neKS/+80OFYOM3OXEwESAeliGxGSwf4yqcz/s8qaPn2hTWygCp5D1KSB+sTMvaINpGmnyLi4mxcTCNRe0g6T5wmfzt228iH5LegJ6dC+cIaItexob6ubvUFi7G+VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZ5X3mYZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZ5X3mYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8969EC433C7;
	Tue, 20 Feb 2024 21:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465120;
	bh=u0395+UQfa+IoEgioWe7wbQ2v/QUBspVjH8V/mi3Rl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZ5X3mYZlu4ZrW1/XdOmRuMSl3k1P+NQCcJFSI+V1AMqyDW85XJM4w0YJQaSW1E8Y
	 P6806bBJM2syxDthO0L9Whi3GpZB5dgaUsvLX/Y7Gi1zF3xC1FsrPVSjCYZD5HaLDp
	 p89bX2D3vA0AzynjVm8zEFzYy8StC2e014w027TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.7 242/309] ALSA: hda/realtek: add IDs for Dell dual spk platform
Date: Tue, 20 Feb 2024 21:56:41 +0100
Message-ID: <20240220205640.735558738@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuming Fan <shumingf@realtek.com>

commit fddab35fd064414c677e9488c4fb3a1f67725d37 upstream.

This patch adds another two IDs for the Dell dual speaker platform.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20240205072252.3791500-1-shumingf@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9724,7 +9724,9 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1028, 0x0b71, "Dell Inspiron 16 Plus 7620", ALC295_FIXUP_DELL_INSPIRON_TOP_SPEAKERS),
 	SND_PCI_QUIRK(0x1028, 0x0beb, "Dell XPS 15 9530 (2023)", ALC289_FIXUP_DELL_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1028, 0x0c03, "Dell Precision 5340", ALC269_FIXUP_DELL4_MIC_NO_PRESENCE),
+	SND_PCI_QUIRK(0x1028, 0x0c0b, "Dell Oasis 14 RPL-P", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0c0d, "Dell Oasis", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
+	SND_PCI_QUIRK(0x1028, 0x0c0e, "Dell Oasis 16", ALC289_FIXUP_RTK_AMP_DUAL_SPK),
 	SND_PCI_QUIRK(0x1028, 0x0c19, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1a, "Dell Precision 3340", ALC236_FIXUP_DELL_DUAL_CODECS),
 	SND_PCI_QUIRK(0x1028, 0x0c1b, "Dell Precision 3440", ALC236_FIXUP_DELL_DUAL_CODECS),


