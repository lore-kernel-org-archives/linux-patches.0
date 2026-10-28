Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214615;
	b=BPPDYDZazVhnm+8eNGZZQAXgYosGwXMSEyua17zgOJ10+JozHEeC9VMdc66CY8ETl/7m
	 y7U7Mqr3d1ZvBJQiHrBIwSgCwGYLMphcC3ioAaHfLhGmGKY+ZtH9yzIqNoes/Mn2wu1lM
	 bt8Vd0ZBEerDH+pfZomCQ2cwy4KhwiZ6GTEkG7rSB6DyH5NLBJpWbhKwqhLj65IK3VvKA
	 hTJlnCPaExdYFPyIV69bSQEF9cW6vx9ZUqDXg4oF6jDHdyqN5eeS8lVQyVAUi1B1Rh0Qg
	 +OIhDoc9BXOTlMnUDxqjCHJm0qnUQ1Dd8bPlV+YUUg6NFsyeuT85twCSnuVsHSgClCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P4a9S6e/8M8J8N1ZgwN0kUsZ5A+W+JAr1bal2dffC2Y=;
	b=QftgZmEktq2dvZsJT6vl2h+MuthKmprFhgWcDMDTwZJ2Owl2cqCTIiMW+6FQ588d+ggt
	 cLSK+qZRBdpO6TJZ/0qnKK45PtqOW+WFbppsSb4CkEecadrLTHgjduAaKLvWimnwvJWMX
	 KsXWlfP/ciNF4PkIwfsByW/aoWXdqlLQX9KQh7Q5PX1crwiU8Gpg8larXohfle0CNeGPr
	 NahFPjlmRqJuSpApfX78cDVYwomGoO8DSRMt9OC16SKWAFDm1YwbtuwrolT6ofSrLMegL
	 QJaOP/70pMT0BHismw+2iXnWIyf2J0cnHwZc0D4szDbOIazLGekMwJ1qf54ed0ulL6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dc9GFP09;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 951DB606AB29;
	Wed, 28 Oct 2026 19:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dc9GFP09
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C9F1F01825;
	Wed, 28 Oct 2026 19:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214615;
	bh=P4a9S6e/8M8J8N1ZgwN0kUsZ5A+W+JAr1bal2dffC2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dc9GFP09iT3fLGiWrWyZDJSLu/0whf7k3BbBIj8yqtgYqsfs69Mza+cuxtq7vR/WW
	 8gayFlKNLvgYyWQ/OQuMqACCGsVnKuJUGuUgrJPcFRIMmy3k0MUUL0eC+rzjy/rD6c
	 5CLX6ynOibUlTt35TZgwSblA7G+JpM+CWTXYS74I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0921/1887] PCI: endpoint: Add missing NULL check for alloc_workqueue()
Date: Wed, 28 Oct 2026 17:50:17 +0100
Message-ID: <20261028170520.374473975@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 03f336a869b3a3f119d3ae52ac9723739c7fb7b6 ]

alloc_workqueue() can return NULL on memory allocation failure. Without
proper error checking, this may lead to a NULL pointer dereference when
queue_work() is later called with the NULL workqueue pointer in
epf_ntb_epc_init().

Add a NULL check immediately after alloc_workqueue() and return -ENOMEM on
failure to prevent the driver from loading with an invalid workqueue
pointer.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Fixes: 8b821cf76150 ("PCI: endpoint: Add EP function driver to provide NTB functionality")
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251110040446.2065-1-vulab@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-ntb.c  | 5 +++++
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 5 +++++
 2 files changed, 10 insertions(+)

diff --git a/drivers/pci/endpoint/functions/pci-epf-ntb.c b/drivers/pci/endpoint/functions/pci-epf-ntb.c
index e17dbcc9c8dbb..6abe474fd9405 100644
--- a/drivers/pci/endpoint/functions/pci-epf-ntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-ntb.c
@@ -2073,6 +2073,11 @@ static int __init epf_ntb_init(void)
 
 	kpcintb_workqueue = alloc_workqueue("kpcintb", WQ_MEM_RECLAIM |
 					    WQ_HIGHPRI, 0);
+	if (!kpcintb_workqueue) {
+		pr_err("Failed to allocate kpcintb workqueue\n");
+		return -ENOMEM;
+	}
+
 	ret = pci_epf_register_driver(&epf_ntb_driver);
 	if (ret) {
 		destroy_workqueue(kpcintb_workqueue);
diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 88ff306599091..15c707840cc20 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -1433,6 +1433,11 @@ static int __init epf_ntb_init(void)
 
 	kpcintb_workqueue = alloc_workqueue("kpcintb", WQ_MEM_RECLAIM |
 					    WQ_HIGHPRI, 0);
+	if (!kpcintb_workqueue) {
+		pr_err("Failed to allocate kpcintb workqueue\n");
+		return -ENOMEM;
+	}
+
 	ret = pci_epf_register_driver(&epf_ntb_driver);
 	if (ret) {
 		destroy_workqueue(kpcintb_workqueue);
-- 
2.53.0



