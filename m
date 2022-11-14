Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC234C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E71AEC433D7;
	Mon, 14 Nov 2022 12:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430217;
	bh=lJrCFjWA0Zc8pej8QlPJotwweJEXx5HZlrw36MD+2v8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fXYaVt44pwDpoq7m+szpdffxYsnzJlzOASHl2xn3GSCyu3uqIlkk5lxiVkZvk2UKs
	 jIhrMalLogS9KLXZbMkqSZaRfdZlVtc77oUnuoOcX1UBzDDPFxW2QDKUsES/lf15kV
	 yrMKg/IcQQ8vAhHRA+QhKGXEblQJAS5lKoL6zbAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 61/95] ALSA: hda/hdmi - enable runtime pm for more AMD display audio
Date: Mon, 14 Nov 2022 13:45:55 +0100
Message-Id: <20221114124445.053283095@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124442.530286937@linuxfoundation.org>
References: <20221114124442.530286937@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Evan Quan <evan.quan@amd.com>

commit fdcc4c22b7ab20e90b97f8bc6225d876b72b8f16 upstream.

We are able to power down the GPU and audio via the GPU driver
so flag these asics as supporting runtime pm.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221108084746.583058-1-evan.quan@amd.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/hda_intel.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2749,6 +2749,9 @@ static const struct pci_device_id azx_id
 	{ PCI_DEVICE(0x1002, 0xab28),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },
+	{ PCI_DEVICE(0x1002, 0xab30),
+	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
+	  AZX_DCAPS_PM_RUNTIME },
 	{ PCI_DEVICE(0x1002, 0xab38),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },


