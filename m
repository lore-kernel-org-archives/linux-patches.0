Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214102;
	b=VPMIbD2j4lKFSw5ZcQ/pU1gAqL8lTkRt7eg7YLTN62wOf6t/Rd+H6ByTD4dAJJhVzmK6
	 GtaRblpC6uV9YI2qUXjB2mEpiRlJp42lWpkCSp8r2r1BR9pdMnkfH+KI56yjX7nQxlvOS
	 kaRZZtyT8cfJRGckyw5eBxHltqmMlOS7V+fA6H2aRB9cOwWVRpf41oWDr5bwWA4OF2F2P
	 Dh9iEyiEzgkGWzN6iWzl/GpGaH3defDk3GDh0XbYdo/TDRoWry/CpVB2bdy/SMC5djVIv
	 zhwyOIoSf/CWIgwjMKX4MEFxTPtrOSDKQH3T9QZqJfzlfHka/X+5OVkj0a9SiG1UW2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214102;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gn2Z9u3Nx+wWYCqhc7G5CcXDjVINPKXSET2H5FlMU0w=;
	b=Xi3xj1hsmwZm1kqFphOQjsUqDiDvJ0RaipkYd97Tm79I4B40grOkdasEEYeVrYjZ9Lzz
	 NaHgYeDy+zTzrJLIDUJttzYVEXGdjuwPeSpzA/Fi6rK0NJL15LCRO7OpgU98FNB/u3vNy
	 n0WjLb5iAbodeOkiIoTomTB9m3gkHITbzKpiHa05hl15VXUgetQ6wtm2e9eQjKR8T+bH7
	 Jh7qa6DMteOOiacxC/bespAZIgXm7wOpn/IlcpkuYQqhe5TOaBqYhkIx5OEb8g0pMrSuy
	 fXKTjVmf6SQZ/XH9rE3gWmvII79BIjdu1+S/0HXXkFKcy99M8NLqqbRvJpGzBip33Ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=napDZGa9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BD14606A31A;
	Wed, 28 Oct 2026 19:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=napDZGa9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E2E1F01825;
	Wed, 28 Oct 2026 19:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214102;
	bh=gn2Z9u3Nx+wWYCqhc7G5CcXDjVINPKXSET2H5FlMU0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=napDZGa9ekMUKCK3iFKMy9p6KDeFWDYQ/OSOdZcY3Mglabx2kU16vMwGFgpAQaalc
	 Syen8pcVUK7Rh3XDkKP/86PQsi404MhzDMgmZiKydeqOdsnPZmWHERowPx/E7mLzNM
	 aZJsQBuZk6oaQB4xloUWI/oIZpOM9oU9zMKB2/Pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Georg Gottleuber <ggo@tuxedocomputers.com>,
	Werner Sembach <wse@tuxedocomputers.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0740/1887] PCI: Avoid putting some root ports into D3 on TUXEDO Sirius Gen1
Date: Wed, 28 Oct 2026 17:47:16 +0100
Message-ID: <20261028170516.285485993@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

[ Upstream commit b1049f2d68693c80a576c4578d96774a68df2bad ]

commit 9d26d3a8f1b0 ("PCI: Put PCIe ports into D3 during suspend") sets the
policy that all PCIe ports are allowed to use D3.  When the system is
suspended if the port is not power manageable by the platform and won't be
used for wakeup via a PME this sets up the policy for these ports to go
into D3hot.

This policy generally makes sense from an OSPM perspective but it leads to
problems with wakeup from suspend on the TUXEDO Sirius 16 Gen 1 with a
specific old BIOS. This manifests as a system hang.

On the affected Device + BIOS combination, add a quirk for the root port of
the problematic controller to ensure that these root ports are not put into
D3hot at suspend.

This patch is based on

  https://lore.kernel.org/linux-pci/20230708214457.1229-2-mario.limonciello@amd.com

but with the added condition both in the documentation and in the code to
apply only to the TUXEDO Sirius 16 Gen 1 with a specific old BIOS and only
the affected root ports.

Fixes: 9d26d3a8f1b0 ("PCI: Put PCIe ports into D3 during suspend")
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20250114222436.1075456-1-wse@tuxedocomputers.com
Co-developed-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Signed-off-by: Georg Gottleuber <ggo@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Cc: <stable@vger.kernel.org> # 6.1+
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/fixup.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index 0e9f26e236d48..7d06107ab9826 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -1002,4 +1002,34 @@ DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x1668, amd_rp_pme_suspend);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1668, amd_rp_pme_resume);
 DECLARE_PCI_FIXUP_SUSPEND(PCI_VENDOR_ID_AMD, 0x1669, amd_rp_pme_suspend);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_AMD, 0x1669, amd_rp_pme_resume);
+
+/*
+ * Putting PCIe root ports on Ryzen SoCs with USB4 controllers into D3hot
+ * may cause problems when the system attempts wake up from s2idle.
+ *
+ * On the TUXEDO Sirius 16 Gen 1 with a specific old BIOS this manifests as
+ * a system hang.
+ */
+static const struct dmi_system_id quirk_tuxeo_rp_d3_dmi_table[] = {
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "TUXEDO"),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "APX958"),
+			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "V1.00A00_20240108"),
+		},
+	},
+	{}
+};
+
+static void quirk_tuxeo_rp_d3(struct pci_dev *pdev)
+{
+	struct pci_dev *root_pdev;
+
+	if (dmi_check_system(quirk_tuxeo_rp_d3_dmi_table)) {
+		root_pdev = pcie_find_root_port(pdev);
+		if (root_pdev)
+			root_pdev->dev_flags |= PCI_DEV_FLAGS_NO_D3;
+	}
+}
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, 0x1502, quirk_tuxeo_rp_d3);
 #endif /* CONFIG_SUSPEND */
-- 
2.53.0



