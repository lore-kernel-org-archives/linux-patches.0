Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057234;
	b=iGg9JKhIugvs2+WVr9taaLHc9UzVgRBbH9HhKrA79pbhkOB+rmPCkAKKMOuG2Y/FPZRF
	 8y5Tc8Dl14lg+rQ50HEtS7akSCyZBEHMsdIJDnMecdGuh5KYOOwJaJsJvjIA3neQDoDkO
	 hBHliPESZSj6eAE9YVibMg5K1SNFMPWnb476+oRWdc8MZ3Jk5jqlhDs5DXoo11iCOcFYM
	 mhoTP1anpbZdpPClEoAGNnYS/upWLbbLCVzh5ByClzJmwxfRw61zeCPrduI3HSHdyTSkr
	 VggdGazNhdUjJQSXwXuhPsewdaOYqjKauZrwzHM5ytLj7oQ0BQAhkmRQaR5jfieOReA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057234;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2hv0JlRpNl/IAwKcD+dh52TjkcbNkrCu4SuO7I5W6qs=;
	b=q5xZWxWhbbGac/JxDyQqC5A0smf2N5Y0utUG6nkq+bVD/cGKAjvhPhMQHqF90bMr4ani
	 qEzA/clh0EhmCwfZKHO/JwElIbEFnvsq30DJd9I+3Fom2I3oBkfb9NnvFx4xGXlavof+5
	 NTz9QuQ9xq41SRk8BHhk2xzm3BTyZWWEGFzJAhDIHim/BQCYg1qReda6PjFn7UL+tliVV
	 LEO75uk1MkhB+o56vliTV/JVbHTh9N3TANSlwctuhgGK/cQK0GHLGpVdd7/8atApk1fVp
	 PtnUjD4kwEfsc+6/5poULE5MZs27oVsKjtN4o3aBw2B6lj8NLRleJ27QhI0eKt9bW4w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k5LZohsk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4605E606A332;
	Thu, 19 Nov 2026 03:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k5LZohsk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986291F000C5;
	Thu, 19 Nov 2026 03:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057234;
	bh=2hv0JlRpNl/IAwKcD+dh52TjkcbNkrCu4SuO7I5W6qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k5LZohskkvZgaPh2KLOQKBZdBG4NItSDui7R4rKqKLBn8FTJaxBGElcvtvBtxFPgo
	 1MyTqwd7VGH/FOwMrh77w3fxchQFHm7hRW4bEicNzZXOQ3Frn8aTOAybbYU4A1i3Il
	 tlF+kGojEv4J3tKWds0XyPwAJU8wTsSyQNA9iafU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoxiang Li <haoxiang_li2024@163.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0059/1848] tty: serial: pch_uart: add check for pci_get_slot()
Date: Wed, 18 Nov 2026 15:34:57 +0100
Message-ID: <20261118145913.607225339@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 57581af8a2e16..3db29616c0207 100644
--- a/drivers/tty/serial/pch_uart.c
+++ b/drivers/tty/serial/pch_uart.c
@@ -700,6 +700,11 @@ static void pch_request_dma(struct uart_port *port)
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



