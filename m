Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829461;
	b=JkPHXfW8qLHoLDzM41OPfhUYhODVFBDaK2yjTb7+12qVwr7vs6LQb40IlnTx8GutEc3K
	 49yPSgx0EujCufbnAMW/Gm4did2oPIVg9PmvvjkSr9VdqRWeXMPCuanbRfw7bAlPudJ6j
	 xEoPdVIHKDw70SRCg8ZqO7BUpaswG+MqCmkUBY2P/581lsJcQBm6l8H8L4UTVs9ZRUL3h
	 diPCtrlCXnp9YnrUVph3zw+kkpTWL0CuAro+Jp0TskcUIH+0Qz3kBVY3vX94pF2w6fAnw
	 RdG6JlvTgPgoLCy7hYblZioX5S8Pw0toWdrYd9qSDyo749X84DqhPxtoVmzMeOpDv0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829461;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=goRNfNy4+/KyPRoAj4sDuUm1Ej5G4MAF9w9MxhxVqrg=;
	b=SZQgagAJuXSsRacbHFdqlF2CuSJ47CiuCpQesFdxiU0wG/YCRnhreVLWMX6Eecu3DgbQ
	 wEusE/dHGtXvUFgkp+EuQeVwTnoRFSUptrVeTuNTDyGji9aN9UcAnzu5Neb7rHX/yeH+7
	 ERPcNg1IZmXokaJHzw/IUKY0o50isNO8Cy7Rj+Lx+lATUa7sTjsAbp0jLssfzbSYxBEdT
	 fqY9svFWfKuBI7s4iq4hl6A31JgaxXwp64lFkMPedXaw/aQBbHvL6VYw3M1b47nxbIrNQ
	 3HrAuL1jj36IEfSHr72FRrjLdHlfbZKLQk1wDOLHkc2IICDOxCXO62/m71Rscibj8yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cs6tP4qJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7408606AB0B;
	Wed,  4 Nov 2026 21:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cs6tP4qJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471551F00A17;
	Wed,  4 Nov 2026 21:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829460;
	bh=goRNfNy4+/KyPRoAj4sDuUm1Ej5G4MAF9w9MxhxVqrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cs6tP4qJrbzby69y8mM7A3klmYalJAu1Hj+nG5Zou42VmTZTN+yGaROMHA7fxfaDa
	 g0RwIwBwR7pR5G6/INxrJyQp2JDtciJin5eHzaGdH4Cm8ZRtVfi6+S35uPVLoWLwxA
	 RrdYC+Cdez3xKxeeDftXnwMuS5WUTaAbWCIOdCXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0100/1005] mmc: moxart: report DMA completion timeout
Date: Wed,  4 Nov 2026 15:57:13 -0500
Message-ID: <20261104211046.439651866@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit e29e650077e01dddf69bc8fac31e0cd60043aa7c ]

moxart_transfer_dma() waits for the DMA completion but ignores
wait_for_completion_interruptible_timeout(). It then unconditionally
reports the full transfer length in data->bytes_xfered.

Terminate the DMA channel and set data->error when the wait is
interrupted or times out. Only report host->data_len as transferred
after the completion is observed.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/moxart-mmc.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 3dd8f232052f6..4a4d8b19b18cc 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -264,6 +264,7 @@ static void moxart_transfer_dma(struct mmc_data *data, struct moxart_host *host)
 	u32 len, dir_slave;
 	struct dma_async_tx_descriptor *desc = NULL;
 	struct dma_chan *dma_chan;
+	long timeout;
 
 	if (host->data_len == data->bytes_xfered)
 		return;
@@ -296,11 +297,17 @@ static void moxart_transfer_dma(struct mmc_data *data, struct moxart_host *host)
 		dma_async_issue_pending(dma_chan);
 	}
 
-	wait_for_completion_interruptible_timeout(&host->dma_complete,
-						  host->timeout);
+	timeout = wait_for_completion_interruptible_timeout(&host->dma_complete,
+							    host->timeout);
+	if (timeout <= 0) {
+		dmaengine_terminate_sync(dma_chan);
+		data->error = timeout ?: -ETIMEDOUT;
+		goto unmap;
+	}
 
 	data->bytes_xfered = host->data_len;
 
+unmap:
 	dma_unmap_sg(dma_chan->device->dev,
 		     data->sg, data->sg_len,
 		     mmc_get_dma_dir(data));
-- 
2.53.0



