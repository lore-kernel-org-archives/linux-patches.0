Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8013349C4CC;
	Tue, 13 Oct 2026 12:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894515; cv=none; b=PbSmDuALKs7SReUZ6BSEVmbbbafjgBbzUqRWhykN/oT8wv3CmZREmipUxt8twtw+LieooAh31ELXSFHja4qbqknY2W9B9L9LgsMmTqpi8lZPgauzetdybeiUCyfVdQKnlksKLETX2dLPKdJ95417cPxjCXa5+CqYaCQtm1wgI+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894515; c=relaxed/simple;
	bh=8/huF4mszoQ6ln54KAnXi0ulq6hUvuvi3mksxRPuddA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZLoCOF3M3FrAK41N1WUWYF9YpjjWyRK22aSo+G8KOs4HNwGL8vXj4bv0luvrbk015tyi3S5MEqHTP6xMvUf4C9iL9UXTwdee7B+9ANap7wq5/CckE18VK+c2RYbiVOlWqPU2svHyglcVkcc96UwhK4lc4jGjMLrNrpzw6r4bUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JgR6kRwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JgR6kRwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFCE81F000FF;
	Tue, 13 Oct 2026 12:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894514;
	bh=MEczp+dwodd/8DNj+FA/LR139K24vjIJDTdueZONfYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JgR6kRwQsNLB9cWRoXu+LOugU1LQOnOlmdUG38PlhQ+5txOOzV8SEZII1eAZbg039
	 Qyq0eXrqW42+jA5HWSm5ctNXbsOOpGqX3aEZWWzEr6YEiOxgNEfoyxk58Z0mjG13uk
	 2wtKY5vXifZvTWJCDE6UAkyJfvZvsNDSedOfdc9Y=
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
Subject: [PATCH 6.18 587/621] bnxt_en: Add bnxt_clear_bars() helper
Date: Tue, 13 Oct 2026 13:39:42 +0200
Message-ID: <20261013112934.732535306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 744587e6cc631..cb846b2435216 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -16832,6 +16832,14 @@ void bnxt_print_device_info(struct bnxt *bp)
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
@@ -17306,7 +17314,6 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 	struct bnxt *bp = netdev_priv(netdev);
 	int retry = 0;
 	int err = 0;
-	int off;
 
 	netdev_info(bp->dev, "PCI Slot Reset\n");
 
@@ -17330,11 +17337,8 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
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



