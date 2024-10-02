Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3DD01D0975;
	Wed,  2 Oct 2024 13:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876656; cv=none; b=Yn8unhh+TI1gqUJ9jtGcUeJtBWUDHKotEIDWAK/r0ILAQTtgKD5nC8MkMFp3irF5wTCPBXG/hmuaeSCPcieEBTqhCqk+FO3Jq5Yaxp0VQOp3JxeislHHM4uNOEETqgqLq/MqogzxlC79/rlkGENQJmACpUtMwGvGu2boOwklnpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876656; c=relaxed/simple;
	bh=eJY1Pt1vxBh6u4MHCFvX9zmf7sxqrG6NrvJ5SqXdPVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q0ZTHNrIUc8UShsn5F8KwbxVoNC2YVpJb1if4T6Fn4ayY1PW0GOU4HKQYDHVQbPWJ14IM0N1achuf0K2wfujq5v8zqRp/u043Bs4aRY8VXv1nVwtYJqn9vt66mvkXj02NvmfX/g+3ffv+Wlw/LiywLy9AQW+HHA4fnplItTyxm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oiqV651U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiqV651U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEC01C4CEC5;
	Wed,  2 Oct 2024 13:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876656;
	bh=eJY1Pt1vxBh6u4MHCFvX9zmf7sxqrG6NrvJ5SqXdPVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiqV651UBVeL8vJ8pza2rY6Pu9Tn/PN2+4VzmR2ptNUVvRpaPiAjDjdU+YeWkUgQI
	 eFlpCxvGgBKQeodVeMccfoK4D/b/vHHKXK85oYT5x+wa2PZvhxxMdkePovSgD0Xcfh
	 GhyY0uJ5xjMIeAHejVfe244nLGDFqxBETt2hKbkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.11 518/695] PCI: Correct error reporting with PCIe failed link retraining
Date: Wed,  2 Oct 2024 14:58:36 +0200
Message-ID: <20241002125843.162298355@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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


