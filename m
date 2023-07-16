Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BB348F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEC93C433C7;
	Sun, 16 Jul 2023 20:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538437;
	bh=c4HTzXza9W8Vq2rTaM1DaC7jvjQkFvKAZOKficqe/eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAnpks+3vuPDcHjMCgvuKrzSG7e2zACl5u+dLsW4CKph1KV8bSMri5/Sxs9UzwFN/
	 0b+0zcXLthG2RINnofe5DLotKWKuxx4yVWe+oiFq99CkZyO1Cj56YHm90TDxooCvW/
	 sVqBvGSlaC7kdViPvJ57V476RTCXq1YBv8qdjghU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <suijingfeng@loongson.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 450/800] PCI: Add pci_clear_master() stub for non-CONFIG_PCI
Date: Sun, 16 Jul 2023 21:45:03 +0200
Message-ID: <20230716194959.535684865@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sui Jingfeng <suijingfeng@loongson.cn>

[ Upstream commit 2aa5ac633259843f656eb6ecff4cf01e8e810c5e ]

Add a pci_clear_master() stub when CONFIG_PCI is not set so drivers that
support both PCI and platform devices don't need #ifdefs or extra Kconfig
symbols for the PCI parts.

[bhelgaas: commit log]
Fixes: 6a479079c072 ("PCI: Add pci_clear_master() as opposite of pci_set_master()")
Link: https://lore.kernel.org/r/20230531102744.2354313-1-suijingfeng@loongson.cn
Signed-off-by: Sui Jingfeng <suijingfeng@loongson.cn>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 60b8772b5bd45..c69a2cc1f4123 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1903,6 +1903,7 @@ static inline int pci_dev_present(const struct pci_device_id *ids)
 #define pci_dev_put(dev)	do { } while (0)
 
 static inline void pci_set_master(struct pci_dev *dev) { }
+static inline void pci_clear_master(struct pci_dev *dev) { }
 static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
 static inline void pci_disable_device(struct pci_dev *dev) { }
 static inline int pcim_enable_device(struct pci_dev *pdev) { return -EIO; }
-- 
2.39.2



