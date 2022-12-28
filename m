Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85631C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:53:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3556EC433D2;
	Wed, 28 Dec 2022 16:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672246400;
	bh=4TVCKaRbeWhAEp0UoBc2bJjHD+aZbl8euEkU9XFh75U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JU2O9Fmrf+kX3FzFf23NMtfXyZtO1ewkBbDRfNrtFyFwTMrkGvLBnX1VRvzaVsEnL
	 /PMld5TGifoikB3/vCwZz1rGi4wtsMC3itjUM5KDHPtyN9ZxbjCU/jibQKKMBqNOVy
	 r7FZXfAr90LyXu9uTAoBsP8EWG0DN6+ZsY1qiJ70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiao Zhou <jiaozhou@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.0 1030/1073] ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list
Date: Wed, 28 Dec 2022 15:43:38 +0100
Message-Id: <20221228144356.169891248@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiao Zhou <jiaozhou@google.com>

commit 31b573946ea55e1ea0e08ae8e83bcf879b30f83a upstream.

HDMI audio is not working on the HP EliteDesk 800 G6 because the pin is
unconnected. This issue can be resolved by using the 'hdajackretask'
tool to override the unconnected pin to force it to connect.

Signed-off-by: Jiao Zhou <jiaozhou@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221206185311.3669950-1-jiaozhou@google.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_hdmi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_hdmi.c
+++ b/sound/pci/hda/patch_hdmi.c
@@ -1976,6 +1976,7 @@ static int hdmi_add_cvt(struct hda_codec
 static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
+	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
 	SND_PCI_QUIRK(0x8086, 0x2081, "Intel NUC 10", 1),
 	{}


