Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CA5749D
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:13:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63F4C433EF;
	Thu, 12 Jan 2023 14:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532816;
	bh=+rRUzIhOfQwvFzP52YVytULo+9hnjReQI8X1hS4XcXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nAyU9PiMcVREAiKq4U0dS+9Wl8DRRfu7ztM9DD6mSpYXdQBkL+D52YpnxjKeMRfYc
	 xs5WdU2i82PLdD1R4IS+XPB7Wa/Yvje5ont77r00LtPpy7ivxxQJBUoMFQKR9zjcuF
	 ZD7tpseLCqb+rzPFaqgliYSCyKGL+yruw+9X+N68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Om Prakash Singh <omp@nvidia.com>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 286/783] PCI: pci-epf-test: Register notifier if only core_init_notifier is enabled
Date: Thu, 12 Jan 2023 14:50:02 +0100
Message-Id: <20230112135537.644758442@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

[ Upstream commit 6acd25cc98ce0c9ee4fefdaf44fc8bca534b26e5 ]

The pci_epf_test_notifier function should be installed also if only
core_init_notifier is enabled. Fix the current logic.

Link: https://lore.kernel.org/r/20220825090101.20474-1-hayashi.kunihiko@socionext.com
Fixes: 5e50ee27d4a5 ("PCI: pci-epf-test: Add support to defer core initialization")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Acked-by: Om Prakash Singh <omp@nvidia.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index ddfeca9016a0..ef52f5097eb3 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -870,7 +870,7 @@ static int pci_epf_test_bind(struct pci_epf *epf)
 	if (ret)
 		epf_test->dma_supported = false;
 
-	if (linkup_notifier) {
+	if (linkup_notifier || core_init_notifier) {
 		epf->nb.notifier_call = pci_epf_test_notifier;
 		pci_epc_register_notifier(epc, &epf->nb);
 	} else {
-- 
2.35.1



