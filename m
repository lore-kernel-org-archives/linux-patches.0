Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36ED42D739C;
	Sat, 12 Sep 2026 13:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220662; cv=none; b=EveYtGMzx97FcgF2LlzmTZR8jKMLCVnQbeNePHbUnaWM8PS+rwblbteXUgHgq4jDcPDRFxyIcwpUmapvt/rydA7/djTahS6uC9fAUbM0gzmEYsZ5a84kIZi0WuiHGGBqD90xOqik2Af/IFDi/3zjbDYAjoQN+NHS3mX0eyLGy/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220662; c=relaxed/simple;
	bh=fHJcYDK5WpbvJOXoUZtuRL1dR7i6/nf9MN8CDItbWGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t/BxGwed6RQN1uGIAIa0swAgNassb/BT5zB+mHwJ0z7Tur0KE3ng9MPZWllImvf/eoX7y61mzcNieBVbLVrJaFtJ4uT07sdkyj8w4zDsLI+Wmekxwtpz1HdQEeDvyIfkWCerR77T4Px1m/OGky+HC/w63u3Fi/BhlOEJukycgE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvOG5apa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvOG5apa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E3F01F000FF;
	Sat, 12 Sep 2026 13:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220661;
	bh=ak9poYXvgQu9wJFN/qxtOPJFMtbWUJjJwnHL/nRUtyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kvOG5apajbhHtfoBJJ7BOcnpv9ECJGFeRTyxPYGn2i2qvtm6LN7CHo/qqV8B1CZAG
	 A4cXokf9KcaiVVnTQA0pRg8ggfm5VzEjPJPeCS4rZ393YOsoVPc8cSTOWyChl+Y0fU
	 BF1UFMK3DyoZyHoTovpxQF5ZP/7lc2Yq9IYmF414=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 6.6 0224/1424] PCI: Add ACS quirk for Pericom PI7C9X2G608 switches [12d8:2608]
Date: Sat, 12 Sep 2026 08:44:16 +0200
Message-ID: <20260912065612.302415956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6203,6 +6203,10 @@ DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_P
 			 pci_fixup_pericom_acs_store_forward);
 DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0xb404,
 			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_ENABLE(PCI_VENDOR_ID_PERICOM, 0x2608,
+			 pci_fixup_pericom_acs_store_forward);
+DECLARE_PCI_FIXUP_RESUME(PCI_VENDOR_ID_PERICOM, 0x2608,
+			 pci_fixup_pericom_acs_store_forward);
 
 static void nvidia_ion_ahci_fixup(struct pci_dev *pdev)
 {


