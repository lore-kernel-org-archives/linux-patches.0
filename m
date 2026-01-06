Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A06C33F388;
	Tue,  6 Jan 2026 17:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721040; cv=none; b=JYPPeWhy0k27uzj6YB5yrEL/3gUeEqcWw+uzoALDiE47//cUshwzDwKyAaxTYHwpH5K7rZoxcnHfg3Ha4XQogtmHgIM4wExM+D9pYpaMhCeKPx1PzoNPopzLpOg1XQ/DSjMT7zN+N3h6dF943c0Vy2Tm6znhPWs7TK5tZ3xK43g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721040; c=relaxed/simple;
	bh=jrjrtMwfyX42AEhGGueopFEvIHIv1JiEgMHLEprtQ3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/SS+1dRcqrVDR6rLajhXeXC3UdbPZFgC0A9nRexJLbjudRpjt5Xr3Ag3IeCInCRT1RXcAKpNi7+PmGCCRv4wzbBIj4Nor0bEJndBHGZwNLH6Nz+jrUHVQfV97u3zuZWyuB8WBmV/v/9q+TguDM2Y/UZud7fnijDtk5FPvH5IAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHEcikgu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHEcikgu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A12BC116C6;
	Tue,  6 Jan 2026 17:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721039;
	bh=jrjrtMwfyX42AEhGGueopFEvIHIv1JiEgMHLEprtQ3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHEcikgui7GM8lNfNEUvt6Rn8JGs9cdyIXoKZKq9QfCnhLFA6dBn7lLxC+adDQQof
	 i7EIRWPqGAX0ITtgfG1tkkP96M6EBRX7xmBKWM2V86jsyrup8drMp2vBYsP/rpIntS
	 Alnrx7wKFw5aMaSv+1wj0XzO/xyPy1LI3g3sYFVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 416/567] LoongArch: Add new PCI ID for pci_fixup_vgadev()
Date: Tue,  6 Jan 2026 18:03:18 +0100
Message-ID: <20260106170506.731923469@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


