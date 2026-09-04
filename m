Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C1B351C35;
	Fri,  4 Sep 2026 05:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499749; cv=none; b=MiAqk5QIc0aTTJB3UXH95RkISK963BVLlXVwayudOZm/RLX0P2hBxV8v1g4oJBhaT7ug9L9p9j7Q06c/iDWYsQYkPAuib9uve45UHczQOJTajMTVhrnr4mcYLdsHLVUURgSykvcOj8YB7xzidiRKi7NMQAH6iJO9Fzo6efmtM5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499749; c=relaxed/simple;
	bh=dZgW2E/lNiyMkePumf0rX8S97vOYteYOBn8go55l7kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ovk1/aTsSr1LDFto30g2LMdlQGdlSzMkrtCGuJx+6/agrvNiUrSeL9hUVqQMo7FOaVA3U271CysJ/z0giKwMXZJiDYuNLBXjx8BvsOFMuriyIvLxsxi6d+Pr7blmIC3AaKUYn8wiipY0eD6a5Ishx4GATu0OTeFPb9xC11g8rZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4J7H6r9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4J7H6r9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CE71F00A3D;
	Fri,  4 Sep 2026 05:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499748;
	bh=L88YJaCfnC8I5kaZAAqauQ8TuGJ/0uUT9GdaaD0Oz30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4J7H6r9IAFeSFT7z1eJNyLh8KMpW+3t071/lSlF422Nd3grYvF+k3HJE1cbRAAqF
	 QdrF/Fmf+vbRf4BaRDwvTmWzrQDkjBkXzX2Zfts3g6AXXVlzuLRC3F6ANk4UK4m41Z
	 ciGeKIeIY6H93r9qafKxiivEuR0ncrkhyvJ2LShw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 7.2 526/713] PCI: Add ACS quirk for Pericom PI7C9X2G608 switches [12d8:2608]
Date: Fri,  4 Sep 2026 06:58:14 +0200
Message-ID: <20260904045815.610450304@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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
@@ -6263,6 +6263,10 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_P
 			 pci_fixup_pericom_acs_store_forward);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0xb404,
 			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_PERICOM, 0x2608,
+			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0x2608,
+			 pci_fixup_pericom_acs_store_forward);
 
 static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
 {


