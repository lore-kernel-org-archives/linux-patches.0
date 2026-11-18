Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038883;
	b=z+lFeTlW0CXfL9sMEYWwRxvbO58LP+91cdH0Y5WaBa5/bOjo5CTkk0GyyN271JOq5HvR
	 BqkVRNyAisfXrBHxka+RldaD/qn2d3vbjf9pMfXFjRfvVNFeaBkigfno7vTQzsZTaQnSR
	 8vJoIE6rvPNUh8jZ75ub/37ELXfBLQl+20c7qyCVWG/nmkBMS8a/rVdURHYxsaaiLKQqa
	 bkCK1//3lUPU7aT4gZWfaXf/eluul7qhFxJr9h/ZlB83noZHpcmJfk1IAFP8ZPa/r36YH
	 9Wn6btjfPFaniOCHTDGC6FmD2rZ83eIhLjIwqZppmusJIgdWOoPr9SWPm3Yod08/dWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038883;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CRAfghSNVGmLwKKbqPD1lY6H/QdGWtzPpexs67uYt3Q=;
	b=cpXAmlhSqLH8GHm9KJT6CeoiwnMyN3rOPf4xiMeTRziAhrxxbaW5Utj86VNTGz/ZC5lG
	 1ReMJmbW5AWvIQvp38xx8h2Iq911/XBIYLAELZz5yEyo98CNgWYFt3yaT12DeRTYhO+C9
	 y+hZX2g9/jQCAWdFmU6kbDKv5lmBB/nn7dJISv9KLyQtEPb4kBq1ACbTYEAhbx8Ewls34
	 vKGgacZklMaLorvP9Y/4GQUqlR9/eaB24ihDd+R6eMLB6HXhOscYDPPte32TKryzKJDBk
	 sTwNWaL6OUANPFByOi85awXynDyuzMe0FPt9/UxYia6ClXyuy1/5WOpN1RFveqtzSvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SrPG+OdW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6161606A31C;
	Wed, 18 Nov 2026 21:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SrPG+OdW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F308D1F000C4;
	Wed, 18 Nov 2026 21:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038882;
	bh=CRAfghSNVGmLwKKbqPD1lY6H/QdGWtzPpexs67uYt3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SrPG+OdWc20bjvwGUA7NG6cagpd3FYWBluxUd6OiukCzXGKnZ2j/bJKeGYkVakgvU
	 IEfBCbqZA0NBirwmGcxfphPevKkb+bJyP50x72++uDQrVOrVH8N/ggjfqMx/zRCSxm
	 G8g1Yg5W7tLWgAvhK8r6bFYJ7aJeYymU5hq8ATnQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linlin Yang <yanglinlin@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1874/3318] wifi: mt76: mt7996: fix PCI device reference leak in mt7996_pci_init_hif2()
Date: Wed, 18 Nov 2026 15:41:36 +0100
Message-ID: <20261118150418.194171342@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linlin Yang <yanglinlin@kylinos.cn>

[ Upstream commit d92bac6b6af2602516ee82ae112709c71af27cf6 ]

pci_get_device() increments the reference count on the returned
struct pci_dev. In mt7996_pci_init_hif2(), three pci_get_device()
calls are made but their return values are only checked for NULL
and then discarded. pci_dev_put() is never called, causing a PCI
device reference count leak.

Fix this by storing the return value and calling pci_dev_put()
before returning, following the same pattern already used in the
sibling driver mt7915/pci.c.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Cc: stable@vger.kernel.org
Signed-off-by: Linlin Yang <yanglinlin@kylinos.cn>
Link: https://patch.msgid.link/20260824092937.683240-1-yanglinlin@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[ sashal: adapted PCI device lookups to use two numeric IDs instead of three named constants ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index 67c015896243f..ea832769336e3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -61,11 +61,16 @@ static void mt7996_put_hif2(struct mt7996_hif *hif)
 
 static struct mt7996_hif *mt7996_pci_init_hif2(struct pci_dev *pdev)
 {
+	struct pci_dev *tmp_pdev;
+
 	hif_idx++;
 
-	if (!pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x7991, NULL) &&
-	    !pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x799a, NULL))
+	tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x7991, NULL);
+	if (!tmp_pdev)
+		tmp_pdev = pci_get_device(PCI_VENDOR_ID_MEDIATEK, 0x799a, NULL);
+	if (!tmp_pdev)
 		return NULL;
+	pci_dev_put(tmp_pdev);
 
 	writel(hif_idx | MT_PCIE_RECOG_ID_SEM,
 	       pcim_iomap_table(pdev)[0] + MT_PCIE_RECOG_ID);
-- 
2.53.0



