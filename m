Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E29559308;
	Mon, 31 Aug 2026 13:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184043; cv=none; b=FmIu+Oc7OvPP90hoLa6W9EJKBoTltJCM4RScOHhr/NZwRA28zxhiwJoqMp29YGNXVCx9kAg9obbK7k9wHMk9VkTZwUnZNWYN29dPRnsmBINebOskZ7CHGW2wN6kpGAPe9wbxbFn/jn0JX2dQ8IoLJrdkB04hJ9BH0S/Qo1196Qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184043; c=relaxed/simple;
	bh=/Xsz5I6HkmNkamVyJWHhNOtRzjEbRhgnJA3VZuGRYEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AoL1vFFkdaeHcVgLSPvmwInE9A7cVMVSGf2ZiLGaXguRxo+ZdNxMY5LJUxLsf3NkW4WuRx9CWlk0uk/HSxO2F2ny1x8SfaSGmTBa3jLRwkJMyKzhcOg1vQ2tKLqTb+rx9a1CET0AyTRQJwkacjNx8IxVA1beJ00RjM8InOLJifg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EShJasyn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EShJasyn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B6811F000E9;
	Mon, 31 Aug 2026 13:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184039;
	bh=qraHHyWGPOawjxx5eJlLEGU9p/zi01bi/ditLojLt6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EShJasynCBkr+KbF6ZerY4j3DIe3hAEBDBfnWuXY+yMZOr3SEZ8QG6uq5/nbU33qT
	 GpOBEdd0hnymbWSqJK0O2/A0ADRoeukPyg0aNSZ8jKMUkCJqd9U/ASzMbPe4DZs+ek
	 b6G7RY4645qIm+NU8xF8RqEYI1obPNEf6z33Gze3mtjD+oVwSPkFvjSxjr2K/HGk5L
	 dFBjfi7ZY8IdvR2pBc7JBspCkeIbz9QvVS9bKyb2B991/TsKPZY8sGACU9++Hql0p4
	 EKjlb8WWDDSjWBOHmp7fsP+HgI77v7cIeUr++1UhqzGeDHB1oCbx/tHTeIc1jO967K
	 5JnaCmVV5Wblg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	marcel@holtmann.org,
	luiz.dentz@gmail.com,
	linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] Bluetooth: btintel_pcie: Add 50 ms delay before MAC init on BlazarIW
Date: Mon, 31 Aug 2026 09:28:03 -0400
Message-ID: <20260831133314.4125787-455-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kiran K <kiran.k@intel.com>

[ Upstream commit 4d62d88e7ae6dcecd9a8c70a045a6c6c64bf3b52 ]

On BlazarIW, fast restart cycles fail because the D0 entry to MAC
init does not complete in time. As a result, MAC initialization
does not proceed and the controller fails to transition past the
ROM boot stage.

Add a 50 ms delay (worst case as per HW analysis) before doing MAC
init in btintel_pcie_enable_bt() so the shared hardware reset flow
has time to complete. The delay is gated on the BlazarIW PCI device
id 0x4D76 so other Intel BT PCIe controllers are unaffected.

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The background checks finished and match the earlier analysis:

1. **Commit search** — The BlazarIW 50 ms delay patch is **not in this
   local tree**. A `git log --grep="50 ms delay"` only turned up
   unrelated delay commits in other subsystems (xprtrdma, hci_qca, drm).

2. **BlazarIW support** — Device `0x4D76` landed via `6053b532d345b` and
   is present from the **v6.17/v6.18** era onward. It is **not** in
   v6.12, which fits evaluating this only for the checked-out
   **v6.18.44** tree.

That leaves the conclusion unchanged: backport **YES** for this tree —
BlazarIW is supported here, but the MAC-init timing fix is still
missing.

 drivers/bluetooth/btintel_pcie.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/bluetooth/btintel_pcie.c b/drivers/bluetooth/btintel_pcie.c
index d0aa1666d6ac6..c0441541c0862 100644
--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -740,6 +740,11 @@ static void btintel_pcie_dump_traces(struct hci_dev *hdev)
 		bt_dev_err(hdev, "Failed to dump traces: (%d)", ret);
 }
 
+static bool btintel_pcie_is_blazariw(struct pci_dev *pdev)
+{
+	return pdev->device == 0x4D76;
+}
+
 /* This function enables BT function by setting BTINTEL_PCIE_CSR_FUNC_CTRL_MAC_INIT bit in
  * BTINTEL_PCIE_CSR_FUNC_CTRL_REG register and wait for MSI-X with
  * BTINTEL_PCIE_MSIX_HW_INT_CAUSES_GP0.
@@ -759,6 +764,14 @@ static int btintel_pcie_enable_bt(struct btintel_pcie_data *data)
 	btintel_pcie_wr_reg32(data, BTINTEL_PCIE_CSR_CI_ADDR_MSB_REG,
 			      (u64)data->ci_p_addr >> 32);
 
+	/* On BlazarIW, the D0 entry to MAC init does not complete in
+	 * time. Wait 50 ms (worst case as per HW analysis) for the
+	 * shared hardware reset flow to complete before proceeding with
+	 * MAC init.
+	 */
+	if (btintel_pcie_is_blazariw(data->pdev))
+		msleep(50);
+
 	/* Reset the cached value of boot stage. it is updated by the MSI-X
 	 * gp0 interrupt handler.
 	 */
-- 
2.53.0

