Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D25142E83;
	Sat, 14 Feb 2026 21:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771104347; cv=none; b=RAtXjZcqk83GTBtsl9XutzRbiidWOF4CMf/NVdXa4aG4R029Uc0t4mP9iRJEVdf4yoLntKbgZryN+gKahRLP7TQTsz3X3jHT4/x6JOr+GaQXUodyGR7HYBmnNT7PZqh1t2UU4sVIGWrNXE4wCzHGtItD59PqE4dsPyNHKd0t64w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771104347; c=relaxed/simple;
	bh=/MDeQ+MloBzv0PITqc98P7UWt1PQvzBtS3gO8cMn8oE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ab73LhwdEuguCy359lUnt5gAvWC7325xNX93IFqLgL51xs3EBOKkWHc6hewS5tcq0G427CQIhXFUi7LgcUR/ZR0qfEMtHm9ZnXle0wK3Os0gqqlCgBvpBN7OGLsYN9nxIdnF6JfytCRPDYEnAnTzJJoeYvaU+b7AWt0Q+5kfulQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OLZL9dHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OLZL9dHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1012FC19422;
	Sat, 14 Feb 2026 21:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771104347;
	bh=/MDeQ+MloBzv0PITqc98P7UWt1PQvzBtS3gO8cMn8oE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OLZL9dHkPS4n2LG/MZRJf5USLgfaroFiZ0x8C1iG8c0yKpFXfpUPyQlZRLHzfbLzx
	 SiHIkcea0CH5BMpiy/qvyvEZpA3wjnUZhC7AX0nEAmwFkyKNKJIHhWTl4Bpqh33m9Q
	 hL6v15mhEg9siHF4QuQIXpQeDrw9WrxDJB2d9CVYG0F4tT7Hkev/kAIggqeXt87Crb
	 sUAoLe0gxDzK0B/OfmIzybLugPyrgNrgRaov0trU8G7qNiDkh7NCrkOoP0pK0AjS/z
	 AkIc4Y1TmkrcdeOBzxsQsvFvSBOELWHsFdaM7YPeArykvc6v3inLbt8wyoHpO4yifB
	 NoJD9WqjDj97g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Frank Li <Frank.Li@nxp.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>,
	jingoohan1@gmail.com,
	linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.18] PCI: dwc: Skip PME_Turn_Off broadcast and L2/L3 transition during suspend if link is not up
Date: Sat, 14 Feb 2026 16:22:54 -0500
Message-ID: <20260214212452.782265-29-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260214212452.782265-1-sashal@kernel.org>
References: <20260214212452.782265-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19
Content-Transfer-Encoding: 8bit

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit cfd2fdfd0a8da2e5bbfdc4009b9c4b8bf164c937 ]

During system suspend, if the PCIe link is not up, then there is no need
to broadcast PME_Turn_Off message and wait for L2/L3 transition. So skip
them.

Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Tested-by: Vincent Guittot <vincent.guittot@linaro.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/20251218-pci-dwc-suspend-rework-v2-1-5a7778c6094a@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let me look at the full commit chain. Before v6.14, the code in
v6.6-v6.13 had an early return (`if (dw_pcie_get_ltssm(pci) <=
DW_PCIE_LTSSM_DETECT_ACT) return 0;`) which meant when no endpoint was
connected, the function returned early - skipping both the PME stuff AND
`dw_pcie_stop_link()` and `deinit()`.

In v6.14, commit `86a016e278b78` added `dw_pcie_stop_link()` but AFTER
the L2 wait timeout, and `112aba9a79345` removed the early LTSSM check.
This combination means: when no link is up, the code tries to do PME/L2
stuff, might timeout, and returns error before reaching stop_link.

The commit under review fixes this by adding a proper
`dw_pcie_link_up()` check at the top that skips directly to
`stop_link:`, ensuring the link is always properly stopped and deinit is
always called.

### Dependency Analysis

This commit depends on:
1. `112aba9a79345` (v6.14) - Removed the LTSSM state guard and
   restructured the timeout handling
2. `86a016e278b78` (v6.14) - Added `dw_pcie_stop_link()` to the suspend
   path
3. Possibly `e1a4ec1a9520b` (v6.14) - Added MSG TLP support for
   PME_Turn_Off
4. `8f4a489b370e6` - Modified dw_pcie_pme_turn_off()

The code in the diff matches the state of the file as it exists in
v6.14+. For stable trees < v6.14 (6.6.y, 6.1.y, etc.), the context is
completely different because the old code had an early return for no-
link case. The bug this fixes was essentially **introduced** by the
v6.14 changes that removed the LTSSM guard.

### Classification

This is a **bug fix** for the suspend path - it prevents:
1. Timeout errors during suspend when PCIe link is down
2. Missing stop_link/deinit calls (resource cleanup)
3. Broken resume after failed suspend

The fix is:
- Small and contained (a few lines added)
- Obviously correct (skip link-related operations if link isn't up)
- Well-reviewed (Reviewed-by from Frank Li and Shawn Lin, Tested-by from
  Vincent Guittot)
- Self-contained (no additional dependencies beyond what's already in
  the file)

### Risk Assessment

- **Low risk**: The change only adds a guard at the top of the function.
  If the link IS up, the behavior is completely unchanged. If the link
  is NOT up, it skips meaningless operations and goes to cleanup.
- **Scope**: Only affects DWC PCIe host controller suspend path, very
  specific scenario (link down during suspend)
- **Impact**: Fixes real suspend failures on ARM/embedded platforms
  using DWC PCIe (Qualcomm, Rockchip, i.MX, etc.)

### Concerns

The primary concern is **dependency**: This commit effectively fixes a
regression introduced by `112aba9a79345` and `86a016e278b78` in v6.14.
For stable trees that don't have those commits (6.6.y, 6.1.y), the old
code had a different guard (`dw_pcie_get_ltssm() <=
DW_PCIE_LTSSM_DETECT_ACT`) that handled the link-down case differently
(by returning 0 early). So:

- For 6.14.y: This fix applies cleanly and is directly needed
- For 6.6.y and earlier: The patch won't apply cleanly and the
  underlying bug pattern is different

The fix is appropriate for stable trees that contain the dependent
commits (6.14+), and would need adaptation for older stable trees. But
since it fixes a real suspend regression on widely-used hardware
platforms, it's worth backporting.

### Verdict

This commit fixes a real bug where system suspend fails with timeout
errors on DWC PCIe controllers when no endpoint is connected (link not
up). It's small, well-reviewed, tested, and fixes a clear regression. It
meets stable kernel criteria.

**YES**

 drivers/pci/controller/dwc/pcie-designware-host.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/dwc/pcie-designware-host.c b/drivers/pci/controller/dwc/pcie-designware-host.c
index 372207c33a857..250725ced9026 100644
--- a/drivers/pci/controller/dwc/pcie-designware-host.c
+++ b/drivers/pci/controller/dwc/pcie-designware-host.c
@@ -1158,8 +1158,11 @@ static int dw_pcie_pme_turn_off(struct dw_pcie *pci)
 int dw_pcie_suspend_noirq(struct dw_pcie *pci)
 {
 	u8 offset = dw_pcie_find_capability(pci, PCI_CAP_ID_EXP);
+	int ret = 0;
 	u32 val;
-	int ret;
+
+	if (!dw_pcie_link_up(pci))
+		goto stop_link;
 
 	/*
 	 * If L1SS is supported, then do not put the link into L2 as some
@@ -1194,6 +1197,7 @@ int dw_pcie_suspend_noirq(struct dw_pcie *pci)
 	 */
 	udelay(1);
 
+stop_link:
 	dw_pcie_stop_link(pci);
 	if (pci->pp.ops->deinit)
 		pci->pp.ops->deinit(&pci->pp);
-- 
2.51.0

