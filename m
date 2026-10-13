Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF67A4F68A9;
	Tue, 13 Oct 2026 11:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892705; cv=none; b=GqKVp7pY5nRs9l/ZaUz6uHsMSBMiwyFOCxfEQTSGgahZ/IayWKjUbMGYndMj1v8z4I6aNPsTNMJ4VTX7RmXy+3fOUy+Fcx9hUwz1LC+5rfkhJMiVlcLaCWBSy5RFW9wJlGPEPYrhEi8i2fSNLB1B4aLKRZagsSAL2sM/PoT5Rwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892705; c=relaxed/simple;
	bh=ffRFtOeoz2x9iT//dRKuQr1HfXk/M22GXD42ZkPlwWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ajsvjw78pidvFn0iUTCsXodBTDLItvSpDA6jHgNGq7W82zUFNrMhFUD5ck9KLiYecgvCE3CutP3aD9MkqT8M3Gf+dc1p6J/T00wFCm/txpBUpgfzArhOzhYgqiJo9m+KYSNmACUqqIUobgicz+dv+rTIYPECtTD0PcDne+fG9DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WS+kjYkY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WS+kjYkY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09D4A1F000FF;
	Tue, 13 Oct 2026 11:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892704;
	bh=jRVNNHSJrPX+3llSt8b1VL/u0dc1GOP9KtR3qEIs4e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WS+kjYkYi9vwh0w8BWklXQXsCsJRMFjcpzMJe92MBFrTC7/4JSy7o/mYx4JEk0Zt2
	 omg8eI+ETdByv38eWKfa3RCPCMLIAP25KGvaeumIcq10/wODYCLtMDcCn1wuuhIOku
	 kJAzFwdrzS4mFyyvWr4CjXP0K2uMQSBoXc1FnHqg=
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
Subject: [PATCH 7.2 260/281] bnxt_en: Add bnxt_clear_bars() helper
Date: Tue, 13 Oct 2026 13:39:36 +0200
Message-ID: <20261013112901.451521823@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index cad3bbe1b12f0..da35fec65d1b0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -17066,6 +17066,14 @@ void bnxt_print_device_info(struct bnxt *bp)
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
@@ -17547,7 +17555,6 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 	struct bnxt *bp = netdev_priv(netdev);
 	int retry = 0;
 	int err = 0;
-	int off;
 
 	netdev_info(bp->dev, "PCI Slot Reset\n");
 
@@ -17576,11 +17583,8 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
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
 
 		bnxt_inv_fw_health_reg(bp);
-- 
2.53.0



