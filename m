Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829441;
	b=cDAZaPigy+S3CkZBv4F6is0dmVCdB3UAb0vQvRAxLpqBFX/SvPGoGNh7kW2bUvBs3tmz
	 md7JXBugve1GDCm7GHDFWups2XcmaF2d0svQRfWdqGFpFzEHGKEE3/iLhSWLWJBwKw82F
	 w7m3UNOodDrQZ90Iwj9qfPDTGguoLN4seHDsD8hQCWoWcXQHhynXbGKvKtYGbj/n5a8Ag
	 sKVCFiJEGVgaCpY7ag3moG7FCGDkwz8ZgmlwVevF9nrlZQk/XuZs2qclKXZWuhRo0HvUl
	 dBj9yXDTQtd08IQ4INPFq0MJTM9w+rji1yrPugOC7Xn2+9JVqhH9sPDgu0UYCpzCFnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZFe2myoJdf3pxJn/2s8nOCE9jtOKpm1zsMTKqDTj2XU=;
	b=Q71iszShUWsLfj8qAkXCYy7uiXFwmAoWrlhx4wg074HJ7f6iAYGQH7Hh5EfbGzYYMW14
	 y3jYmRaQmJHcxQOV+xC6oaMeU/WWR8Auqh23qNcgqq8SWxvTFccAgdVsuuk37YqHl8nQm
	 8TlRgkuGARpL+i9YfDew7ZDmaceFhEgN6vZPj0Pil685mLJFe1ZRrZDueFw05+gl/1qrr
	 aNAgUKeJWv1NUzgTeIl+5VldWTJqPQA628qXwPOkObBYSola8ePLFGmnxpj3aglx3xIjx
	 4WnzLdaopMDpV/uMDjgV6XpiHVpL1mJF9BVwAFPP8c6mF2boucbgmwpcSlhBjHVPGPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZiJy+Bkh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5763606A863;
	Wed,  4 Nov 2026 21:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZiJy+Bkh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E63F1F0093A;
	Wed,  4 Nov 2026 21:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829440;
	bh=ZFe2myoJdf3pxJn/2s8nOCE9jtOKpm1zsMTKqDTj2XU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZiJy+BkhVMChVhnGbaj3nfxVqtqgQdQt4ln0pKVz9k0IpcGKSdz9f8tb+B4RevLFo
	 24AFFx2qmOH1ZTun5iJTYT3kLd/GMQ65QBYvTTExxbzDE/baX7NMXqgDQF8Je8BP27
	 0FeUvkYnrf0CsYbLMhC8TX22L+pnDLdP/hPEdxoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0127/1005] tty: serial: pch_uart: add check for pci_get_slot()
Date: Wed,  4 Nov 2026 15:57:40 -0500
Message-ID: <20261104211047.236854778@linuxfoundation.org>
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

From: Haoxiang Li <haoxiang_li2024@163.com>

[ Upstream commit 970ede67de0e3f6a1e707ec99ae49d80bf3f2966 ]

Add check for pci_get_slot() to prevent a potetial
null pointer dereference in pch_request_dma().

Signed-off-by: Haoxiang Li <haoxiang_li2024@163.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20260623140539.2272473-1-haoxiang_li2024@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/pch_uart.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
index c3f32e0590b7f..9104361ccb14f 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -678,6 +678,11 @@ static void pch_request_dma(struct uart_port *port)
 	/* Get DMA's dev information */
 	dma_dev = pci_get_slot(priv->pdev->bus,
 			PCI_DEVFN(PCI_SLOT(priv->pdev->devfn), 0));
+	if (!dma_dev) {
+		dev_err(priv->port.dev, "%s: failed to get DMA device\n",
+			__func__);
+		return;
+	}
 
 	/* Set Tx DMA */
 	param = &priv->param_tx;
-- 
2.53.0



