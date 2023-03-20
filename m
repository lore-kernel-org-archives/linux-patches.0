Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8881C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:07:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92CA6C433EF;
	Mon, 20 Mar 2023 15:07:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324868;
	bh=XoXp1zVDk8va1TV4vbn3meuLr7xQcugivYD1jQqMmJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdRUJkIjqS80v8mdLm9BQ/JN3TBieq6Plwh1+7IdiIWJKwjnQD0JUb0vmL1p5PZF2
	 w3Jegv7q22d+ZLDyFsY3YC99kgKQd3VsWzbuXeJWr4O3IYcNQiNRLDtDkok9ZczG13
	 prvI0MJO3pxQNuQCDYDzUrb2qrrUVVqS6tHrAI9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Hamidreza H. Fard" <nitocris@posteo.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 67/99] ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro
Date: Mon, 20 Mar 2023 15:54:45 +0100
Message-Id: <20230320145446.207063476@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hamidreza H. Fard <nitocris@posteo.net>

commit a86e79e3015f5dd8e1b01ccfa49bd5c6e41047a1 upstream.

Samsung Galaxy Book2 Pro (13" 2022 NP930XED-KA1DE) with codec SSID
144d:c868 requires the same workaround for enabling the speaker amp
like other Samsung models with ALC298 code.

Signed-off-by: Hamidreza H. Fard <nitocris@posteo.net>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230307163741.3878-1-nitocris@posteo.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9091,6 +9091,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
 	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
+	SND_PCI_QUIRK(0x144d, 0xc868, "Samsung Galaxy Book2 Pro (NP930XED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),


