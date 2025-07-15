Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023BD2D29D9;
	Tue, 15 Jul 2025 13:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587453; cv=none; b=hcjuddKU8vC0ldqsWGGAbzbGKcJIxECeYmLKEjrYdNO9cKIFnDLo2Q+/OzWDN1RFH2eQvr6udtK6xilmSYyn+bhdDPkwNhwwhX5QDqmMaw1bpsd8LEkMXB42lkC3CXiF1BN74kUn6Xdgazeh9KulFRDkzJJpO3CYfAL/EAwFP9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587453; c=relaxed/simple;
	bh=NsXCx1Py0GImdh/qIew17oBnxLWpPEaxMfXlsb7UGb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O8RwF5vqAWApgr109j4CG/eapMJPGdthb5JfyIFfGI3FmPBxMarZuaOaXJ3kHQkwH8rcX7Ymvg45IkAW+BVEqQirRMoxKCoFn9ISmNJESTERnRNxvQSR+Ywc5j3maaQibJMzulOseFYcj8SPWeVSCYAjPhLPN1mV8ocgKCSfjrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xSNPRCJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xSNPRCJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58902C4CEE3;
	Tue, 15 Jul 2025 13:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587452;
	bh=NsXCx1Py0GImdh/qIew17oBnxLWpPEaxMfXlsb7UGb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xSNPRCJMY60Qe3rBWF333FGpDM5RoMrjQM9BAAKb0X/c0WNybsVrKaEEvkfpEdxx1
	 glA0q4K7W8gOXZ6Ojp6WrSyXnOON6RrdVXmGUUG85L9G2d9OuAIQIaBLzMp8+buWCD
	 z/PWV01nIpBGpKvJVoqCR7ZDGiZRMZbJqc90583g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 018/208] ALSA: hda: Add new pci id for AMD GPU display HD audio controller
Date: Tue, 15 Jul 2025 15:12:07 +0200
Message-ID: <20250715130811.562327718@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dd7c7cb0de140..cb3dccdf3911c 100644
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



