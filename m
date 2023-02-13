Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C93F8F59
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 15:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EB7C433D2;
	Mon, 13 Feb 2023 15:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676300741;
	bh=9EfBHFwmAg/ALOqJP9K2vl2UUGoBT9ODbLCt3wKKdj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J8xedioM6jLvZWtcH2JOYnZbeJ3EiPFy0nL633heDvcfau0zk4gFUbVEawXxkY3sP
	 oGCq/wannpd4s+fDxbRub8iumUB6fGHQ8clRcj7MCzor52LsCTnVHaIVPJHGaGtHNd
	 4Y/+26d3oc6BG/g/2z9KRltSyRBt5A1xJDJAAycE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Pinot <texitoi@texitoi.eu>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 102/139] ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book2 Pro 360
Date: Mon, 13 Feb 2023 15:50:47 +0100
Message-Id: <20230213144751.241441596@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144745.696901179@linuxfoundation.org>
References: <20230213144745.696901179@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Guillaume Pinot <texitoi@texitoi.eu>

commit bd401fd730cbcb0717bbc5438f15084db10f9259 upstream.

Samsung Galaxy Book2 Pro 360 (13" 2022 NP930QED-KA1FR) with codec SSID
144d:ca03 requires the same workaround for enabling the speaker amp
like other Samsung models with ALC298 codec.

Cc: <stable@vger.kernel.org>
Signed-off-by: Guillaume Pinot <texitoi@texitoi.eu>
Link: https://lore.kernel.org/r/20230129171338.17249-1-texitoi@texitoi.eu
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -9090,6 +9090,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x144d, 0xc812, "Samsung Notebook Pen S (NT950SBE-X58)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc830, "Samsung Galaxy Book Ion (NT950XCJ-X716A)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x144d, 0xc832, "Samsung Galaxy Book Flex Alpha (NP730QCJ)", ALC256_FIXUP_SAMSUNG_HEADPHONE_VERY_QUIET),
+	SND_PCI_QUIRK(0x144d, 0xca03, "Samsung Galaxy Book2 Pro 360 (NP930QED)", ALC298_FIXUP_SAMSUNG_AMP),
 	SND_PCI_QUIRK(0x1458, 0xfa53, "Gigabyte BXBT-2807", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb120, "MSI Cubi MS-B120", ALC283_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1462, 0xb171, "Cubi N 8GL (MS-B171)", ALC283_FIXUP_HEADSET_MIC),


