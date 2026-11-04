Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830980;
	b=lEf6RdDYkcIwLoUc0IhEeUj6IhoiX1HTsiudCKTM3e+9bT5HcrMBMJdKlrYp+n9hVLVR
	 unzlTrTwo5F8MIn57HzgFEUiWjC9jU0Qkwbln+59+EF8B/bP3ReuNQjEmpBwsdkauZtsG
	 yz2jtzBiodtzDxhjA945+xqFsIU5z4cg8BFCeuJTO9ncbUSwKDirBlNuIkCDfs/6TNA7E
	 +ANBU6haT5CFDnnuni1fOLV1BB6pHrISeS3n1DpPkULlm0t2WIWyE+k4fmwDT2uCOK6hO
	 BEjZRY4mcUyr2PclMi8G2GVy+dDKNyZySd8XPqqb/jVDgBc76XFsE7K8ct+2UWb8Hgw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830980;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UoxaLFlUs0DGfkQ+q0EpQehBOw+eGBX9iDTqLGYFlwo=;
	b=19Q+JjVFWsGV3MD8csTcEc473qm1rxw4Y5l+fx0EWuMbJ2l9kqBHOVf+C0kKk6KTJS8+
	 2B8p3VdNB4DkizCQHBp3oM+048WoZdwMbyt0La/7cgTcqDF0LerK7pRFiFGa9u0CSsI6v
	 U+huhFeaZT0lH2jLHBf8r+EK6vu7t7AQdMGwydUgM8uixu3Oox2kQmVsT5QT1fuDIPtpZ
	 wdsa0Wm+4BY3tvUWOjqQ4PDuWtpAhDRCJgEW2yqX/2UcScJevU2YtlTkhUBoeO8vwbslm
	 9APw+wz7llXHkQkur5IXJZo5HQtmWqN3z4QFFGAjjW7WZ/Xs9yNZDEvFBfu9ztGpx6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bldJjTog;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B1F606AB19;
	Wed,  4 Nov 2026 22:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bldJjTog
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5110F1F000C1;
	Wed,  4 Nov 2026 22:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830979;
	bh=UoxaLFlUs0DGfkQ+q0EpQehBOw+eGBX9iDTqLGYFlwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bldJjTog9DLfcLgnxasGFkbWITJAMuxeh/Elp+2WtpdNxwh/RRcg2zzeHEcwsGI4M
	 ToKP7sKHnamwas2IZsQzqujeRwJ1s6L1fTpij+wZwwzLwrrgayUbu0yDpChn/xIB41
	 pTZrmkLsgi+ZIcuWvk9PAGocRF289d4L3WDjHv5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nirmal Patel <nirmal.patel@linux.intel.com>,
	Szymon Durawa <szymon.durawa@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jonathan Derrick <jonathan.derrick@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0439/1005] PCI: vmd: Add Nova Lake (NVL) and Dunlow (DNL) Device IDs
Date: Wed,  4 Nov 2026 16:02:52 -0500
Message-ID: <20261104211056.374569055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Szymon Durawa <szymon.durawa@linux.intel.com>

[ Upstream commit 55aa45154fe48b7d8e96bc031ad27d5b0edfcdb8 ]

Add VMD Device ID Support for Intel NVL/DNL processors.

Suggested-by: Nirmal Patel <nirmal.patel@linux.intel.com>
Signed-off-by: Szymon Durawa <szymon.durawa@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Nirmal Patel <nirmal.patel@linux.intel.com>
Cc: Jonathan Derrick <jonathan.derrick@linux.dev>
Link: https://patch.msgid.link/20260819130523.398493-1-szymon.durawa@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 5d3e6cc7e4feb..aa6d4f56f612a 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -1141,6 +1141,10 @@ static const struct pci_device_id vmd_ids[] = {
                 .driver_data = VMD_FEATS_CLIENT,},
 	{PCI_VDEVICE(INTEL, 0xb07f),
                 .driver_data = VMD_FEATS_CLIENT,},
+	{PCI_VDEVICE(INTEL, 0xd70b),
+		.driver_data = VMD_FEATS_CLIENT,},
+	{PCI_VDEVICE(INTEL, 0xd73b),
+		.driver_data = VMD_FEATS_CLIENT,},
 	{0,}
 };
 MODULE_DEVICE_TABLE(pci, vmd_ids);
-- 
2.53.0



