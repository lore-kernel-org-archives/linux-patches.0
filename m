Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829549;
	b=VbD/Xp+K503N+xj1vbMds8WHy7HTMDXNBB1SMzEZ3AdLwhIwfcY/C5nuqBm0kT+VdQ19
	 +PUqaBG9S0awFtK6Y+FazkiJ94y1e1MKuyYTdn/3yswCyJCnOKJbHpAMUJafa+G2zXeJl
	 r741PQBn71LtpylvkGceqk37IC14Z6uFBJAjMwDzseHqTYS5PCesq4MwB7d+lQH5NofVT
	 2FokS7xIwMpBIiY1DPGBHYevqJwaZmsRG9rQQB7DX/Qk+Hps8FSTAMeACTLAWWCTx9cIY
	 iy+uTEePjE+Vc9wRiF68rgvG2VOOX4DshH+yKYu3Ecl+dkNANKsjB9x05NDOZKhnaPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2f1XjHUsGBdSCyxL4KV3EGEIZB5MV+EkhotrPu8x43c=;
	b=KcoSH30wahh8BS/EwNJ+sMZmOSNn2kFwNywlFW/omEWPQeLCe9AVkpPhd9mOlcjihGqS
	 EIsX3HBf/yXqrRildOE58yf0d1rajicg25xWlFdt2Waq3eu6QVZtzo1KW83gWoNYaglf/
	 x9fQTvO+Lz2t5CKljuMjiwBZoPYrLthImnsLKkdJA2xnJglqp/8R3vKwaauUYOpcXeY3X
	 CcjaHQFY7KSwBtJNwqNNC6xaW7/LHm6OraWA2mmBGMoqGG+h1igLL9Yp7GYH9Q4etT2NY
	 Fy1sl28UfvNVzKUx2ZMKP5mnMywXJ/t9JpnWjuooRFCMQWR/ev9kqfl7alhfgvGQExA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=io3SXKTo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513DA606B381;
	Wed,  4 Nov 2026 21:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=io3SXKTo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F141F000C1;
	Wed,  4 Nov 2026 21:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829549;
	bh=2f1XjHUsGBdSCyxL4KV3EGEIZB5MV+EkhotrPu8x43c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=io3SXKToDujPY4gUUrLWFSnCMLfy4aIO7klquABCQv8mq7PjZGIAOBARwyuQfcNU0
	 Ame+RJlkNubOd3osulkqlcOQCTG6cedWAU6UJJLrlVDDE2A6ojCoIKBRnJIdWUzZ6N
	 CXJoygvr1HI+U/CLbxYaHhCJQpmdB5hs9ykLZl4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0196/1005] PCI: switchtec: Add Microchip PCI1008 to NTB DMA alias quirk
Date: Wed,  4 Nov 2026 15:58:49 -0500
Message-ID: <20261104211049.288223546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 00a479ba1d01249d43ca5e453380d1ed60946f8a ]

Add the PCI1008 device ID to the quirk_switchtec_ntb_dma_alias PCI fixup
table. Without it, DMA transactions from a PCI1008 switch's NTB function
are not given the correct requester ID alias, which can misdirect them
under an IOMMU.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260714212010.230606-4-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e8067ff59e2a5..e03a3831bcc00 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -6045,6 +6045,7 @@ SWITCHTEC_PCI100X_QUIRK(0x1003);  /* PCI1003XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1004);  /* PCI1004XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1005);  /* PCI1005XG4 */
 SWITCHTEC_PCI100X_QUIRK(0x1006);  /* PCI1006XG4 */
+SWITCHTEC_PCI100X_QUIRK(0x1008);  /* PCI1008XG4 */
 
 
 /*
-- 
2.53.0



