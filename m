Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018544;
	b=s2yUtU7Jz9DJNjuDoav2kv+Vh3Kz3WrAcw2znXjqwP2Q8qUFy7yftyXLFLHnbOofLSJh
	 J13f98TEj80Z5bKJw0DtJEI43N/kMICG6JzTNrJviXlN7fksvZm+gT560hnM6l8znt78p
	 //r7KgbMKW9u9n3gEka1HA6RoNI+FG5O1bULVtYsAnjJtIvoXnLi9+PN0Nbi4jvkN7I4L
	 JICeBzeykO4AvOlqxxRqbCW0zXTDVkovClLl7AiiA8EV6ZrvCiSoiExaL+gQ6QO6AptsM
	 fPXx4KeLyKhBsFj1z7Xys5sEvPxeA6id1+wJi1W+rB/b+W3MqKvw9oJ6g6EkqfpL0jA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rfLyU9lTV3LjRzEP5mB+8haCjhyiOLgEfPmtwgoxp30=;
	b=lZzRbqMJOaXI+7sOkmhliIUY2F72hEjAeDxHOE6/F8cSTZQLHUCtpPgXAFIXxQ3V54pn
	 cWyGngkGhYeuXWq4zXuDcBL+U2fTUN5JTpLIXDHId5ugwolk2dtWpslBljHMBYTijsGfm
	 vz6zHU6S8jo8x7KgMmxPVJ/llCW5WQTg8qkw9PZQiShYhAr5v5h2jRBRsW+BbqZi8ni7p
	 8H0LVEu0GoaKxvBa5XBpJN6fBqOB1D0da2nPaEqWYD4W9fucKj0aN6AV8xAo+03IJuiqO
	 4YLAlZMzY8pFAH9LHDSmIHLmSPR12/jL3GJnrk5Jwkcp9fD4gavA/SwELzKTcqRfwWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oqv1fpOj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EEE4606A32C;
	Wed, 18 Nov 2026 16:15:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oqv1fpOj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFD71F000C8;
	Wed, 18 Nov 2026 16:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018544;
	bh=rfLyU9lTV3LjRzEP5mB+8haCjhyiOLgEfPmtwgoxp30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oqv1fpOjSHIRJJekYI9KdWWw1XR7s1XYSgzQc4K30xPTiS0e5MiyFJioamNk/SdIo
	 +uxpo1hKgUeBNjABGK45KQkOcs4d13uAAPUnO1jfrJu/SZMuF0DJxJgzu+qfe6DRWC
	 1OhuE1MYmZkuk48DAGwOk5Ct8SL/wNYW2quXadwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <Markus.Elfring@web.de>,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1261/2651] perf/dwc_pcie: Fix PCI device reference leak in probe
Date: Wed, 18 Nov 2026 15:41:41 +0100
Message-ID: <20261118150333.372447174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 6b9ed59de26eb..eb86e7468c49b 100644
--- a/drivers/perf/dwc_pcie_pmu.c
+++ b/drivers/perf/dwc_pcie_pmu.c
@@ -747,16 +747,16 @@ static struct notifier_block dwc_pcie_pmu_nb = {
 
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
@@ -766,7 +766,6 @@ static int dwc_pcie_pmu_probe(struct platform_device *plat_dev)
 	if (!vsec)
 		return -ENODEV;
 
-	pci_dev_put(pdev);
 	name = devm_kasprintf(&plat_dev->dev, GFP_KERNEL, "dwc_rootport_%x", sbdf);
 	if (!name)
 		return -ENOMEM;
-- 
2.53.0



