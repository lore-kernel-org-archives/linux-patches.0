Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A3F2D595D;
	Tue, 31 Mar 2026 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976451; cv=none; b=qboEZoea3TZx1i4HdSnlMotQiLu3Wnt3ghMj4YZn5KUCjPgRZX3whD9uohSbyeCt9o9uFiVMv1wv/OM8mln9ujOEZTw1yssyIQ0yhR/WGzXumLtsmO62ymNjvws934RnC4pVqKYqgsgZ3RFUnKkY8PKlYTvQCdqC+VH1cSV0bPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976451; c=relaxed/simple;
	bh=7QqOCLOvMTH+Dm24T88tVL6c+5iW3XkBj3xoRuas+YA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VrmYB/K4GtNlw+1Kb71GqwmsM1zMPh/4w3vb15WZy3Fb3ZDLB8LR73gk83sI3/jIqS0bxT5KnDq1ugrWPq7PimWuvOK2chtMcsg/oXRDuqpsM1GUgajYqywjUHeILAMZpEEMTsRASxL2jrSUnLH7IaU2R1Ekj8MUabNt+a2BSBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQjxq7Hj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQjxq7Hj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66A8C19423;
	Tue, 31 Mar 2026 17:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976451;
	bh=7QqOCLOvMTH+Dm24T88tVL6c+5iW3XkBj3xoRuas+YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQjxq7HjWt1+5AslFW74B5fdOvf3+IZnklq2iEikGdiBdmt9ql1gnH+vtBH2bujNY
	 IIZIIXmCuOTyb9bcyy5tKVJaV41e4n0AuiiSS328xFSPJfi44zecMM5Rek17YaeBRh
	 7tPKkSJCscaXHEkMbQFVTarmVCbR+FahMLS9xcpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/309] spi: intel-pci: Add support for Nova Lake mobile SPI flash
Date: Tue, 31 Mar 2026 18:19:28 +0200
Message-ID: <20260331161755.880808687@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>

[ Upstream commit 85b731ad4bbf6eb3fedf267ab00be3596f148432 ]

Add Intel Nova Lake PCD-H SPI serial flash PCI ID to the list of
supported devices.

Signed-off-by: Alan Borzeszkowski <alan.borzeszkowski@linux.intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Link: https://patch.msgid.link/20260309153703.74282-1-alan.borzeszkowski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-intel-pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-intel-pci.c b/drivers/spi/spi-intel-pci.c
index bce3d149bea18..d8ef8f89330ac 100644
--- a/drivers/spi/spi-intel-pci.c
+++ b/drivers/spi/spi-intel-pci.c
@@ -96,6 +96,7 @@ static const struct pci_device_id intel_spi_pci_ids[] = {
 	{ PCI_VDEVICE(INTEL, 0xa324), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa3a4), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xa823), (unsigned long)&cnl_info },
+	{ PCI_VDEVICE(INTEL, 0xd323), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xe323), (unsigned long)&cnl_info },
 	{ PCI_VDEVICE(INTEL, 0xe423), (unsigned long)&cnl_info },
 	{ },
-- 
2.51.0



