Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033647;
	b=S8CgodLh4h8PeRre3OksTvgFoZyD2Mqgrh5mdZS1x78hSI7G8VOOeIsfFdeEtpM6vB2a
	 MUL/HkZv0lFM8ZxT6ihruS0Yg0AlTgMTTJqxyeCwFNU3DMHPh8kx/n6zcNaoBb1EVp/q9
	 yPVNoptbOaY9abSwo8eYN8FNxh0w/im8nEGdd5+NMSJxpT1gaFM2YISYootKS8MdHUFov
	 b/0J31v7FGFX5ghg1tqUqHrgiGlIq+8IO0534SkWL5ERMOTsOyaQOQz8zCutEf61S8SY0
	 n/HaKhpXeqeGLjV13ZJiqhkQ0y5swVVO/m3MQXIR+sNRNkQ31a7ngDSZeXWrGYrom6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8vlyPq/YnkXyb4hQFTC0IagdAVGke4XXa53010phB4M=;
	b=G3wYa26wO+f79+ZNRvQszCOdKjSzGoFaE6yg+jfSHZUnI41vjWyM0s9L8//E/DeVM1uB
	 n/cqXMux6RlaOAcSZsA7g1002TTcVXaJ9+WLabMV6D05oyR+jnaruBc9ASkXrZtKuh+nN
	 1baVz9/YfQhBl5px4aKtTc+UgLHIkk8SozWiaEzH67SUJQiBeltE3KrQIJjOpK7x+WFno
	 LHlbM9OzTSjdm4qvivMMDKZmbA/zrUQXre0ATL55O8+2v3C/tMb6EJaARCDCvsYLi1mjE
	 f2bLsVy6UmgOr3JVk/UcvgjwLhTCr6HLfvgzLRtmkgmgLDOzsm7qF6PEGol580lu/jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wApfP0Qa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3007F606A32F;
	Wed, 18 Nov 2026 20:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wApfP0Qa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834871F000C4;
	Wed, 18 Nov 2026 20:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033647;
	bh=8vlyPq/YnkXyb4hQFTC0IagdAVGke4XXa53010phB4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wApfP0Qa0qYLbWTtHWqAMGMzURD6sgnADlCXyti+7gCsSVdzXI0qaCzvyhnXdsAuO
	 r0A1uZyXv/v2wegtPnDv9OtsjCb8H2+mMUzdggL3pzdAwRTEphlXiA4+zblf5t5/AM
	 3qWaDLQrZ1XP09YMw7Or4Wb3smUysMn8qAed+J/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0089/3318] tty: serial: pch_uart: add check for pci_get_slot()
Date: Wed, 18 Nov 2026 15:11:51 +0100
Message-ID: <20261118150316.806878048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 25e88eb32a481..63df1e391d2eb 100644
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



