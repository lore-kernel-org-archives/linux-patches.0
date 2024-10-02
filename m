Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E1319F411;
	Wed,  2 Oct 2024 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878604; cv=none; b=eZEvhAxaSHquv/kj9cszTtEyHnK3mt2CYLFFmjoo0LlSv2QFWAPp2HKWlza70jLZbwAFi36s3fjV9ZprFjp6voYKTBZc381cgpiO05bg/DuSnBHrDRRBHjn7V6eZuJVn0KJrPZPeeXJO28x4D8x/y5O5Gu3cNy0QlOw5VunvO4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878604; c=relaxed/simple;
	bh=G0tLt1KB5+pbuYAiPNmRDM3crTTRUNjOVerQDa9ZMsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jL7RK7e/M5xsWuGcty0PtRE3/SUay/3Jo7R5cfjBn8zgaIAb+9PRLQsRyzdTqK2hptsz7YUR3VBmNldxgxIc1vWmfa26DzL1gAq74rumW7EYpOxVPLFOquPmvLkqQyEEpTR8UTwA3//QeCN1fvU4MKYbU772Yuzj26YV6hpkUcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0iHWURd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0iHWURd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852D2C4CEC2;
	Wed,  2 Oct 2024 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878603;
	bh=G0tLt1KB5+pbuYAiPNmRDM3crTTRUNjOVerQDa9ZMsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0iHWURd4/mAn8WpzjrXFC/jkpK7w6PdW3DuaiS4T1Kr9oe/5p7PfGky4U0W0oblA
	 l1JP6cvWMvBMnQsf/+RarOTJ/MDL6s0tuV/Vrr/NlxqalxxvA42uVGwYgb1K8sDx3J
	 FuEV3ifArTBS/+apFuJZAKevB8w9XGNkuILg7a/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.10 469/634] PCI: Correct error reporting with PCIe failed link retraining
Date: Wed,  2 Oct 2024 14:59:29 +0200
Message-ID: <20241002125829.620188561@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej W. Rozycki <macro@orcam.me.uk>

commit 712e49c967064a3a7a5738c6f65ac540a3f6a1df upstream.

Only return successful completion status from pcie_failed_link_retrain() if
retraining has actually been done, preventing excessive delays from being
triggered at call sites in a hope that communication will finally be
established with the downstream device where in fact nothing has been done
about the link in question that would justify such a hope.

Fixes: a89c82249c37 ("PCI: Work around PCIe link training failures")
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2408091133260.61955@angie.orcam.me.uk
Reported-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/aa2d1c4e-9961-d54a-00c7-ddf8e858a9b0@linux.intel.com/
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -78,7 +78,8 @@
  * again to remove any residual state, ignoring the result as it's supposed
  * to fail anyway.
  *
- * Return TRUE if the link has been successfully retrained, otherwise FALSE.
+ * Return TRUE if the link has been successfully retrained.  Return FALSE
+ * if retraining was not needed or we attempted a retrain and it failed.
  */
 bool pcie_failed_link_retrain(struct pci_dev *dev)
 {
@@ -87,6 +88,7 @@ bool pcie_failed_link_retrain(struct pci
 		{}
 	};
 	u16 lnksta, lnkctl2;
+	bool ret = false;
 
 	if (!pci_is_pcie(dev) || !pcie_downstream_port(dev) ||
 	    !pcie_cap_has_lnkctl2(dev) || !dev->link_active_reporting)
@@ -104,7 +106,8 @@ bool pcie_failed_link_retrain(struct pci
 		lnkctl2 |= PCI_EXP_LNKCTL2_TLS_2_5GT;
 		pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, lnkctl2);
 
-		if (pcie_retrain_link(dev, false)) {
+		ret = pcie_retrain_link(dev, false) == 0;
+		if (!ret) {
 			pci_info(dev, "retraining failed\n");
 			pcie_capability_write_word(dev, PCI_EXP_LNKCTL2,
 						   oldlnkctl2);
@@ -126,13 +129,14 @@ bool pcie_failed_link_retrain(struct pci
 		lnkctl2 |= lnkcap & PCI_EXP_LNKCAP_SLS;
 		pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, lnkctl2);
 
-		if (pcie_retrain_link(dev, false)) {
+		ret = pcie_retrain_link(dev, false) == 0;
+		if (!ret) {
 			pci_info(dev, "retraining failed\n");
 			return false;
 		}
 	}
 
-	return true;
+	return ret;
 }
 
 static ktime_t fixup_debug_start(struct pci_dev *dev,


