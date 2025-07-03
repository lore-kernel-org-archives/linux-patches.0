Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F388D1DB124;
	Thu,  3 Jul 2025 14:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554007; cv=none; b=aNNLRapGeFE4TY1XfKF5Wg7QU3jPn2kqrmtu/1j5bhpPJlsswhg6bawajUAEerknzI0aBESYoynC9ORmI9l47ZiDJO61CIdCgVgW2MpoBD9H8Tzn6Bm/JDGqhWHrGI4LOnnef4e6cqtgyUKITaTjqOICg8Yz4768QlMB1T58I9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554007; c=relaxed/simple;
	bh=ZNlOmAyo27euf/ZB+23ULmah667F2Gkify/FiARjX1w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6ZTHFuXBAMFWRDwBVmoASsUdJh42WcwqTZY3+ioN0FMqw3v/GKDHk3usCmFMb9ne3P9PTh4L8xTTwdHUbSb1Z+6BM4ANZ/eEQXS7hFusm11jnS15m0Qm4vv+QFaoWnlpexmiApoUf4eFBPHnECoMOiV9Mi1HTtwQNwv2bfphk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFBEAVDi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFBEAVDi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63361C4CEE3;
	Thu,  3 Jul 2025 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554006;
	bh=ZNlOmAyo27euf/ZB+23ULmah667F2Gkify/FiARjX1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFBEAVDiD0d2ifjFa2GP+t5xMCwYXav1nMV1Eoe/UmkxBs3o3UiezOYbRWWKI+YqA
	 HUiJ3Mafxdp+qf8yYpXSuFN/sMecRVlGx3l6K4KSeIMRyXZmB4Q2Bw2oQsahdDz57Z
	 dc97ZVwH6z7LAoNTr2qsD92/UMGLm2UQOY5nrm1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 051/218] ALSA: hda: Add new pci id for AMD GPU display HD audio controller
Date: Thu,  3 Jul 2025 16:39:59 +0200
Message-ID: <20250703143957.974205821@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1872c8b750537..d4e325b785332 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2727,6 +2727,9 @@ static const struct pci_device_id azx_ids[] = {
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



