Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 467B01ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:21:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB282C433C8;
	Tue, 25 Jul 2023 11:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284063;
	bh=suNOOXsmGHUwJAAD4tj6Qu2EcMID2zI+NyqW+2MO8aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OerX9POrutfbySQchggEtfJgRnjWsJB58vmrjRUEnxvPtfattvdFBB/wsw46smh2e
	 AdPkF2LjRZ8PHZ7HBHV9RFHEuD7rPEEUJ73qVAj8tSlokqlaguDehW6kap9V7Eg9w4
	 HU/1f+3zgEgcbbPYc8K4H2UrWrvsNNh6an63yI9Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <suijingfeng@loongson.cn>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 182/509] PCI: Add pci_clear_master() stub for non-CONFIG_PCI
Date: Tue, 25 Jul 2023 12:42:01 +0200
Message-ID: <20230725104602.032157872@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
index 4cc42ad2f6c52..550e1cdb473fa 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1719,6 +1719,7 @@ static inline struct pci_dev *pci_get_class(unsigned int class,
 #define pci_dev_put(dev)	do { } while (0)
 
 static inline void pci_set_master(struct pci_dev *dev) { }
+static inline void pci_clear_master(struct pci_dev *dev) { }
 static inline int pci_enable_device(struct pci_dev *dev) { return -EIO; }
 static inline void pci_disable_device(struct pci_dev *dev) { }
 static inline int pcim_enable_device(struct pci_dev *pdev) { return -EIO; }
-- 
2.39.2



