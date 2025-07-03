Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAAC2EE281;
	Thu,  3 Jul 2025 15:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555620; cv=none; b=JhTGXQ7yJV6LCN6eUuBoaDio3SCGs2+0RauKUdTTjQQFKLhqOl/ShRPqqnhmlC0QKFUZcl6ONqWEYkL5XXh0tDKp+xTjDccaA5YR/hUvdNP2v20NDQl7HD64OBSlGnRbk3ex0dH8kgwZzucgews6KMX4Tp9YW0mM2bD13K2fxtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555620; c=relaxed/simple;
	bh=kSfbm0AK4e6y4S9dsOBYovxIHiDbr9O8U7oQOyajiPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MsOnMndyhJXTuvaOlctQvekroy9AJhhbA+OVV+CyOUaTwX637xRrU5f5JENYwFzyIAp8I4En9GGLAwD7/PFhhEGK1FpH24XZaHRvRFpx92QJoT0UgCFosNz/k9sUgjZfeeLtPVbqSQ5NXbMAhjGYpvqlbFyBqsKkjH3DiShY+eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sDlsj2vp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sDlsj2vp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6879DC4CEE3;
	Thu,  3 Jul 2025 15:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555619;
	bh=kSfbm0AK4e6y4S9dsOBYovxIHiDbr9O8U7oQOyajiPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sDlsj2vp9npagOkFmOKAaWMkuEBiwXaFOhsVk4Rp61GEAS56L6KcK2lf7lkUqLgEs
	 777d1GIqaVZ/HF49lecKyF4DIVR2c7uOrtnNH6dCH3zf3XCXP7/lvRgbCqhdUt6Xwg
	 UTEmy7OyQlUGtgatBZIw9rFETUbUkPACPAGDMphE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 041/139] ALSA: hda: Add new pci id for AMD GPU display HD audio controller
Date: Thu,  3 Jul 2025 16:41:44 +0200
Message-ID: <20250703143942.783925456@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3cd5b7da8e152..059693e03fd96 100644
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



