Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1C046C4D9;
	Tue, 21 Jul 2026 15:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649475; cv=none; b=uoPeeqRh0W/O91e/ZzOGidszfIpWqZ2mqn98YCYq41n/Uq0DOjQhGfAlwlC3ysUF86FSWwMXtlVqoup5sDieFXbEPCb6kTV++4fmRHgVtK9QxPjVXmxZQ4O168SCnLGgqwlQ1ZRsv4A1z7mu5TRmt3ij5BTE9iiy4nwdbdHaXvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649475; c=relaxed/simple;
	bh=SoSu1GtNrIYo01JukYK3EoUsciCIy51d8kRI6OlWbAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhCu1dGxEzEjGzA/JPRP7ezFqo+FfFZc6f9UdkOACVj2mrux2VjkT8RCII/pdfhBTrRcwpxjixZgriGcvcA17JNq5eAxiYcsBwS5C8igdcwy4Am8AdiMMjkLrr/q09PJhYpzy1auUCc8n3XkpAE54xnAtQQDuJ1/lACXC+7K4f0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1x999YvQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1x999YvQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2FB1F00A3A;
	Tue, 21 Jul 2026 15:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649474;
	bh=GOxZCirMtc4pldLajvCOsXbIJ3aJRff1SctU4dBmMD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1x999YvQJHG2Gvobfxk/bkEjsaV19I9Hc74mYFIjKxS6sVbG220sRTKoBMAVwFMfp
	 yGYQbja33tTiYGJSUGiJ34WT4AYJ8C2vJy6eJH7E/OgPoDJu4XQ9Dm6F+ry1IPUUF+
	 bEghPfUCgupicKNwEvTnbgdSCHVIy1OLNcap0dLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0590/2077] wifi: mt76: mt7996: remove redundant pdev->bus check in probe
Date: Tue, 21 Jul 2026 17:04:23 +0200
Message-ID: <20260721152606.727523422@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 6b294950eaac246e6b0f42d74aa643ff36384c6e ]

Drop the unnecessary pdev->bus NULL check in mt7996_pci_probe() since
the pointer is already dereferenced earlier in mt76_pci_disable_aspm(),
making the check dead code. Silences the related Smatch warning.

Fixes: 377aa17d2aed ("wifi: mt76: mt7996: Add NPU offload support to MT7996 driver")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260522-mt7996-pdev-bus-fix-v1-1-c91716484365@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index 12523ddba63041..b7d9193e042f48 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -141,7 +141,7 @@ static int mt7996_pci_probe(struct pci_dev *pdev,
 	dev->hif2 = hif2;
 
 	mt76_npu_init(mdev, pci_resource_start(pdev, 0),
-		      pdev->bus && pci_domain_nr(pdev->bus) ? 3 : 2);
+		      pci_domain_nr(pdev->bus) ? 3 : 2);
 
 	ret = mt7996_mmio_wed_init(dev, pdev, false, &irq);
 	if (ret < 0)
-- 
2.53.0



