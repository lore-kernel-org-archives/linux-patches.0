Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140482E5B26;
	Tue,  8 Jul 2025 16:56:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993801; cv=none; b=S/xpyt4QU6VAjOGuZQcBldU7n/mqWlDNwSItmMN16eHHeMLX4oe2wqMWbcDikfiOU1Up6zdsmtWRIShdwgDwpiN0gtTYU78Kz9bTOHRV861zTgvvbI2c/nY8Z3tmi9dSRnnSnpqeiZaQ73rdDDX1Rle8v8/WCge6jYJYA98Qqxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993801; c=relaxed/simple;
	bh=O5TDb5HNP4ftS15x1BQqy0bxrNkVEa1jM2ejQBkdH8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRoqy5GvYXEyaG0RFt3vQsOrVD1Zonoa9T+Op3DN2QtioU8F83SgNVL3u/hP6NotEDo/wg6DduqcaRr8Oeuqw5e2pZAPN5jRPsdXF3yqFHhI7tmE7hdHzhN8r9R29XYEQOLZzdNEiK+pi5JpJMBdv1j/N7ovJZwiY+OoaM3XMpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mo6IPg51; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mo6IPg51"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C8FC4CEF5;
	Tue,  8 Jul 2025 16:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993801;
	bh=O5TDb5HNP4ftS15x1BQqy0bxrNkVEa1jM2ejQBkdH8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mo6IPg51StaqJqcndk5VtQmE02e8YmHAEM3j5BvcmDCbiUw0xh9bqdQm9RASLAdHl
	 se9TPikM/gomhRNq3UXfbL5uKSEh9+4DOXR++w+Q8f4lhbr0j/697+wHYfPhzp9O9p
	 +82XgCdCsp5W51gR1CALjewo5GpAy8sYyatW5ZNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/160] ALSA: hda: Add new pci id for AMD GPU display HD audio controller
Date: Tue,  8 Jul 2025 18:21:00 +0200
Message-ID: <20250708162232.151514696@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc8c066327b6c..c69f4e5989d4f 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -2731,6 +2731,9 @@ static const struct pci_device_id azx_ids[] = {
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



