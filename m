Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A40C342C80;
	Tue, 13 Oct 2026 12:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896049; cv=none; b=QLYMmuMGjz+rblHJ5MA6xFbduTl3gPwqco8eswznE+FXMAHZTdFsPs21+NsBh24sHExkMruWAxYhiXdlsFvZaZSBgg+dAG9bhjpe9ujWNZlW+P8EuVMGwd7VHkzL31zf7mXjZP6oL8X9FCZzqLLTH2z3hnfVtAzIgdAJrdVt9AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896049; c=relaxed/simple;
	bh=P49lijQfISLB3k9idCrcMy+OFUqOLxdpXQEg2XlolOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCPFWhYRHuU50qzrH/ybo3wMv3AzJAxXnJcRJ8bNax9ARAVO1D9bPf/Z85qPi/mbKqc97WpFskwob7ni9fhJaI3alyu6LRcrcnORP57ksMaPmHcfGg8MgR2urwBKYXyIjp6QKkpUqJcWZEe7cbDb0aH2IFWhXE1A8JymJO5hcOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbbUcXV1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbbUcXV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3DA1F00893;
	Tue, 13 Oct 2026 12:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896048;
	bh=F8e+G0N3QwAWRC03E2FHs0Dx10EwlhvKFt61+YfLyyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbbUcXV1F/LQbQVwrBxiTtRD/nAnDlCw7eS/un+pqAahWC4TkRdy7XfkOeEdIxLEN
	 300QF+RtL5vwpzNmE4h6vP2V+Q13oM8Jb35Yosb5Kz+QcJB9TIT4x5XvIY1jZCwSHs
	 LW/v4LK9ChC0oUpC9AtNmkLXZ9TBwqr7pcyPPnKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Joe Damato <joe@dama.to>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 480/497] bnxt_en: Add bnxt_clear_bars() helper
Date: Tue, 13 Oct 2026 13:40:47 +0200
Message-ID: <20261013112919.270741200@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit 8f5d59b9cfa69beab3b52cca621bb301c5af98aa ]

In bnxt_io_slot_reset(), we clear the 6 BAR registers.  Add a helper
function to do that.  The helper will be used again in the next patch.

Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Joe Damato <joe@dama.to>
Signed-off-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/20261005204246.3822563-2-michael.chan@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 386f887c8290 ("bnxt_en: Fix driver init in kdump kernel")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index ecda6c2abe413..95f4259789ad6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16064,6 +16064,14 @@ void bnxt_print_device_info(struct bnxt *bp)
 	pcie_print_link_status(bp->pdev);
 }
 
+static void bnxt_clear_bars(struct pci_dev *pdev)
+{
+	int off;
+
+	for (off = PCI_BASE_ADDRESS_0; off <= PCI_BASE_ADDRESS_5; off += 4)
+		pci_write_config_dword(pdev, off, 0);
+}
+
 static int bnxt_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 {
 	struct bnxt_hw_resc *hw_resc;
@@ -16522,7 +16530,6 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 	struct bnxt *bp = netdev_priv(netdev);
 	int retry = 0;
 	int err = 0;
-	int off;
 
 	netdev_info(bp->dev, "PCI Slot Reset\n");
 
@@ -16546,11 +16553,8 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 		 * write the BARs to 0 to force restore, in case of fatal error.
 		 */
 		if (test_and_clear_bit(BNXT_STATE_PCI_CHANNEL_IO_FROZEN,
-				       &bp->state)) {
-			for (off = PCI_BASE_ADDRESS_0;
-			     off <= PCI_BASE_ADDRESS_5; off += 4)
-				pci_write_config_dword(bp->pdev, off, 0);
-		}
+				       &bp->state))
+			bnxt_clear_bars(pdev);
 		pci_restore_state(pdev);
 		pci_save_state(pdev);
 
-- 
2.53.0



