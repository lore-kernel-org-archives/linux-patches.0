Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213815;
	b=3L2oMJzX4YBuLm3W6yiYJzvFSEK9HAoopd9AWgkG7Y6WAqerQfLnrvcuPQnVUryrRxwI
	 2ZqScTeFu5bqpXbTOk9phtVKZRheBzzmNuhtlQ3yM4CVVZR/9Q3kthyYh93CAjxUBRVQf
	 wgj40y0x00VLvO7klrAGJwElxT/3BXU6sjxCCVWuJp0X95hBxXI0St8GDXrKOExoPTbTT
	 uIrc2Folhr14rK151q53ZqHfirCwTsyqGADWqNb0EFjCD30+j2KdiWB3iTc+tVvQH7X9a
	 vCiGRXyFpEjJeMcFrpEeP/3Hl16auc4spk03ryShXIb41/uWcNF6A/GQGeklhihRSSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213815;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=fIspIweQIzSNnnP4+qt+ZPC4XN2qbPUfV6H5VsLpMrQ=;
	b=spwwTWwmBuS1TOBL6YQia5EweDB7SBRussvY8GlmeIadviwf0/Jp5uyFksvK+Ph1py3u
	 nPTV5lVcxNG8hNxQKB1DsdN4uAVwKTDfSmhIUsqPonDswnBvPdRq+R94cZZ1g4/xDYAUJ
	 OYlbZP2T7uuAZVIPfvfcipdzbicXr+ddDkk6nvv213Z2LhPnWGrmeXzKbbXowYeHtjTzr
	 OvieeUjudQNZ0LQHpXrk5xAHyhLZh9FMssMpVKbSiA/OPkDl5gz1JRpwQoIkmsMRK/222
	 egm4EliQa0BYHeOJLamoeflnCmxLKzDox6szS1FTKj4DPpnpbFtx6vHc2Rpi0r2VVbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DH0UqZwK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972A5606A31C;
	Wed, 28 Oct 2026 18:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DH0UqZwK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE291F01825;
	Wed, 28 Oct 2026 18:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213815;
	bh=fIspIweQIzSNnnP4+qt+ZPC4XN2qbPUfV6H5VsLpMrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DH0UqZwKDkiTyMHBwPVLlaxlaokD5U9p/RGivOBp0MxQ36rbRtYImuSxA177NIyAB
	 q5wPimx4hvhLhB4hG9O2F8srWz6ZTwBYzOPly6Zwffwv6JeqYbmjrxwvmET/rEiU+P
	 dzrnDEP7b5+SOZ5LquBX1OynP2WDbrHu+jn3n8Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0640/1887] PCI: endpoint: pci-epf-test: Make use of cached epc_features in pci_epf_test_core_init()
Date: Wed, 28 Oct 2026 17:45:36 +0100
Message-ID: <20261028170513.974823066@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

[ Upstream commit 5a5095a8bd1bd349cce1c879e5e44407a34dda8a ]

Instead of getting the epc_features from pci_epc_get_features() API, use
the cached pci_epf_test::epc_features value to avoid the NULL check. Since
the NULL check is already performed in pci_epf_test_bind(), having one more
check in pci_epf_test_core_init() is redundant and it is not possible to
hit the NULL pointer dereference.

Also with commit a01e7214bef9 ("PCI: endpoint: Remove "core_init_notifier"
flag"), 'epc_features' got dereferenced without the NULL check, leading to
the following false positive Smatch warning:

  drivers/pci/endpoint/functions/pci-epf-test.c:784 pci_epf_test_core_init() error: we previously assumed 'epc_features' could be null (see line 747)

Thus, remove the redundant NULL check and also use the epc_features::
{msix_capable/msi_capable} flags directly to avoid local variables.

[kwilczynski: commit log]
Fixes: 5e50ee27d4a5 ("PCI: pci-epf-test: Add support to defer core initialization")
Closes: https://lore.kernel.org/linux-pci/024b5826-7180-4076-ae08-57d2584cca3f@moroto.mountain
Link: https://lore.kernel.org/linux-pci/20240418-pci-epf-test-fix-v2-1-eacd54831444@linaro.org
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 3fe2187cdd0ba..fb47ce721e095 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -782,19 +782,11 @@ static int pci_epf_test_core_init(struct pci_epf *epf)
 {
 	struct pci_epf_test *epf_test = epf_get_drvdata(epf);
 	struct pci_epf_header *header = epf->header;
-	const struct pci_epc_features *epc_features;
+	const struct pci_epc_features *epc_features = epf_test->epc_features;
 	struct pci_epc *epc = epf->epc;
 	struct device *dev = &epf->dev;
-	bool msix_capable = false;
-	bool msi_capable = true;
 	int ret;
 
-	epc_features = pci_epc_get_features(epc, epf->func_no, epf->vfunc_no);
-	if (epc_features) {
-		msix_capable = epc_features->msix_capable;
-		msi_capable = epc_features->msi_capable;
-	}
-
 	if (epf->vfunc_no <= 1) {
 		ret = pci_epc_write_header(epc, epf->func_no, epf->vfunc_no, header);
 		if (ret) {
@@ -807,7 +799,7 @@ static int pci_epf_test_core_init(struct pci_epf *epf)
 	if (ret)
 		return ret;
 
-	if (msi_capable) {
+	if (epc_features->msi_capable) {
 		ret = pci_epc_set_msi(epc, epf->func_no, epf->vfunc_no,
 				      epf->msi_interrupts);
 		if (ret) {
@@ -816,7 +808,7 @@ static int pci_epf_test_core_init(struct pci_epf *epf)
 		}
 	}
 
-	if (msix_capable) {
+	if (epc_features->msix_capable) {
 		ret = pci_epc_set_msix(epc, epf->func_no, epf->vfunc_no,
 				       epf->msix_interrupts,
 				       epf_test->test_reg_bar,
-- 
2.53.0



