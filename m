Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C7146B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:27:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97509C433F0;
	Mon, 16 Jan 2023 16:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886475;
	bh=1lFtNkUfgExkNrAfpV7RNJeHL4xlyWEIlA4y8vv6YOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bnc2N2nQCBi0c8kNZbGYzVXuxs6iohevC48luMi1ig8UnLwqOeA4jIU89XjivF3m3
	 Lm1xzjIp66R/C6XfearDsQnlm6Skh2OpHQ30bidLcdk5KRNj6YIRUDTmEBiZJ5XFOZ
	 QVe4dHKTkTPT61MPRPL0jy0XF+ShIzFDzvwfHdhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiao Zhou <jiaozhou@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.4 443/658] ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list
Date: Mon, 16 Jan 2023 16:48:51 +0100
Message-Id: <20230116154929.790464767@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
@@ -1820,6 +1820,7 @@ static int hdmi_add_cvt(struct hda_codec
 static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
+	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
 	{}
 };


