Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84A5BA34
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:32:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E22BC433A0;
	Tue,  7 Mar 2023 17:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210335;
	bh=mb4AeHoFLLQS4YkGg11vMfIuPd2LpC4chtZ6WgFau/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUAlPzlNujBkwkfro+kIHCAJe7KJKmbwndj/NBfiF4KrD72R2l/YpomDPnL0mqsxs
	 mK0XIrkyuZc2MUe2BZQT81i0oUaTXfDC5wycE7bo0xewnEcdRekHLmWsRH09i3hWq3
	 5dhVWn5qFojb7sUk9dmCQQQqvZ8YemKagInHNXQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0508/1001] PCI: endpoint: pci-epf-vntb: Add epf_ntb_mw_bar_clear() num_mws kernel-doc
Date: Tue,  7 Mar 2023 17:54:40 +0100
Message-Id: <20230307170043.462116122@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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
index 04698e7995a54..b7c7a8af99f4f 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -652,6 +652,7 @@ static int epf_ntb_mw_bar_init(struct epf_ntb *ntb)
 /**
  * epf_ntb_mw_bar_clear() - Clear Memory window BARs
  * @ntb: NTB device that facilitates communication between HOST and VHOST
+ * @num_mws: the number of Memory window BARs that to be cleared
  */
 static void epf_ntb_mw_bar_clear(struct epf_ntb *ntb, int num_mws)
 {
-- 
2.39.2



