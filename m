Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051037;
	b=WESX8GL08HHhklSTwY20RbRjEVDoon47Vs4dXe6E8vnVPt8z0oIcbQBZZJEGeVLMNub/
	 +Xe8kmdvWkoWOcGTBH/olpKVTuvt2+1VhXtkdZLdB2A5slE+dF6fCl8QxRSQeOwqnXpop
	 Y339jmIHfM/toUF+oc8o+82OQkuhWQjrtgAHUm9heIE8k1NYz/VFaIgVwxO9Nhafv6Zmk
	 x26Z/9E4FxYCFieHCRs/9yskJs3NCAxkMgSmjeLkft4FdTtKtBq/AYi6pWbhq5sI2jCZn
	 S339PctCF6kd+EIXYQg5rI+c5hFEt5esKkRuFIkea7K9VKA/9KSu0GEk/OdJSLlNRjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051037;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qnQjLVgrOmwX3VPrL6vo+EQjS7hjTmvoXrNKUYGwbjw=;
	b=koyNeO3LDlbQzLkP3aphO3eTAP/1DqSvqIpO+94zC3aK29Sd9r7pzf8S/cYdsbI5kF4T
	 TS1TvWnVs+aLtbcqXeusMs6cwVrZGqVkerOiDShZlckKSHedEGQkqG9tVMt7Bdugv8WGT
	 htQsRZv/Ud15CkPUNB9LDPlXfKpLaVdEcoGxXRqzov5jtBDmEUqL27odav//pwNIuOl/j
	 QPgU8QooEZeg7lpfsmXJnkLj8lvvblx+QtkTWxROXhsyAlTTtuncDQJU5UcYTKMAPEKVt
	 bEkIRlnsUPM3MA/pFNqXd3qiXmC+Cfp/prm3ek66su32zRycmJBFGMwXWakwabYhmdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4bbujDB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C21606A31C;
	Thu, 19 Nov 2026 01:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L4bbujDB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145E91F000C5;
	Thu, 19 Nov 2026 01:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051036;
	bh=qnQjLVgrOmwX3VPrL6vo+EQjS7hjTmvoXrNKUYGwbjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L4bbujDBIedgI58ePWlSo7xOt01fgsdMB1L1rXe5wbJkcdIO9vy7X6He/DKuqGDhB
	 FSJZ00aNDO/5bnkToUd5afvtWIFHAJfnPYeQse8NWu5Xxmj0gy0mOOcBGphh8UlHZy
	 xLfHmQyA0ybpWmGrB8w47IoAtGbICvzrRbSCMSUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0066/2214] tty: serial: pch_uart: add check for pci_get_slot()
Date: Wed, 18 Nov 2026 15:29:02 +0100
Message-ID: <20261118150012.651693747@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 69d516463a179..4fb2ee240b17f 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -696,6 +696,11 @@ static void pch_request_dma(struct uart_port *port)
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



