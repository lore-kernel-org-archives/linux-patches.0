Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060750;
	b=YewtwXt70qKZxdIsRJuuSK3V8TttJespYbJByXhuzlyPgobLhjhNERQVEUd6x5g1qgzg
	 IK5kihR3kebNE/lXavOtS+PMAW1Jo2cuiD9jfZq2meJkqhAZ3aFdzfum2RuZ/PWHul0jk
	 wySy25xh2r5OfJ9ady86SqiMfzMiQaXiYK1vdX9dQpwGAk7kHf4aQlxsEcH3hmH9VEYqB
	 SD/rxlrlBp80A6zxnxvTNhTCeCba8frAtqfC4yALHIxrVudNBbSmeGAhOQ76mV8SlehHI
	 XWsYJAbYsw+8dUipv4YorBynZWbtf5nh7E1TgCT/VUlGUTu2d6vuOE/h/JXN9EaML8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x4yAi1u/tkGA37LyPRZ+zgCiR+0O1j3vipPY4IOHvAc=;
	b=ZXc+7/Y5UChnowE3j1NRLrzY9UGAVEu8KSp0hW5mJVToSb07NiA8IarHxSx23i6V6omH
	 JAtQ3XBR447wCxPkCWrPJj4esD+NTgRnBI5wnOzkamb1lQBT4AW3MVybOWg2cUjido/SO
	 aUT/nhF0Xfgz3HjjVdYNIiADuB20cyFQF1MUIK2iVoyq61PQeYjhAn9Ym7HQVU8PtU0+u
	 CHKXKicN1xWRJMe3TOn0l+32T5RuQt8imTqlGF/c9+i4xP2zihxJjWUGUDijPvmba30n7
	 zVGLbeDKkfSYYwyO+XMtVzK7mk8eHl3dqDIo84OtpEdfCEiA2ty+kxOuSIxkFIJMr3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R4Y8mFyI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B916D606A32D;
	Sat,  7 Nov 2026 14:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=R4Y8mFyI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540141F0089F;
	Sat,  7 Nov 2026 14:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060749;
	bh=x4yAi1u/tkGA37LyPRZ+zgCiR+0O1j3vipPY4IOHvAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4Y8mFyI+T6zPaxY9qd/0UQChM5/2HwPageH/nXoeni7teVAgSISUxhbTGcqvVR46
	 d6FH3Kdfws5Cuciu5czLhy42LSgrIb7IrBf++q8PJ8S6zRXtn5beHq8pd096rwdDG2
	 6chpR/KhCcNlIqcVT4DEcY0L2TClxX8RNuJMPdEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0162/1536] PCI: switchtec: Add Microchip PCI1008 device ID
Date: Sat,  7 Nov 2026 08:36:18 -0500
Message-ID: <20261107135002.220908815@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Logan Gunthorpe <logang@deltatee.com>

[ Upstream commit 0d8a6306c680ee534be131e360f0cafa2bada7be ]

Add the Microchip PCI1008 device ID to the core switchtec management
driver's PCI ID table. Without it, the management endpoint on a PCI1008
switch is not bound by this driver, preventing userspace tools from
configuring or monitoring the switch and leaving NTB functionality
unavailable.

Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260714212010.230606-3-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index b093bb70b9d15..35f365d2d2984 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1875,6 +1875,7 @@ static const struct pci_device_id switchtec_pci_tbl[] = {
 	SWITCHTEC_PCI100X_DEVICE(0x1004, SWITCHTEC_GEN4),  /* PCI1004 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1005, SWITCHTEC_GEN4),  /* PCI1005 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1006, SWITCHTEC_GEN4),  /* PCI1006 16XG4 */
+	SWITCHTEC_PCI100X_DEVICE(0x1008, SWITCHTEC_GEN4),  /* PCI1008 16XG4 */
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, switchtec_pci_tbl);
-- 
2.53.0



