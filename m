Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3525135C1AE;
	Fri,  9 Jan 2026 12:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962872; cv=none; b=tKnvgWpNHYzkUpHuWCRdUYeMG/8WhWw5btyfSPt33/bwLA5IUaKPguyJ8D0TuV/pzJ/+Pw9IEltGtVfi47AKV0cGwiGoeTWmPQd2BkN8TMvHdfvbqHOvrClmDBqhdgHo1R1dUed/hHR6YTqpSYjMpm1coG7ha73bXqR1oVJ2haA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962872; c=relaxed/simple;
	bh=egZuM2v6wiEpdMBciC3CMAEzSR8dv8RFXSwBsj9dTaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPFSvJOC3i+UQ3R1qcMsUqbwe3D9SJq/F5XmkpzEHzoFpUrKgHahgwPJftJcutdtp/7aVOQ2MmtC8vlqzG1K9BiJhQZYbuXCAUi2K4oP5ayYLyGgSPrpCsbzsEnp4ykhZrbK3RROiHyRQFQM8lsPq9ywcsVVAkRkFYio8iCgXmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xFh7tjeD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xFh7tjeD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55A8C4CEF1;
	Fri,  9 Jan 2026 12:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962872;
	bh=egZuM2v6wiEpdMBciC3CMAEzSR8dv8RFXSwBsj9dTaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xFh7tjeDuZ0479xbZhP+T1jn4D2XuxjXSSRbRRcrcTwhCa59VlSbYWrP5xJkeahMq
	 RgyPuU4ejdlQYmAKl9238RQlxtja6XwofV7N4G20U978lnAGohJVfkIJYNNHroadGn
	 Yh9i/pJ+gvHCtbx+Pu9KKqhft+Tu2/IXHgWJ1WJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 490/634] LoongArch: Add new PCI ID for pci_fixup_vgadev()
Date: Fri,  9 Jan 2026 12:42:48 +0100
Message-ID: <20260109112135.983157152@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -15,6 +15,7 @@
 #define PCI_DEVICE_ID_LOONGSON_HOST     0x7a00
 #define PCI_DEVICE_ID_LOONGSON_DC1      0x7a06
 #define PCI_DEVICE_ID_LOONGSON_DC2      0x7a36
+#define PCI_DEVICE_ID_LOONGSON_DC3      0x7a46
 
 int raw_pci_read(unsigned int domain, unsigned int bus, unsigned int devfn,
 						int reg, int len, u32 *val)
@@ -98,3 +99,4 @@ static void pci_fixup_vgadev(struct pci_
 }
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC1, pci_fixup_vgadev);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC2, pci_fixup_vgadev);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_LOONGSON, PCI_DEVICE_ID_LOONGSON_DC3, pci_fixup_vgadev);


