Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030778;
	b=YTttbspK7VxlWEm0Y4LGxxwseQS8CzZzKGXoCXcEE05IUkKSH2qJ+rOun31nlsqevUR2
	 Bj7+Bt3ZA35/dIaW7H6cM2Z5WEvd5xpK73x8jeprpn/dDlzKXeYn2s99b4xhg5ehpn1hz
	 jstEoiSxdhZwZy14TxoptJ8vXuWthX631yEX1+VrCyP9kIXFF1tZdeCp3HoF80cP8ZbAi
	 Mp1SoHIYaBaeKEjNbOryJ8l0q9JFzz6Co9QtJRHnUDQRMeQMbPGGTCPOpQsAiU7PlOSxr
	 zToisU+dnx/9IDbKCx0z3gbQbhl5ds+ORyjtykaBvCDqzMRhembHkNXBv+ubahNpbnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030778;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KyCVHV63beFEDRoVQN4P0nUNIQz+0/ew44MASnHkCb8=;
	b=Bto3H1su4jekOBeuzvXMKEKqxPRZfWUIwdSY0e2xARuDxvoeIwWMmLHK3J+pB+YPXV5T
	 7N4hRRVFnjAfa01Rse2q58uMJRVubw7jFZY/va035/iaGwJxviWki5dpiCI3Xh/KCxrBy
	 Rva5WWfKNoct9Tgzk9BhgZTh7lTDomLQmDRN+26xg4aQCNpRkCI4HEwp9r85+DeWzGlms
	 8lgmFNwnsh0Sz0sswz6+lPIfp7fHLWtqCVpX/9bF39rrvlOv3w3WsGSjNs8mfOVzUxIYr
	 ouDql5dWpDeGHmGW5h0+W5UIHnV44mk43puln2iC4ntKfUuHbTyT7QFZZdT2MQmLhNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNkLIHSE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E5C5606A92E;
	Wed, 18 Nov 2026 19:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BNkLIHSE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831901F000C6;
	Wed, 18 Nov 2026 19:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030778;
	bh=KyCVHV63beFEDRoVQN4P0nUNIQz+0/ew44MASnHkCb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BNkLIHSEgT7NfRuqo3IOGgTBLNn+cf/YZs5qY0Db2eGGAURy+HyJztg1xn4DuVZDu
	 FXfLeuXcjIoyW+geZj5llxdTd4iqGxYvTDRSGq8hQUn4dwC7QOL1fMzuGpIbHqvAss
	 1fctlefWkvpQDyXBnTbkSBLLJL+Ff/OOb5sdHyuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <Markus.Elfring@web.de>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0824/1756] perf/dwc_pcie: Fix PCI device reference leak in probe
Date: Wed, 18 Nov 2026 15:49:11 +0100
Message-ID: <20261118150042.347722553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 3a4067658363e34bf4e1d7039e5b52951fcb4012 ]

pci_get_domain_bus_and_slot() returns a referenced PCI device. When the
subsequent RAS DES capability lookup fails, dwc_pcie_pmu_probe() returns
-ENODEV without releasing that reference. Repeated failed probes can
therefore keep the PCI device allocated after removal.

Declare the looked-up device with __free(pci_dev_put), so the temporary
reference is released on every return path. Keeping the reference scoped
to the whole probe also covers all later uses of the device during
initialization.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 7f35b429802a ("perf/dwc_pcie: fix duplicate pci_dev devices")
Suggested-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/dwc_pcie_pmu.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/perf/dwc_pcie_pmu.c b/drivers/perf/dwc_pcie_pmu.c
index bde0a0a06cff5..e334b09dddf00 100644
--- a/drivers/perf/dwc_pcie_pmu.c
+++ b/drivers/perf/dwc_pcie_pmu.c
@@ -613,16 +613,16 @@ static struct notifier_block dwc_pcie_pmu_nb = {
 
 static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 {
-	struct pci_dev *pdev;
+	u32 sbdf = plat_dev->id;
+	struct pci_dev *pdev __free(pci_dev_put) =
+		pci_get_domain_bus_and_slot(sbdf >> 16,
+					    PCI_BUS_NUM(sbdf & 0xffff),
+					    sbdf & 0xff);
 	struct dwc_pcie_pmu *pcie_pmu;
 	char *name;
-	u32 sbdf;
 	u16 vsec;
 	int ret;
 
-	sbdf = plat_dev->id;
-	pdev = pci_get_domain_bus_and_slot(sbdf >> 16, PCI_BUS_NUM(sbdf & 0xffff),
-					   sbdf & 0xff);
 	if (!pdev) {
 		pr_err("No pdev found for the sbdf 0x%x\n", sbdf);
 		return -ENODEV;
@@ -632,7 +632,6 @@ static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 	if (!vsec)
 		return -ENODEV;
 
-	pci_dev_put(pdev);
 	name = devm_kasprintf(&plat_dev->dev, GFP_KERNEL, "dwc_rootport_%x", sbdf);
 	if (!name)
 		return -ENOMEM;
-- 
2.53.0



