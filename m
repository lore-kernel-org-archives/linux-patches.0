Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F5BC2AE96;
	Tue, 29 Apr 2025 18:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949991; cv=none; b=EwfNW4PHr5+TVSuLThwHkoDT2piOrI5iXTBvc36c0AX5H/Q71OrHaFaZ2z7l8aSaD31EypDWpwKZTxlkx78PdIk+zxgtHgS+XgIPvLHaTk+kdchjuGMd2znBsZbsYAYPf44Bp10Vy4zxbDiCgoUypnmds/ljE8D3Xkv+dUr2DuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949991; c=relaxed/simple;
	bh=7mnbDvI9OZsJiN/WXEOLwWwiUK43jfhXP0iUHcDfb1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ObQnaqHfb/aFxq9nm5jDHcVGIIkw+KneQ0WkUHwU0L/pvEtoB5qsCpHHeiNa12LCfvUdLfwdfRsrAzFCql1tb6uPBQiVVgmknE1TYbqUdTHu0soPNlUIBs/0VoyA/mtZ5MhWWSL7kopsG7BM7PKqCpxVLCQg4m6+JEubGDkumWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ih+T9+pe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ih+T9+pe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDC8C4CEE3;
	Tue, 29 Apr 2025 18:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949990;
	bh=7mnbDvI9OZsJiN/WXEOLwWwiUK43jfhXP0iUHcDfb1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ih+T9+peKx4oEwCpuUbDD/o621VvWcwwehiUmCfqJ8PW/mqaUMg4BoE5BJeEPDc5a
	 GdDL7eQo1+lMTTnXVqQyTxVoUWzoRXfLv/uL3k8f1AJcfVm/w1dqGDy0KkqoouWWxR
	 +hVY2EBzdSozWbvHR0AkLzFcAx29TgytuRRnzmEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/167] ntb_hw_amd: Add NTB PCI ID for new gen CPU
Date: Tue, 29 Apr 2025 18:43:48 +0200
Message-ID: <20250429161056.597027270@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit bf8a7ce7e4c7267a6f5f2b2023cfc459b330b25e ]

Add NTB support for new generation of processor.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/amd/ntb_hw_amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/hw/amd/ntb_hw_amd.c b/drivers/ntb/hw/amd/ntb_hw_amd.c
index 730f2103b91d1..9c8dd5dea2733 100644
--- a/drivers/ntb/hw/amd/ntb_hw_amd.c
+++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
@@ -1323,6 +1323,7 @@ static const struct pci_device_id amd_ntb_pci_tbl[] = {
 	{ PCI_VDEVICE(AMD, 0x148b), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(AMD, 0x14c0), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(AMD, 0x14c3), (kernel_ulong_t)&dev_data[1] },
+	{ PCI_VDEVICE(AMD, 0x155a), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(HYGON, 0x145b), (kernel_ulong_t)&dev_data[0] },
 	{ 0, }
 };
-- 
2.39.5



