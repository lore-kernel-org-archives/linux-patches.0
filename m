Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4975C27FD75;
	Tue,  6 Jan 2026 17:56:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722198; cv=none; b=pMRS1au/Z8TLCtHwe9dx6B7LsUq7RQ3nysmww82oEmbJcF8QhVv4eO0z0j+SkUI4GZ1xPfARoYwHoo3Xc5K/sU4zudCBUafQplbSoC6SVn5bKZQsvcl5qS9lm91UZkGg3pP717QSBvPCTD8SIrMcTaBq709TM9QooTDfO5LS/uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722198; c=relaxed/simple;
	bh=LtT0WtP57uAogqhLYsvM5dogc1Q/0modqaasJNPNp/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cDQbwSjBvERfh+djs2a2dhDYskiYie7vphgBLftFQqqURA0gN6ga775KQI5YSDo5S9Ko9QVwz8UWEN1fV2gFGAshwBEaZELHjgHyJONvqxkcVcpvlD00TKTp8sqF5DzasY1hLLfh+/ayJ/1xJcr8poq7jNd2thWqYFXuH0Xknuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRApZBGJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRApZBGJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8AECC116C6;
	Tue,  6 Jan 2026 17:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722198;
	bh=LtT0WtP57uAogqhLYsvM5dogc1Q/0modqaasJNPNp/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRApZBGJFNUR1NcdI7uRhit2RHgqp0wphfkCe4qPyJI5rZjdtUzGigSLFNV1gCplA
	 ybtV7Jzor40G1NQyQzKbBxMx+zZyzTSF76dfxmaFCcD3YTqQlpWetywSrpznBzE2Wd
	 MgSoKb9zimEY4uvrSMOxjS3rMH+FeqW6hTwIb8ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.18 192/312] LoongArch: Add new PCI ID for pci_fixup_vgadev()
Date: Tue,  6 Jan 2026 18:04:26 +0100
Message-ID: <20260106170554.773471101@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit bf3fa8f232a1eec8d7b88dcd9e925e60f04f018d upstream.

Loongson-2K3000 has a new PCI ID (0x7a46) for its display controller,
Add it for pci_fixup_vgadev() since we prefer a discrete graphics card
as default boot device if present.

Cc: stable@vger.kernel.org
Signed-off-by: Tianrui Zhao <zhaotianrui@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/pci/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/loongarch/pci/pci.c
+++ b/arch/loongarch/pci/pci.c
@@ -14,6 +14,7 @@
 #define PCI_DEVICE_ID_LOONGSON_HOST     0x7a00
 #define PCI_DEVICE_ID_LOONGSON_DC1      0x7a06
 #define PCI_DEVICE_ID_LOONGSON_DC2      0x7a36
+#define PCI_DEVICE_ID_LOONGSON_DC3      0x7a46
 
 int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val)
@@ -97,3 +98,4 @@ static void pci_fixup_vgadev(struct pci_
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC1, pci_fixup_vgadev);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC2, pci_fixup_vgadev);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC3, pci_fixup_vgadev);


