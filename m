Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A202EE281;
	Thu,  3 Jul 2025 15:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751556061; cv=none; b=QlRPCQd+XmwtsjOY+IWlqKLSnIe5Dd/1dQNkdpfvFFVdq8Xl62wTNlPQBWAkDN1Fg3YiZORiFSk03iNa8Uqq2QFA7v2pa4rJqnrUS2KjsKA0cf4qphUgN2mz3JtVAJ5vB69N7HBnAJeQ39JzEHIu6IEIWTColbPalJUwg1J/dG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751556061; c=relaxed/simple;
	bh=KobhHjWofPOYAFui264coq9wkZ4b4SNG9XdY93hdX28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0H1xZWl96gwI+LO2xHPbvXh6cLpyUo6zCYzj/GXf5/Nzz4X9D1VuX2iwBuW7VsK59nwfnB+UdJeugvPCw8ZWAtyyocdoKNM05EnDgeEFfmvbJpMd8IYlK2pV4t0bb0ZRazuC5bGdelI1JUlHa3aONfQOpoVwWkCclt7tR6CXgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a0iSxHXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a0iSxHXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D8EC4CEE3;
	Thu,  3 Jul 2025 15:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751556061;
	bh=KobhHjWofPOYAFui264coq9wkZ4b4SNG9XdY93hdX28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a0iSxHXUaEck1U6BvWQTetW2coGU3CZET/7ouGyDJAs0dOvb5D6epn23m2yI2Gpdt
	 cK9Ti2qMI/2Igj0BWF3mq6ARM/ej9dmQ0PWwz9vRWSCGEFifjnb/xBfVOiCOaH+Gb7
	 VIiDiZzqv7CZlfb1lbvxTnDjkvM/spUde5EFMofY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/132] ALSA: hda: Add new pci id for AMD GPU display HD audio controller
Date: Thu,  3 Jul 2025 16:42:01 +0200
Message-ID: <20250703143940.679249842@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143939.370927276@linuxfoundation.org>
References: <20250703143939.370927276@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit ab72bfce7647522e01a181e3600c3d14ff5c143e ]

Add new pci id for AMD GPU display HD audio controller(device id- 0xab40).

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://patch.msgid.link/20250529053838.2350071-1-Vijendar.Mukunda@amd.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index d1639d8c22985..1bb315c175f67 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2793,6 +2793,9 @@ static const struct pci_device_id azx_ids[] = {
 	{ PCI_DEVICE(0x1002, 0xab38),
 	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
 	  AZX_DCAPS_PM_RUNTIME },
+	{ PCI_VDEVICE(ATI, 0xab40),
+	  .driver_data = AZX_DRIVER_ATIHDMI_NS | AZX_DCAPS_PRESET_ATI_HDMI_NS |
+	  AZX_DCAPS_PM_RUNTIME },
 	/* GLENFLY */
 	{ PCI_DEVICE(PCI_VENDOR_ID_GLENFLY, PCI_ANY_ID),
 	  .class = PCI_CLASS_MULTIMEDIA_HD_AUDIO << 8,
-- 
2.39.5



