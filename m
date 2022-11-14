Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E724B4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DC76C433D6;
	Mon, 14 Nov 2022 12:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430645;
	bh=t7zT8+wEbJWt0aZp/zsZWDeomMN4gQ6fjDyC64xiFVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q60/d0x1puEMMT5P18/0OMSMLRIwCi1U8rEs6qUZ5H3KjApGNGFdOdYlGZDuurC9e
	 74Hpd0xAQ5Tk3Plan8hwRASfQNA1aHkgINzVjyB0tOyDxmemum6IHKIKEYBeXCDcO6
	 K6GbtcVn6ddvgyb1pxcZHWkxN4dGV8nM2nuBdliM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Evan Quan <evan.quan@amd.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 089/131] ALSA: hda/hdmi - enable runtime pm for more AMD display audio
Date: Mon, 14 Nov 2022 13:45:58 +0100
Message-Id: <20221114124452.489753000@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
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
@@ -2687,6 +2687,9 @@ static const struct pci_device_id azx_id
 	{ PCI_DEVICE(0x1002, 0xab28),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },
+	{ PCI_DEVICE(0x1002, 0xab30),
+	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
+	  AZX_DCAPS_PM_RUNTIME },
 	{ PCI_DEVICE(0x1002, 0xab38),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },


