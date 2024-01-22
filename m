Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B962B39AC0;
	Tue, 23 Jan 2024 00:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969813; cv=none; b=N2lrQQSuiZuaoOHbE75UqZaqgZx7gL9tl6yJh+OB6DYQIXjVFBZCjtNI2/9xMpL3Frr77QcZT9jUE06IPZiH5sVUOPvbpJAPLZVjbK5GqsqMpKxPlGRd64Ob2YlOCWm/1Dy1rMjKcQyNUaYaj+Jtoc9ohiX34nk1nQR6DBAiHs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969813; c=relaxed/simple;
	bh=8sfcjKGjBC9d2ie1m/VLYS3zqQs88uyeE26EMK5MZPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJdztjKy83PSR9JozM5hPRJl//fxoijZMOhcHJ47FRC5SwVSPxO1gUoYl8pHKueimPrPXUig+1DsiX02FDBvE3AD/N/e9BNzdEPv1xPFmkoeb4anzZeBKJ7cbIfp/Z7+t0do7TzM+u+j/rHqeZzMTMtNbAQrOSZZoMzg/CFDH5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrE5vbsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrE5vbsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 795A0C433C7;
	Tue, 23 Jan 2024 00:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969813;
	bh=8sfcjKGjBC9d2ie1m/VLYS3zqQs88uyeE26EMK5MZPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrE5vbsRMHC+EgKbPPVk5MgGT7fCBr5UwSGX202eg9uV5GUiLE0+xjAV+FRAdoNzM
	 QJeuJM+kCUKrwL68qoWIpEYrQ9N4LL3GFQak53Pam5CV6NohN6cCqJpaxb4hLKfdrx
	 nXecY2+baFtdS5E+y5rcCnEgwGKEfi6C4oD0SmpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tadeusz Struk <tstruk@gigaio.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	stable@kernel.org
Subject: [PATCH 6.7 466/641] PCI/P2PDMA: Remove reference to pci_p2pdma_map_sg()
Date: Mon, 22 Jan 2024 15:56:10 -0800
Message-ID: <20240122235832.626346157@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tadeusz Struk <tstruk@gigaio.com>

commit 9a000a72af75886e5de13f4edef7f0d788622e7d upstream.

Update Documentation/driver-api/pci/p2pdma.rst doc and remove references to
obsolete p2pdma mapping functions.

Fixes: 0d06132fc84b ("PCI/P2PDMA: Remove pci_p2pdma_[un]map_sg()")
Link: https://lore.kernel.org/r/20231113180325.444692-1-tstruk@gmail.com
Signed-off-by: Tadeusz Struk <tstruk@gigaio.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/driver-api/pci/p2pdma.rst |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/Documentation/driver-api/pci/p2pdma.rst
+++ b/Documentation/driver-api/pci/p2pdma.rst
@@ -83,19 +83,9 @@ this to include other types of resources
 Client Drivers
 --------------
 
-A client driver typically only has to conditionally change its DMA map
-routine to use the mapping function :c:func:`pci_p2pdma_map_sg()` instead
-of the usual :c:func:`dma_map_sg()` function. Memory mapped in this
-way does not need to be unmapped.
-
-The client may also, optionally, make use of
-:c:func:`is_pci_p2pdma_page()` to determine when to use the P2P mapping
-functions and when to use the regular mapping functions. In some
-situations, it may be more appropriate to use a flag to indicate a
-given request is P2P memory and map appropriately. It is important to
-ensure that struct pages that back P2P memory stay out of code that
-does not have support for them as other code may treat the pages as
-regular memory which may not be appropriate.
+A client driver only has to use the mapping API :c:func:`dma_map_sg()`
+and :c:func:`dma_unmap_sg()` functions as usual, and the implementation
+will do the right thing for the P2P capable memory.
 
 
 Orchestrator Drivers


