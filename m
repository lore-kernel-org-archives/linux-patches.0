Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528F435AC03;
	Fri,  4 Sep 2026 05:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501391; cv=none; b=TWxnL+dqNiaKPBmCer9MC6Tny8qHfbq0sLki6rXjcXQCfMAr2WSz/J1WB5Xan7lMk+4lS6W2dSvDuAWxE0r7VQTgghEwfxZIuPCr9v5Nl/iPmop2LjWKREvlkS+ZCcozdUVxIksAtcsWAA+bA05PWHvRjPrw0CcxHGFe8V3n5yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501391; c=relaxed/simple;
	bh=QjArBVN9KpXVm8FS9R/GphiPM2YeSWu+g6WviRjCNow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fitlUlAaW+f635vjzWRPzelmIJrAAWuYCcK1nzR8AKYJG/xKJuqnafJ2YCCgQm5NsyqJ3h+l9ORiiI551/m1/46UvGYt36boTSg/e58XAuN1IR7YnmOuRYv5jrjEFhOIHxdxrVkeWiwjyXTI8/9AmqTVWIFImZsomhIffnca7WE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ko1I+hla; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ko1I+hla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9311F00A3D;
	Fri,  4 Sep 2026 05:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501390;
	bh=AoWazLNd7WJClD9/Ri8Qduj8GgAZST7p8jkxhzvEnRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ko1I+hlaZunltYSTnA9ugAuLdiHMEz4wCc+2ArPMW14DGPXZMRfs5mWpIRJv1QZJ9
	 gu4/9jteiQrtId478H9ct+DZpdUKjqHXeYTgI097N6QWdqfCl4fjo4lrZ1Qn2cJDvP
	 hM4pCnMgIrVlZAyvp390lJD8Qb7iRM6F9Zhvz/Bg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.18 391/552] PCI: Add ACS quirk for Pericom PI7C9X2G608 switches [12d8:2608]
Date: Fri,  4 Sep 2026 06:59:08 +0200
Message-ID: <20260904045759.071772765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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
@@ -6210,6 +6210,10 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_P
 			 pci_fixup_pericom_acs_store_forward);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0xb404,
 			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_PERICOM, 0x2608,
+			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0x2608,
+			 pci_fixup_pericom_acs_store_forward);
 
 static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
 {


