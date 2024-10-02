Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 067EE1CF7D4;
	Wed,  2 Oct 2024 14:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878723; cv=none; b=YxHhLoiZZ/geNW+p3Gm9H5GMZd6hvJ5NFJt454raCWOQKK6a9ipl14DoNHGg8+9txfmeYhZItuU7l+8jFEQbYl+49xRInSCC79YrvaBYovvt0332mMsmYZxwryGt3K3wmnXCP4AIPmiE70b3qXsNGnyqh9mEKerkxC8LwMCP/tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878723; c=relaxed/simple;
	bh=r8s6g86m1DX2P+VfRN7eT4/nD7cDk8UcsoBAFyTvTW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GtKUgUP/CJzORQn2zS+RHRFwkM6Ls/GKLb1o7ySLUmh974DPgft0cVzp5YYtbrkSWj8P4kLOwIDLssRFaNwMjlg8jqqQfcku2QxC+AArHnzKSaEMlV6fcK5CCCPcJS022A2tJE2SFMfkKOJHkrk27OFdoGsKnCMWAkF8aMz7fu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhw6SlXj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhw6SlXj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBE8C4CEC2;
	Wed,  2 Oct 2024 14:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878722;
	bh=r8s6g86m1DX2P+VfRN7eT4/nD7cDk8UcsoBAFyTvTW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhw6SlXjgSDeR72MFqqyHinZqyRZBdojAHobFCNTaUhpVkvTk0wRouFWB2M3waQ5l
	 ZWrh0r+inrvS/T1bH/JD+4aKgcBog9xtvYO4KT7nnz10eVPBCbhekih+JZGC3yo88Q
	 My8eAsGAtIqwPqpC0L4lwu3DhPZuZaSCxAwWjAUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Subject: [PATCH 6.10 470/634] PCI: Use an error code with PCIe failed link retraining
Date: Wed,  2 Oct 2024 14:59:30 +0200
Message-ID: <20241002125829.660522362@linuxfoundation.org>
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

commit 59100eb248c0b15585affa546c7f6834b30eb5a4 upstream.

Given how the call place in pcie_wait_for_link_delay() got structured now,
and that pcie_retrain_link() returns a potentially useful error code,
convert pcie_failed_link_retrain() to return an error code rather than a
boolean status, fixing handling at the call site mentioned.  Update the
other call site accordingly.

Fixes: 1abb47390350 ("Merge branch 'pci/enumeration'")
Link: https://lore.kernel.org/r/alpine.DEB.2.21.2408091156530.61955@angie.orcam.me.uk
Reported-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Link: https://lore.kernel.org/r/aa2d1c4e-9961-d54a-00c7-ddf8e858a9b0@linux.intel.com/
Signed-off-by: Maciej W. Rozycki <macro@orcam.me.uk>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Cc: <stable@vger.kernel.org> # v6.5+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pci.c    |    2 +-
 drivers/pci/pci.h    |    6 +++---
 drivers/pci/quirks.c |   20 ++++++++++----------
 3 files changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1295,7 +1295,7 @@ static int pci_dev_wait(struct pci_dev *
 		if (delay > PCI_RESET_WAIT) {
 			if (retrain) {
 				retrain = false;
-				if (pcie_failed_link_retrain(bridge)) {
+				if (pcie_failed_link_retrain(bridge) == 0) {
 					delay = 1;
 					continue;
 				}
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -541,7 +541,7 @@ void pci_acs_init(struct pci_dev *dev);
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
-bool pcie_failed_link_retrain(struct pci_dev *dev);
+int pcie_failed_link_retrain(struct pci_dev *dev);
 #else
 static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 					       u16 acs_flags)
@@ -556,9 +556,9 @@ static inline int pci_dev_specific_disab
 {
 	return -ENOTTY;
 }
-static inline bool pcie_failed_link_retrain(struct pci_dev *dev)
+static inline int pcie_failed_link_retrain(struct pci_dev *dev)
 {
-	return false;
+	return -ENOTTY;
 }
 #endif
 
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -78,21 +78,21 @@
  * again to remove any residual state, ignoring the result as it's supposed
  * to fail anyway.
  *
- * Return TRUE if the link has been successfully retrained.  Return FALSE
+ * Return 0 if the link has been successfully retrained.  Return an error
  * if retraining was not needed or we attempted a retrain and it failed.
  */
-bool pcie_failed_link_retrain(struct pci_dev *dev)
+int pcie_failed_link_retrain(struct pci_dev *dev)
 {
 	static const struct pci_device_id ids[] = {
 		{ PCI_VDEVICE(ASMEDIA, 0x2824) }, /* ASMedia ASM2824 */
 		{}
 	};
 	u16 lnksta, lnkctl2;
-	bool ret = false;
+	int ret = -ENOTTY;
 
 	if (!pci_is_pcie(dev) || !pcie_downstream_port(dev) ||
 	    !pcie_cap_has_lnkctl2(dev) || !dev->link_active_reporting)
-		return false;
+		return ret;
 
 	pcie_capability_read_word(dev, PCI_EXP_LNKCTL2, &lnkctl2);
 	pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
@@ -106,13 +106,13 @@ bool pcie_failed_link_retrain(struct pci
 		lnkctl2 |= PCI_EXP_LNKCTL2_TLS_2_5GT;
 		pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, lnkctl2);
 
-		ret = pcie_retrain_link(dev, false) == 0;
-		if (!ret) {
+		ret = pcie_retrain_link(dev, false);
+		if (ret) {
 			pci_info(dev, "retraining failed\n");
 			pcie_capability_write_word(dev, PCI_EXP_LNKCTL2,
 						   oldlnkctl2);
 			pcie_retrain_link(dev, true);
-			return false;
+			return ret;
 		}
 
 		pcie_capability_read_word(dev, PCI_EXP_LNKSTA, &lnksta);
@@ -129,10 +129,10 @@ bool pcie_failed_link_retrain(struct pci
 		lnkctl2 |= lnkcap & PCI_EXP_LNKCAP_SLS;
 		pcie_capability_write_word(dev, PCI_EXP_LNKCTL2, lnkctl2);
 
-		ret = pcie_retrain_link(dev, false) == 0;
-		if (!ret) {
+		ret = pcie_retrain_link(dev, false);
+		if (ret) {
 			pci_info(dev, "retraining failed\n");
-			return false;
+			return ret;
 		}
 	}
 


