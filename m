Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F3F32E7F1A;
	Thu,  3 Jul 2025 14:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554762; cv=none; b=YFhnnoWykR/h6e1yH+9ac2/S4kvcaxmiBDMauONJDIox2SXujUNAwlVWByDU0vyFez1bxWwNvUKTsXxv+7uTYpnPVmMYvUU+GR8AKUprbAPs4oKxtzrtPZ1oZuZwIRhUTE1LkqpDsm7F8VPnteiBuRcySietZoG5jhuc/ncm5a8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554762; c=relaxed/simple;
	bh=Wy54H1ZINiMLakNjSVwr0kah3SR5YZ6C+zZVO6RGR4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MokoKtkuoQ1UpJ0smfVcQSObzw9r+ry0Zh1El1sgvmeIUrPYLf/x8RFLdOcHTKR/4mZkHE0tXqhcvqDH5Pu0uJAzm/Pbxmb/g78Cj9mwdAcrelD+WzkHOqcMPK+DSllQ3aNAvfg0OFfSd4DRL4QZmThKK2cdwf9hUVJ30M7WVIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TbYjwrH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TbYjwrH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98ECC4CEE3;
	Thu,  3 Jul 2025 14:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554762;
	bh=Wy54H1ZINiMLakNjSVwr0kah3SR5YZ6C+zZVO6RGR4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TbYjwrH4rVNRbkMEtWXCIj5zFbIp8AACQ0QBHR/B+GgV10LjPU7Eqtz9YEFd2wRFJ
	 4QoweKWfWE+hG9AK7wN9Rw643Yp902+j2locwPxSKWgbc2CeNJIdMFS5EWB+0aQ15q
	 XxAgN9JC8kUHwX71KA7OWQy7xm3TLESjctl37IWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 071/263] ALSA: hda: Add new pci id for AMD GPU display HD audio controller
Date: Thu,  3 Jul 2025 16:39:51 +0200
Message-ID: <20250703144007.157403177@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 77a2984c3741d..eb7ffa152b97b 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2717,6 +2717,9 @@ static const struct pci_device_id azx_ids[] = {
 	{ PCI_VDEVICE(ATI, 0xab38),
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



