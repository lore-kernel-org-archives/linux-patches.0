Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7028178CFA;
	Wed,  3 Jul 2024 11:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004570; cv=none; b=HJmuTpcYGe1VZrDSk3lytcINIc4dsy3KsGWchreddV2/De7Qc9papnuv7Brg4D+LiLrYJ4vRqanrpTsN9IYOKgUQ2on89wRZgfwzKO6iu+rY7p8EDyOXGN7XYx/efSH7gF13SC3zhJhA97khLtWvSACI6vsZXcamOUnods5qFKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004570; c=relaxed/simple;
	bh=gO/YlqrocMUmf5rNtSNBd5BmiWTdPQmm+LF08CvAwWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q1OdhdcVylh0Nx9SweOi5o6zVPazg9uo410kt9QEIcqMEwoyWWF7D8CGofoiVk9/nxsqewzFbhetuHXmjoiwM5f7FOK07Bu/gi7DZui4uRR3DyW8wbONiwYBGLg2OfdS1X6t7XLqMC0Qk54lQUfOrX38Ofnm30zwci5K/ELPi7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mBD1vyK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mBD1vyK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2B9C2BD10;
	Wed,  3 Jul 2024 11:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004569;
	bh=gO/YlqrocMUmf5rNtSNBd5BmiWTdPQmm+LF08CvAwWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mBD1vyK7wzarJdxHLAYiV98W0VkJGOJ0rzTQw4ILOl3LKjFSLZIC3DQd+hxSq80KI
	 omLxpsVr3N2IrHcn3/WEwFKPn0OeVUO+9eqwVdAU7CsqaqlqT1kznTmK0Qv/+4cKYr
	 gLCNcc4OMerIF+eh55U27wWqk+wow+pCKp8lN+jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rick Wertenbroek <rick.wertenbroek@gmail.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 5.10 084/290] PCI: rockchip-ep: Remove wrong mask on subsys_vendor_id
Date: Wed,  3 Jul 2024 12:37:45 +0200
Message-ID: <20240703102907.367588957@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rick Wertenbroek <rick.wertenbroek@gmail.com>

commit 2dba285caba53f309d6060fca911b43d63f41697 upstream.

Remove wrong mask on subsys_vendor_id. Both the Vendor ID and Subsystem
Vendor ID are u16 variables and are written to a u32 register of the
controller. The Subsystem Vendor ID was always 0 because the u16 value
was masked incorrectly with GENMASK(31,16) resulting in all lower 16
bits being set to 0 prior to the shift.

Remove both masks as they are unnecessary and set the register correctly
i.e., the lower 16-bits are the Vendor ID and the upper 16-bits are the
Subsystem Vendor ID.

This is documented in the RK3399 TRM section 17.6.7.1.17

[kwilczynski: removed unnecesary newline]
Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
Link: https://lore.kernel.org/linux-pci/20240403144508.489835-1-rick.wertenbroek@gmail.com
Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/controller/pcie-rockchip-ep.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/pci/controller/pcie-rockchip-ep.c
+++ b/drivers/pci/controller/pcie-rockchip-ep.c
@@ -131,10 +131,8 @@ static int rockchip_pcie_ep_write_header
 
 	/* All functions share the same vendor ID with function 0 */
 	if (fn == 0) {
-		u32 vid_regs = (hdr->vendorid & GENMASK(15, 0)) |
-			       (hdr->subsys_vendor_id & GENMASK(31, 16)) << 16;
-
-		rockchip_pcie_write(rockchip, vid_regs,
+		rockchip_pcie_write(rockchip,
+				    hdr->vendorid | hdr->subsys_vendor_id << 16,
 				    PCIE_CORE_CONFIG_VENDOR);
 	}
 


