Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CA01AF0AB;
	Tue, 15 Oct 2024 13:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997692; cv=none; b=aNIAU0MjreSrk0cIy3dQjosFhgV0Q3yJgr2BUyr4D30WE74n+GFVLsdqoB0wSMrGi+CKZCaPmPeIbyb/btqYTrBHU23uLJkrlGQ33Isgr552ZV9sJqI28PCOb0JjBVvst4ttyVwKvTpqSOi2CHbexqoJm48KgDXiSdCg2B+cjHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997692; c=relaxed/simple;
	bh=gWV9EoslgWTPoNorcXNnh7fzQEUHDHLkT2TAvCgBBkk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bh/I9QQz+Yts4JXjsHJuMxzHjQwShwx5KE2Jb2U1ca/ylj7/ZUa9POf6zq3pYSAwz2bax7RxU4CADSujDqucl4kpNayyWm+epSqJYo/ivGQ0EmsWELIm6/4AVll1CDp7nn3+Ibis3Zw1mXJF7JpiODwoJHsDNv8yS2M+KAwO088=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VbZkqfqB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VbZkqfqB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6081C4CEC6;
	Tue, 15 Oct 2024 13:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997692;
	bh=gWV9EoslgWTPoNorcXNnh7fzQEUHDHLkT2TAvCgBBkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VbZkqfqBFZ1QJaoureMXTC1CTK5TH5mndGI8LfRgpUudSOEVQM/PHfhZRRcpXqjpw
	 DpY2I8uiZb4aCVuOrbSWDL83t2cMpj1cye/spavI1UmBsY090tfPd5JyC/R5Qk7sM4
	 5CdlHgX5tnqaLPhV9fLjbzfv9IV83OrVbKOMC2D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathias Nyman <mathias.nyman@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 257/518] usb: renesas-xhci: Remove renesas_xhci_pci_exit()
Date: Tue, 15 Oct 2024 14:42:41 +0200
Message-ID: <20241015123926.907865055@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moritz Fischer <mdf@kernel.org>

[ Upstream commit 884c274408296e7e0f56545f909b3d3a671104aa ]

Remove empty function renesas_xhci_pci_exit() that does not
actually do anything.

Cc: Mathias Nyman <mathias.nyman@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Link: https://lore.kernel.org/r/20210718015111.389719-3-mdf@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f81dfa3b57c6 ("xhci: Set quirky xHC PCI hosts to D3 _after_ stopping and freeing them.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-pci-renesas.c | 5 -----
 drivers/usb/host/xhci-pci.c         | 2 --
 drivers/usb/host/xhci-pci.h         | 3 ---
 3 files changed, 10 deletions(-)

diff --git a/drivers/usb/host/xhci-pci-renesas.c b/drivers/usb/host/xhci-pci-renesas.c
index 96692dbbd4dad..01ad6fc1adcaf 100644
--- a/drivers/usb/host/xhci-pci-renesas.c
+++ b/drivers/usb/host/xhci-pci-renesas.c
@@ -631,9 +631,4 @@ int renesas_xhci_check_request_fw(struct pci_dev *pdev,
 }
 EXPORT_SYMBOL_GPL(renesas_xhci_check_request_fw);
 
-void renesas_xhci_pci_exit(struct pci_dev *dev)
-{
-}
-EXPORT_SYMBOL_GPL(renesas_xhci_pci_exit);
-
 MODULE_LICENSE("GPL v2");
diff --git a/drivers/usb/host/xhci-pci.c b/drivers/usb/host/xhci-pci.c
index 88f223b975d34..4a88e75cd9586 100644
--- a/drivers/usb/host/xhci-pci.c
+++ b/drivers/usb/host/xhci-pci.c
@@ -533,8 +533,6 @@ static void xhci_pci_remove(struct pci_dev *dev)
 	struct xhci_hcd *xhci;
 
 	xhci = hcd_to_xhci(pci_get_drvdata(dev));
-	if (xhci->quirks & XHCI_RENESAS_FW_QUIRK)
-		renesas_xhci_pci_exit(dev);
 
 	xhci->xhc_state |= XHCI_STATE_REMOVING;
 
diff --git a/drivers/usb/host/xhci-pci.h b/drivers/usb/host/xhci-pci.h
index acd7cf0a1706e..cb9a8f331a446 100644
--- a/drivers/usb/host/xhci-pci.h
+++ b/drivers/usb/host/xhci-pci.h
@@ -7,7 +7,6 @@
 #if IS_ENABLED(CONFIG_USB_XHCI_PCI_RENESAS)
 int renesas_xhci_check_request_fw(struct pci_dev *dev,
 				  const struct pci_device_id *id);
-void renesas_xhci_pci_exit(struct pci_dev *dev);
 
 #else
 static int renesas_xhci_check_request_fw(struct pci_dev *dev,
@@ -16,8 +15,6 @@ static int renesas_xhci_check_request_fw(struct pci_dev *dev,
 	return 0;
 }
 
-static void renesas_xhci_pci_exit(struct pci_dev *dev) { };
-
 #endif
 
 struct xhci_driver_data {
-- 
2.43.0



