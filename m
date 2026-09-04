Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11D62425899;
	Fri,  4 Sep 2026 06:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502683; cv=none; b=WS8MT2RF0tKCe7dnMg8dWSnAGwZ28FlkbtRfDGvf+OPTgE/Ht9qMzBANehwr7GPwjP68gNBU7TlxzgKvE2xSl6l6mUZXCDR70MXvaI8fSO61kHmJRA1p8z+Lj70DOyUoZsGfkANWrzynseFnFQfIHP3MsKtIC9CO7fQxWugnKnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502683; c=relaxed/simple;
	bh=k4xllYwQPbNEoTvsB/zoBzXBd226R/W8Hkcp3Shmbd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPJdzqe81/MIXFwL9Q6UgVoaVsDhOqISQaLZgA+OgOViCdYZxC3XqLMOSL+ZzGxWeAngjTsvOCFgPGQ/vL7XpLNly5RJTkfblFWvMN3tmcnsQuWBqrAEaxz5+lqctcCZrc1KgtvQpcbNl+0zJDK1b65aU5rLvOf4fu67uen3dzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nvE3ZpZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nvE3ZpZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ADF21F00A3D;
	Fri,  4 Sep 2026 06:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502682;
	bh=3QCgbQgA8KHevmKtNcZLZ5eTVmYodeZP5QPGG2qkiaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nvE3ZpZEr+ETMbywjQ9Fd5UHaM/wg+aKJXEIBdRqpA1Heyxaf8xfQxt6BxyC0iZIT
	 pIsN+we9QrAyFANd7eK+Ynfr4qd6Dwyp9KL1G6CsruwbirjB0h5OmzrTlxGy0Gv2//
	 w1MGVeaAda6e+WkEsDxxNRplmJpbFzQXZLw8EvTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.12 293/403] PCI: Add ACS quirk for Pericom PI7C9X2G608 switches [12d8:2608]
Date: Fri,  4 Sep 2026 07:01:36 +0200
Message-ID: <20260904045741.511497712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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
@@ -6204,6 +6204,10 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_P
 			 pci_fixup_pericom_acs_store_forward);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0xb404,
 			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_PERICOM, 0x2608,
+			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0x2608,
+			 pci_fixup_pericom_acs_store_forward);
 
 static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
 {


