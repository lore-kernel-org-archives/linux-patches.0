Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3643126ED41;
	Fri,  9 Jan 2026 12:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960994; cv=none; b=lHLQpe1I6FoSUaXJ/P5Gze+oDDfDT89ml/SO5zKQ1SpCreoLeSp6fjwWa4IJxVaoApeKKqZtGd42AWq9dJWb9tOW9O7d3c4MF+W8ybFdeVVoVXfBf+P1YErez8uoOLf3bTJAVFrCAlaIZuFjvx4k73DaiEByypbYHz4QbhTdp3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960994; c=relaxed/simple;
	bh=q9Z/+yPeREzm6UIPM1lKXQmQFO2iBAeHVl3xh+OEM+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kcE8Fv4FI77IF735bRHSP6aNnQxDZfbSJqOaUIb4Tw4kv9esN3g+tdN3me0+T1JLgzzy3kVxWlLQr1EBja1qInHwx2vg9sNkXPGkZ3DoNLDlXM4x0zKergX4hKw0/Af8W+c0zHaBP/Mj4AOfer+SMhrtZeykoNnxszJkAc5XeXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hl0od965; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hl0od965"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5273CC4CEF1;
	Fri,  9 Jan 2026 12:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960993;
	bh=q9Z/+yPeREzm6UIPM1lKXQmQFO2iBAeHVl3xh+OEM+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hl0od965HVDkEi2a2oDdvP3J6LGphbYRERPbVtU6MLGhElStoqWZsb6z05cFEZovT
	 W+TcEUgwi0cGnAph9TKoTq83iklJZxJELlMxV7T63qedLvcemuFEpTy7/EPX16u5c7
	 RQuh6lI2EzOCp/aMAwEM8qd4pbS5CB70YdvZDWbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianrui Zhao <zhaotianrui@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 596/737] LoongArch: Add new PCI ID for pci_fixup_vgadev()
Date: Fri,  9 Jan 2026 12:42:15 +0100
Message-ID: <20260109112156.429497041@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


