Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214099;
	b=QyWCgrf70Pv4QUmr4MC2LpGTHsWf85NVAKatkZtx36m7N0L42VeW7gefXTmQVEt0g3ZK
	 QVFEB7XcxAocF0zbxltaE1PP5u1h/tRZekNkhqazsu6raCqbBDX+9Ea+c4H3kdULBfPmS
	 SM2uJ09FKxapvTy9xiU5sHzyJsALt7UCnPpbtrS6tUxG2iCwXB2QwkWmH0oy0z/F7hpVw
	 +Cw4NxPam/ZlcaCu931nlb0p/ubpio4OOHh1AKWLiJKldGB9p+91Gs+dfk3in1qK2oCoz
	 BfNMJcdk6eXPyzh6bUfoSTTLUizW5TrA5PLte0u+SfwxFltYh+8NwS25SbzJ0sXS1gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214099;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ldJUSmWmTO+l02wayCpITRmQgaGDr7M2fI5MlF7ywe0=;
	b=hW2WCnIPN360scK3d9IjnSX81Xfysql6gzprcfwsOuSah2nYG4aPNYmhowQK5zHO2i8Q
	 aNy3p3FwzxZJhEAkJTw2Ar+Bg5PTUN5uhj6pD1E0lEqhcQwd+CriUObjGZ6QwRroot9PL
	 IBfL8PHBnqFQ4k4nJRBUXwA7hhtk9d4Lc/muF0O2Q5ZfLliXw3e+gCLaGUjaYKRIg20TB
	 GBRkycCuoc4VACvLrAmBR9CRDWUIO36nyAvyANfZ04ktEq3WjBIyvZZK8f6yq6oht/gRL
	 lqSe+QcehatnzvOVoq3IVP47BaDxyofF9AY5EFPqT+Pfn6h6447uO8faNNE2qVF6ZgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfZwPdIs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39EAE606A31A;
	Wed, 28 Oct 2026 19:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qfZwPdIs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 895B41F01825;
	Wed, 28 Oct 2026 19:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214099;
	bh=ldJUSmWmTO+l02wayCpITRmQgaGDr7M2fI5MlF7ywe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qfZwPdIsn5LvJrRqXQbUTCJ8wpCh/Xgjs5QpCfJmC5xTPxJzLyuAZ3woBBDhOZwCI
	 i0H9DVF+C7Aso7ccNVNsm0AITaGh4/waBXXagLurF4yhdDX3ezGW1AQsSnThemyGCT
	 DLuG/83bjsoL+HoBR2J6Yl9caW5TRctMsO6rwzP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iain Lane <iain@orangesquash.org.uk>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0739/1887] x86/PCI: Avoid PME from D3hot/D3cold for AMD Rembrandt and Phoenix USB4
Date: Wed, 28 Oct 2026 17:47:15 +0100
Message-ID: <20261028170516.263401886@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 7d08f21f8c6307cb05cabb8d86e90ff6ccba57e9 ]

Iain reports that USB devices can't be used to wake a Lenovo Z13 from
suspend.  This occurs because on some AMD platforms, even though the Root
Ports advertise PME_Support for D3hot and D3cold, wakeup events from
devices on a USB4 controller don't result in wakeup interrupts from the
Root Port when amd-pmc has put the platform in a hardware sleep state.

If amd-pmc will be involved in the suspend, remove D3hot and D3cold from
the PME_Support mask of Root Ports above USB4 controllers so we avoid those
states if we need wakeups.

Restore D3 support at resume so that it can be used by runtime suspend.

This affects both AMD Rembrandt and Phoenix SoCs.

"pm_suspend_target_state == PM_SUSPEND_ON" means we're doing runtime
suspend, and amd-pmc will not be involved.  In that case PMEs work as
advertised in D3hot/D3cold, so we don't need to do anything.

Note that amd-pmc is technically optional, and there's no need for this
quirk if it's not present, but we assume it's always present because power
consumption is so high without it.

Fixes: 9d26d3a8f1b0 ("PCI: Put PCIe ports into D3 during suspend")
Link: https://lore.kernel.org/r/20231004144959.158840-1-mario.limonciello@amd.com
Reported-by: Iain Lane <iain@orangesquash.org.uk>
Closes: https://forums.lenovo.com/t5/Ubuntu/Z13-can-t-resume-from-suspend-with-external-USB-keyboard/m-p/5217121
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
[bhelgaas: commit log, move to arch/x86/pci/fixup.c, add #includes]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Stable-dep-of: b1049f2d6869 ("PCI: Avoid putting some root ports into D3 on TUXEDO Sirius Gen1")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/fixup.c | 59 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 6ea3a64764b9a..0e9f26e236d48 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -3,9 +3,11 @@
  * Exceptions for specific devices. Usually work-arounds for fatal design flaws.
  */
 
+#include <linux/bitfield.h>
 #include <linux/delay.h>
 #include <linux/dmi.h>
 #include <linux/pci.h>
+#include <linux/suspend.h>
 #include <linux/vgaarb.h>
 #include <asm/amd_nb.h>
 #include <asm/hpet.h>
@@ -944,3 +946,60 @@ DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1122,
 			quirk_amd_nbio_7_11_disable_enhanced_atomic);
 
 #endif
+
+#ifdef CONFIG_SUSPEND
+/*
+ * Root Ports on some AMD SoCs advertise PME_Support for D3hot and D3cold, but
+ * if the SoC is put into a hardware sleep state by the amd-pmc driver, the
+ * Root Ports don't generate wakeup interrupts for USB devices.
+ *
+ * When suspending, remove D3hot and D3cold from the PME_Support advertised
+ * by the Root Port so we don't use those states if we're expecting wakeup
+ * interrupts.  Restore the advertised PME_Support when resuming.
+ */
+static void amd_rp_pme_suspend(struct pci_dev *dev)
+{
+	struct pci_dev *rp;
+
+	/*
+	 * PM_SUSPEND_ON means we're doing runtime suspend, which means
+	 * amd-pmc will not be involved so PMEs during D3 work as advertised.
+	 *
+	 * The PMEs *do* work if amd-pmc doesn't put the SoC in the hardware
+	 * sleep state, but we assume amd-pmc is always present.
+	 */
+	if (pm_suspend_target_state == PM_SUSPEND_ON)
+		return;
+
+	rp = pcie_find_root_port(dev);
+	if (!rp->pm_cap)
+		return;
+
+	rp->pme_support &= ~((PCI_PM_CAP_PME_D3hot|PCI_PM_CAP_PME_D3cold) >>
+				    PCI_PM_CAP_PME_SHIFT);
+	dev_info_once(&rp->dev, "quirk: disabling D3cold for suspend\n");
+}
+
+static void amd_rp_pme_resume(struct pci_dev *dev)
+{
+	struct pci_dev *rp;
+	u16 pmc;
+
+	rp = pcie_find_root_port(dev);
+	if (!rp->pm_cap)
+		return;
+
+	pci_read_config_word(rp, rp->pm_cap + PCI_PM_PMC, &pmc);
+	rp->pme_support = FIELD_GET(PCI_PM_CAP_PME_MASK, pmc);
+}
+/* Rembrandt (yellow_carp) */
+DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x162e, amd_rp_pme_suspend);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x162e, amd_rp_pme_resume);
+DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x162f, amd_rp_pme_suspend);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x162f, amd_rp_pme_resume);
+/* Phoenix (pink_sardine) */
+DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x1668, amd_rp_pme_suspend);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1668, amd_rp_pme_resume);
+DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x1669, amd_rp_pme_suspend);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1669, amd_rp_pme_resume);
+#endif /* CONFIG_SUSPEND */
-- 
2.53.0



