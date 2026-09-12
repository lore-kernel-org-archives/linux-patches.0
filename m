Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8E5352022;
	Sat, 12 Sep 2026 15:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227479; cv=none; b=HyDFqGx3J5pwQxrfKWBA4xyszKBKL/K4LIydu8m8oW992Pl/C8vnVaPbPF/iza5ZQOfC3AfHUcfP46pO6aRYs++1RmDmTDRBPNTaMYthhg3xsLfjHTAmDNo5N/ysnRaMyMd9/2zTVPQkbwKSloA6NB2G75zbESxHBkeuDS8pzx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227479; c=relaxed/simple;
	bh=L9WzcQAfzKp1tIV8kx/QPO1eDVUa5GzRutbJ0siD0Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZPENUZPGJ1LeB+9d+Qf848i79B9dpKab/ejMAi0RJC75Isf0qGAb+yiiCrwOF9VtU8kssz8XalaymaQlUyl0/rSX8oI6EFbhYBsG7eFQXzVVJ0Fi8cRd92SFOQ4EzypsNnwnDH3sMQx9wI6zLG7bchPdqyv+59KCUg0xiiRg80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u89anGkj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u89anGkj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E301B1F000FF;
	Sat, 12 Sep 2026 15:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227477;
	bh=9mlh0J+TJAAiY+gQEZ5kLfBY36STUCzW2dP6zYORLrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u89anGkjJNoHJapBIXIfbSCOS8LGVQdF8B9NWTKQfWk1n7okAlv8w8sepYsHBpNSf
	 7VE4certNhsat9B7xLa3Eaj7cl8W27O1Be4J2+LIvE3452BkfYl6hc5coU0yIUusTJ
	 Ccgxzy/5qofRWrln5PPQQKQ0QlZRhPVUz5Zzvrgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.1 0187/1191] PCI: Add ACS quirk for Pericom PI7C9X2G608 switches [12d8:2608]
Date: Sat, 12 Sep 2026 08:48:35 +0200
Message-ID: <20260912065552.413801596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

commit 062fb7f816439da6bf3860386889343482a66bd4 upstream.

The Pericom PI7C9X2G608 6-port Gen2 PCIe switch is also affected by the
PI7C9X2G errata per the errata document:

  E2: ACS P2P Request Redirect Is Not Functional

Apply the same quirk to this PCI ID as well to apply the workaround
required if using ACS.

Fixes: acd61ffb2f16 ("PCI: Add ACS quirk for Pericom PI7C9X2G switches")
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260720215718.2139510-1-tharvey@gateworks.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6106,6 +6106,10 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_P
 			 pci_fixup_pericom_acs_store_forward);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0xb404,
 			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_PERICOM, 0x2608,
+			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0x2608,
+			 pci_fixup_pericom_acs_store_forward);
 
 static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
 {


