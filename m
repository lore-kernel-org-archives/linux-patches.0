Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0559246B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EF6CC433D2;
	Mon, 16 Jan 2023 16:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886580;
	bh=A8yQ3XmGtzjz8oyVf9rA0gcFW6xnPnPcPQ+UK5ew3f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SwwQqxclXsdUMj7rsHNbc0cpYrIM3QIJSbJeZJtNqbaFanGsWa6XgzYGxpSNDoEMM
	 VkQaOAmVjLqO1yXxm4sza+83CEelCfQSDDZCQPDFnMa6OpddSXyVNgLjCOIYZ1q4q9
	 69J9nh4iIWFScrCqGMnpDNBJuVVk9iy2m1afFTMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 455/658] nvme-pci: add a blank line after declarations
Date: Mon, 16 Jan 2023 16:49:03 +0100
Message-Id: <20230116154930.305391332@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Baolin Wang <baolin.wang@linux.alibaba.com>

[ Upstream commit 4e523547e2bf755d40cb10e85795c2f9620ff3fb ]

Add a blank line after declarations to make code more readable.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: c89a529e823d ("nvme-pci: fix mempool alloc size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 5d62d1042c0e..c31fb6902c71 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1076,6 +1076,7 @@ static irqreturn_t nvme_irq(int irq, void *data)
 static irqreturn_t nvme_irq_check(int irq, void *data)
 {
 	struct nvme_queue *nvmeq = data;
+
 	if (nvme_cqe_pending(nvmeq))
 		return IRQ_WAKE_THREAD;
 	return IRQ_NONE;
@@ -1470,6 +1471,7 @@ static int nvme_cmb_qdepth(struct nvme_dev *dev, int nr_io_queues,
 
 	if (q_size_aligned * nr_io_queues > dev->cmb_size) {
 		u64 mem_per_q = div_u64(dev->cmb_size, nr_io_queues);
+
 		mem_per_q = round_down(mem_per_q, dev->ctrl.page_size);
 		q_depth = div_u64(mem_per_q, entry_size);
 
@@ -2940,6 +2942,7 @@ static void nvme_reset_done(struct pci_dev *pdev)
 static void nvme_shutdown(struct pci_dev *pdev)
 {
 	struct nvme_dev *dev = pci_get_drvdata(pdev);
+
 	nvme_disable_prepare_reset(dev, true);
 }
 
@@ -3070,6 +3073,7 @@ static int nvme_suspend(struct device *dev)
 static int nvme_simple_suspend(struct device *dev)
 {
 	struct nvme_dev *ndev = pci_get_drvdata(to_pci_dev(dev));
+
 	return nvme_disable_prepare_reset(ndev, true);
 }
 
-- 
2.35.1



