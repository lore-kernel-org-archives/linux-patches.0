Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C144ABA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:19:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A25BC433D2;
	Tue,  7 Mar 2023 18:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213189;
	bh=rajiz7FNfK9cFYVZfDIAgxyJNOtyTpGMIIDCwH1zEWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mll3j2535H4TaHC27hM5uolnXAiD3XNmHEDtr6dWgTbkUYaGGehtrruahU7hukQ1y
	 eA0+PDBh9IktCVC4X/rwI0KNnYku9jF/SbHyVSueVZSiPlRl5OCmztPzmCgrnE7yXA
	 PDFuEk9swCnt01fHAF5d9ls/a+DUMEtqVl1dM+zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 427/885] PCI: endpoint: pci-epf-vntb: Add epf_ntb_mw_bar_clear() num_mws kernel-doc
Date: Tue,  7 Mar 2023 17:56:01 +0100
Message-Id: <20230307170020.962819087@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit fd858402c6d0a80e0b543886b9f7865c6d76d5d6 ]

8e4bfbe644a6 ("PCI: endpoint: pci-epf-vntb: fix error handle in
epf_ntb_mw_bar_init()") added a "num_mws" parameter to
epf_ntb_mw_bar_clear() but failed to add kernel-doc for num_mws.

Add kernel-doc for num_mws on epf_ntb_mw_bar_clear().

Fixes: 8e4bfbe644a6 ("PCI: endpoint: pci-epf-vntb: fix error handle in epf_ntb_mw_bar_init()")
Link: https://lore.kernel.org/r/20230103024907.293853-1-yangyingliang@huawei.com
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 36a83f0c28810..8c6931210ac4d 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -655,6 +655,7 @@ static int epf_ntb_mw_bar_init(struct epf_ntb *ntb)
 /**
  * epf_ntb_mw_bar_clear() - Clear Memory window BARs
  * @ntb: NTB device that facilitates communication between HOST and VHOST
+ * @num_mws: the number of Memory window BARs that to be cleared
  */
 static void epf_ntb_mw_bar_clear(struct epf_ntb *ntb, int num_mws)
 {
-- 
2.39.2



