Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060696;
	b=0tUzqaej4ChepcQzRu40oyZuPLZpNQxyjlSayRMskWOCDL+9R8xeQ11sTuQiMIgnDtio
	 qF9Zoof2GGsTEGiM99Zsz0kP1JLv1D3Enzf0L3Z3HdWcanxVLeMOT5L6iST8AoAxOpYEo
	 iR4nod883UllFRxYhIQQtHrBVUdkcg0qcxXgJz5hAo3sJIHo/p/39HVm4CpbDfb/XSORV
	 AIq/kyKb9lyZT8QDg/b9q2TQtyTfq4zhBoPYgNdUZ84ATnCHzVQL00QTpLSOMoVKlYZyV
	 OvPkKqzHsEOK0j7ABIU45Y6/QQ29COxx/qWJdgneCgDit8hPONLFqP+dwkeyXGN86QA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Nzl0fe9dcyAJ8z2t283hCX7B8MmM8ftmBPsKpq1Py+I=;
	b=O2zkLczAmHJRP0UXDPYm1FA5MtuADW4sqM+xGBs33yn00NHRtqqtZBJ3RZ8ln/gjJ1z6
	 GGL9rz/fuk/ovN027d5MWH1EZ7bC47vVEfkxqA34zsCFwosw7VXKONGpZyuTXbyqAqsZJ
	 qG7BeIwjMZipfq2Hgw3LoCyq7e42VphuZ4RO7T6ibh69QLe3Y91XeqnHr9MBwORrjKUOU
	 yPTM44i6TFZHDiUkuja8YbdSCowdZyhPqrO5W5Pg8xJDMDV3/ZOkvOmaS80s4LZeH2LsY
	 6i833/iybCvGAX2b1KQRuyPyNoRbX9JWq/qxJcPNPDfTqP6HNK5V2ktB4z1P8Q+ttSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLbuAcA8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45CD8606A326;
	Sat,  7 Nov 2026 14:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cLbuAcA8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999741F0089F;
	Sat,  7 Nov 2026 14:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060695;
	bh=Nzl0fe9dcyAJ8z2t283hCX7B8MmM8ftmBPsKpq1Py+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cLbuAcA8VdWMD3uX2rM5cxKYxJtjTu71SEqaPqFrrUTsdURlzF+IH+r9+xGcCWrfW
	 2VSrOQE98Ik524/TYqTYS0w4sEGhlj+8rGHe0w3ghLWg+BtuKIKcY0kjwXSy3J7iSS
	 3XM9wYdmhDJFBk4sL48lPmIZ/DrLGusnu6bzdOX4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0085/1536] mmc: moxart: report DMA completion timeout
Date: Sat,  7 Nov 2026 08:35:01 -0500
Message-ID: <20261107135000.059608254@linuxfoundation.org>
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
index 8ede4ce932714..3fa591f886b97 100644
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



