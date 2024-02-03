Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB251BDED;
	Sat,  3 Feb 2024 04:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933795; cv=none; b=G4wHdLVmE0LXfXSLiNvFcqqHAzCi3WdbE3Ri/w27df+ca7ynFa2d701a/lgZF7g92K6HLjjMynd/rfT+xAxNL3ACPCJCb+eqWhFDCytt4ZfWpCtW4qM52DtjlFdX1coG4XUyWeLIlrWHBKKxMys1g7pAztVRRfri5QHOoR+tN8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933795; c=relaxed/simple;
	bh=7mlvTdKzHxrujO3QNCpzfzva4vz/8GOCooAx8AQXlZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLtknsHFcqEIQRAE3Wr6itB8KgRZEisra89zNGlOBmkjCQ1X5FvNdV8gVh4cR0/e5lXPj32lmwhl0ZTllyS9hW8gLBTwcrRClLdg61CmCtP+1Vc+8ZFFkqWqe3j6c37ik2/VIhAO1mTdGd1trGQ+H5Ud84FnknunE04ZBnNTh4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H26uEpdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H26uEpdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D6BC43390;
	Sat,  3 Feb 2024 04:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933795;
	bh=7mlvTdKzHxrujO3QNCpzfzva4vz/8GOCooAx8AQXlZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H26uEpdqmpJoYNK1tfuy52YOjMBNnSCJoGr9Jo3/JLH/4XulH06FH36qfyv+QJXjd
	 xxtB4o/DDfDuvVJ7vufSX5nYj8y/MwJXNLCcYDR6v0FxGqmv30UqfuqUFJTWGk886h
	 zitc6+ra1pA/JuYPUWYvoQ+Jn3shvBBsg7+RKlrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	StanleyYP Wang <StanleyYP.Wang@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 105/353] wifi: mt76: mt7996: add PCI IDs for mt7992
Date: Fri,  2 Feb 2024 20:03:43 -0800
Message-ID: <20240203035407.092867766@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: StanleyYP Wang <StanleyYP.Wang@mediatek.com>

[ Upstream commit 3d3f117a259a65353bf2714a18e25731b3ca5770 ]

Add PCI device IDs to enable mt7992 chipsets support.

Signed-off-by: StanleyYP Wang <StanleyYP.Wang@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index c5301050ff8b..67c015896243 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -17,11 +17,13 @@ static u32 hif_idx;
 
 static const struct pci_device_id mt7996_pci_device_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x7990) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x7992) },
 	{ },
 };
 
 static const struct pci_device_id mt7996_hif_device_table[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x7991) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_MEDIATEK, 0x799a) },
 	{ },
 };
 
@@ -60,7 +62,9 @@ static void mt7996_put_hif2(struct mt7996_hif *hif)
 static struct mt7996_hif *mt7996_pci_init_hif2(struct pci_dev *pdev)
 {
 	hif_idx++;
-	if (!pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x7991, NULL))
+
+	if (!pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x7991, NULL) &&
+	    !pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x799a, NULL))
 		return NULL;
 
 	writel(hif_idx | MT_PCIE_RECOG_ID_SEM,
@@ -113,7 +117,7 @@ static int mt7996_pci_probe(struct pci_dev *pdev,
 
 	mt76_pci_disable_aspm(pdev);
 
-	if (id->device == 0x7991)
+	if (id->device == 0x7991 || id->device == 0x799a)
 		return mt7996_pci_hif2_probe(pdev);
 
 	dev = mt7996_mmio_probe(&pdev->dev, pcim_iomap_table(pdev)[0],
-- 
2.43.0



