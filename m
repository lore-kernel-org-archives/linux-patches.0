Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A326179C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:28:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1745DC433D2;
	Thu, 12 Jan 2023 14:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533685;
	bh=C/dpVswrI9lDmQzaN5aS1llo9MxoRqXHInA2LGNLUuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xKvTQwD4apM8owF5x9yS9yiZOAAvKAXPtJfINdeGT9fSwPfy1kWZ+QNQAQPC88M/S
	 KiDtwEpBVUrSsZTEBDf9p7ZB3P34ZU9tK87+mF1IkwUaWw8mhpqMBjhN5ji3am+CZH
	 IjRS2TeMTVHbf5NCqybn/jzQw6e6kjGwTJfO0myo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiao Zhou <jiaozhou@google.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 558/783] ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list
Date: Thu, 12 Jan 2023 14:54:34 +0100
Message-Id: <20230112135550.113517425@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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
@@ -1965,6 +1965,7 @@ static int hdmi_add_cvt(struct hda_codec
 static const struct snd_pci_quirk force_connect_list[] = {
 	SND_PCI_QUIRK(0x103c, 0x870f, "HP", 1),
 	SND_PCI_QUIRK(0x103c, 0x871a, "HP", 1),
+	SND_PCI_QUIRK(0x103c, 0x8711, "HP", 1),
 	SND_PCI_QUIRK(0x1462, 0xec94, "MS-7C94", 1),
 	{}
 };


