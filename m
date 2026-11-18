Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043050;
	b=jk11FSCpMVjnmekyCDhoaEmNPEl2Eun18He/bsJrFxHkowZe/bK4Ki1+EmNQs/8PJrGx
	 iQvd+02CvFxpylFldc34G3GSoUp9G5l5vc+QSlKBq7oUT2ElTxflkQThLyYtvJcEKsHbQ
	 qQ0ThcKfroEpRH/qWvZ1Fw/oZ3LLtIgPeG+DQleBEl3qZ+WBdvhzPqQp3ypVxx3wly3Lk
	 31uCH66QVL7cnjD7ziE992olRtBCJNpaJ/fdgL6ThjE9lfbR8XxTBtJdtyoq73Qa3IbPD
	 YTzUuqDrsBNoQKHnj9bk+roSLTXXfbx+LmQ9RSJr/6DU0Wi/JYNc8KX2w/jiM4V1L2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043050;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vZUf7FSOkIcTS2bbEgIBgydkcEMfId+nWaEZN+rfRaY=;
	b=fcp0nXbBtYeNMC0y3qCoQklbEiSemvwd++3jRJojHbrqM0ACehKWpTThH4wDF9hxBtRg
	 KF99TNuGVDV07kSwjALipD5Vrfej947wozuJDVXMFAyKCNNqV3nnXJmhAhQ3d2yEr7vfx
	 l5dzlazazscwmB4yxAXf6JhS8abqGBnVAPI7Y3eDe+M6w3t5sQCxPOkR3PDNr8BskpU8A
	 kZSlewmZHVSRqWX3IDrtByKcncAeYu7sWgMI5LW2KQlfvog75bZ9w7zLFsHxy+VrWMHHb
	 qp/iWWhjLCeHK3pfLzkQlC4F37L2BKuLFAzjakteIPF4gwxIz6c80t9xbB0dpd/w0SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Om+TcnTL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09682606A32A;
	Wed, 18 Nov 2026 23:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Om+TcnTL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CB8F1F000C4;
	Wed, 18 Nov 2026 23:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043049;
	bh=vZUf7FSOkIcTS2bbEgIBgydkcEMfId+nWaEZN+rfRaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Om+TcnTLOtapPZQCogzJ7irA6vnvOdryaqTERUz8xZpNklE2I545YlqMZ7Bopaelz
	 BJ25cXeiWQjXBtxcAQYE5RJrDv8TQfsdjQ8YQmBDYwynyvK4KziwEw2Un438bWaahU
	 J4X5Ojn0Or7hRTdqUo1ImXmzi1Sc2Fu9YuwRQzSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0073/2857] tty: serial: pch_uart: add check for pci_get_slot()
Date: Wed, 18 Nov 2026 15:18:27 +0100
Message-ID: <20261118150203.943151734@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 89cdaeb49e6bc..d6681bb07ff78 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -683,6 +683,11 @@ static void pch_request_dma(struct uart_port *port)
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



