Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994CC336EF5;
	Fri, 17 Oct 2025 15:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714548; cv=none; b=JGvmbfygo5gCgbeO+IZwOpx1gIaIflfl5vznodBQc2z46pWg/eTpystnWii7S5p5ov6c2UQ4emRSnC7ur3r7Cvbl1RDuv2V4OjSBDJ7+K42b/p9CeHIEinPw067tGEIR0yNbit0t2ANW27AU1hRKejIdotTXPi+uP36Z8Z1qwFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714548; c=relaxed/simple;
	bh=yDk5OGtoUODNdKhsKVzkyX3kqp4l8carmt1SgwRr/Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6mEbjQFQn7E5bCRI9gbBR0zNA6SS9es0hF8SXe0VkIqSjEO+XR0g9Zp8pJif0kbFycyr6K2++TcaTx0YJ0/lJG8ZGQDu/6pEpksyrz4aqAjoJRjQpaFLhR0PYKpxcRrfITedeM4owglq3QJDj4x/btQdaaMajlkTBTWWZapICU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtvLeXIM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtvLeXIM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA97AC4CEFE;
	Fri, 17 Oct 2025 15:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714548;
	bh=yDk5OGtoUODNdKhsKVzkyX3kqp4l8carmt1SgwRr/Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wtvLeXIMv2OC9Q+0orS9KfheCcPNxs6YMGcth/6dcwwAym/gVLZB5yU3WoCzHJPxz
	 4N3yeYuLzl1tF1JRj/4X5fqnhvvyktCxCvIamXm0aoRML2vt/lRqQkbe/IoXtrzhSQ
	 ntNSM6ywfdITPZdCt3aZrRP/+L4L2zV1PGvvtSqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Manivannan Sadhasivam <mani@kernel.org>
Subject: [PATCH 6.12 184/277] PCI: rcar-gen4: Fix PHY initialization
Date: Fri, 17 Oct 2025 16:53:11 +0200
Message-ID: <20251017145153.843324470@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

commit d96ac5bdc52b271b4f8ac0670a203913666b8758 upstream.

R-Car V4H Reference Manual R19UH0186EJ0130 Rev.1.30 Apr. 21, 2025 page 4581
Figure 104.3b Initial Setting of PCIEC(example), middle of the figure
indicates that fourth write into register 0x148 [2:0] is 0x3 or
GENMASK(1, 0). The current code writes GENMASK(11, 0) which is a typo. Fix
the typo.

Fixes: faf5a975ee3b ("PCI: rcar-gen4: Add support for R-Car V4H")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20250806192548.133140-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/dwc/pcie-rcar-gen4.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/controller/dwc/pcie-rcar-gen4.c
+++ b/drivers/pci/controller/dwc/pcie-rcar-gen4.c
@@ -723,7 +723,7 @@ static int rcar_gen4_pcie_ltssm_control(
 	rcar_gen4_pcie_phy_reg_update_bits(rcar, 0x148, GENMASK(23, 22), BIT(22));
 	rcar_gen4_pcie_phy_reg_update_bits(rcar, 0x148, GENMASK(18, 16), GENMASK(17, 16));
 	rcar_gen4_pcie_phy_reg_update_bits(rcar, 0x148, GENMASK(7, 6), BIT(6));
-	rcar_gen4_pcie_phy_reg_update_bits(rcar, 0x148, GENMASK(2, 0), GENMASK(11, 0));
+	rcar_gen4_pcie_phy_reg_update_bits(rcar, 0x148, GENMASK(2, 0), GENMASK(1, 0));
 	rcar_gen4_pcie_phy_reg_update_bits(rcar, 0x1d4, GENMASK(16, 15), GENMASK(16, 15));
 	rcar_gen4_pcie_phy_reg_update_bits(rcar, 0x514, BIT(26), BIT(26));
 	rcar_gen4_pcie_phy_reg_update_bits(rcar, 0x0f8, BIT(16), 0);


