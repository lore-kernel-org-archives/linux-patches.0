Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5040A1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:16:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA72FC433F0;
	Wed, 28 Dec 2022 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240569;
	bh=UJhwYti2ReR2+D0E9d97pY7m97WR85RhOj5MVYvjwHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yIsGcfsqQevnuOZbW8nWc7f6REuDDJ0ue26aq4YqXDTkkDuhMFtSXpuJYo1hprUPX
	 7AKPoQOiXK84kN8haCeHsAQ9V30TlJIKGcWT2UeXSHBR/UHHRMc6hJUaMH6Tx6lhDF
	 3W6OrRbws535a/OwHAMa0PaOROIr7XXsvIMryxHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Om Prakash Singh <omp@nvidia.com>,
	Kishon Vijay Abraham I <kishon@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 368/731] PCI: pci-epf-test: Register notifier if only core_init_notifier is enabled
Date: Wed, 28 Dec 2022 15:37:55 +0100
Message-Id: <20221228144307.229677594@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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
index a5ed779b0a51..45535d4ae644 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -883,7 +883,7 @@ static int pci_epf_test_bind(struct pci_epf *epf)
 	if (ret)
 		epf_test->dma_supported = false;
 
-	if (linkup_notifier) {
+	if (linkup_notifier || core_init_notifier) {
 		epf->nb.notifier_call = pci_epf_test_notifier;
 		pci_epc_register_notifier(epc, &epf->nb);
 	} else {
-- 
2.35.1



