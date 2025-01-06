Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6C219B5AC;
	Mon,  6 Jan 2025 16:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179332; cv=none; b=l80DL+moCcxtOpv320tMOe9byZHvZIjtEoFNf7X/kEUxrSbPzwCNoqAJNVjY6NnHcgqXrzeegrFO1dLRXkG2gpQ5wbXMaTXDNqQJbpaBX/NL0QozxujVIr2cyUMn8GEZ5mtsG4xNroRDtLr1EgrcUqCRmWx4JFheRY2p8z+h/ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179332; c=relaxed/simple;
	bh=YBRnbbETYGKrSs69xrOWrerPPdyG7vVTBTPKbO84Tc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pj6Et8D6MnleuYumnpsaUP0o3X+yVvAEAS7v4ThLlVBjz8xUUSO8/OoLXEd9DBmLvUB3HQ1HrFAqgBHlYsj9K+SHoIP6XiXLKCodX7cWr7rvpbRgRemVYov6PCdy5QwdnZiv9qPQzmLm1FrGUxDwEpY+Xsr5tQGDSmvcyqXDmPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PuPKx82m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PuPKx82m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31B10C4CED2;
	Mon,  6 Jan 2025 16:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179331;
	bh=YBRnbbETYGKrSs69xrOWrerPPdyG7vVTBTPKbO84Tc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PuPKx82mhcV5lnkq1KSyms0v+Fb7GTGL3hsF3SKkRhSQv1pRC0r/HaMYBdhZ7ZBBO
	 u19+vTP7hvbYoPG3wxpvNSoBgRQ+hcHJJVvhZ8wwARfN0oEy6e+a9uHro3VTf0zaN6
	 9pk9GkBx5QrIw0mJLgt+uG38JLodCCCRRLaxrR+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pascal Hambourg <pascal@plouf.fr.eu.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 90/93] sky2: Add device ID 11ab:4373 for Marvell 88E8075
Date: Mon,  6 Jan 2025 16:18:06 +0100
Message-ID: <20250106151132.099143465@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pascal Hambourg <pascal@plouf.fr.eu.org>

commit 03c8d0af2e409e15c16130b185e12b5efba0a6b9 upstream.

A Marvell 88E8075 ethernet controller has this device ID instead of
11ab:4370 and works fine with the sky2 driver.

Signed-off-by: Pascal Hambourg <pascal@plouf.fr.eu.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/10165a62-99fb-4be6-8c64-84afd6234085@plouf.fr.eu.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/sky2.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/marvell/sky2.c
+++ b/drivers/net/ethernet/marvell/sky2.c
@@ -130,6 +130,7 @@ static const struct pci_device_id sky2_i
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x436C) }, /* 88E8072 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x436D) }, /* 88E8055 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4370) }, /* 88E8075 */
+	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4373) }, /* 88E8075 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4380) }, /* 88E8057 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4381) }, /* 88E8059 */
 	{ PCI_DEVICE(PCI_VENDOR_ID_MARVELL, 0x4382) }, /* 88E8079 */


