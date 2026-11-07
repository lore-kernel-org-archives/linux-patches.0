Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060674;
	b=MmmGJBrgDUJQ6ri3fUlW0Q7Xp9zZ7vpaAzu/H7Se0Twl219kXQcqRgtX4SW9j5KQGNyl
	 js1SxyHMnUJfjzq50WMqUnB3xHyNYC/58D6kIXEHqR9bi8bFsOLPiyrx/j498DM4yJllX
	 kTh/qfYsqGYfD1iVhsomE+Y+2lKLnNs8ckxrbp/PwBnDo64APUEwVJ6GCEvkcyeEhzV3a
	 ixvLOAp68GgzE251EnYpSlypG54bOHDIL687be8BIOHxJLY7WRjP/pzjsfWnvlNU3QO/r
	 /e9sZnARE7kq1VuBrzlcNrJnF1pEEbsWxRXs4icMWhK6NqPYA/ftueGCinazVUygeUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YrUVdaSQ2+TPaahr1dL/byLEdSMtj1J1LAzNEU8p9OY=;
	b=rnuOjgMqtk9CHet/kQjTGqYIGU/7E5pPnHUr7Q3aa0xjB0o0a3631AgFGWE61POdZgyK
	 F2Xsr61mOtDdebnqC7zHUIEx09pfjMJuuKSogbdk3RV7iMrxFp4poday7FX5X4gZU79Ea
	 kx8Zy1Ga6e2KBqmiraSGFaOLQtAF6WWsf6H/bRrybjgCQ5xGQI1aFXuRVJ953NKRwfhLU
	 Z9uutyeQg1r3cVvWUxEFjYVCIvpk4LNLjo6XSe7vMxyCtv1xy/pP5v6Yk39+VXleVxUB7
	 Gsq9k4DsScCXuoFCfBb1Puk/KAUz/DNa9sNgqruvvsh4MVt/33GlI8lO1RGCKiX4HfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7LD9Or5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30661606A326;
	Sat,  7 Nov 2026 14:11:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=h7LD9Or5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C77DC1F0089F;
	Sat,  7 Nov 2026 14:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060674;
	bh=YrUVdaSQ2+TPaahr1dL/byLEdSMtj1J1LAzNEU8p9OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h7LD9Or5Xu3cyYrIl4bwulDuxK85ZmjR8jBSF3c7GIcTY3jRkrMkoO4coAhbA6+3A
	 zBs6lcLPxLqF7pTrGhrAOv4GrQpYm3aXZKlXnRfU6I1hJ45I6GvedNiJEZnZ6iDuwy
	 qHanduHeBrGUnLctulBQAWYADhf0ZWPs6tJSbnck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0108/1536] tty: serial: pch_uart: add check for pci_get_slot()
Date: Sat,  7 Nov 2026 08:35:24 -0500
Message-ID: <20261107135000.708569898@linuxfoundation.org>
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
index 5d99f050aff0a..3f63adb6cd758 100644
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



