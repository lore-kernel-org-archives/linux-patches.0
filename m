Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829400;
	b=zCwqBdeL5WLMORqGPkxpn2sVvRoGLiE3LCyiBJxjdiqTdTqfDmMTsfMGex48x7+vezHa
	 OmPH5JguGUXpRrsevTGywU2X3yLc1ZyuL6rzop9lBY6iQuS4pBqM2FZC6Cr3cIKkXv7rA
	 qBq+CAFSCEn6sd40dZ1uDluLY5z03pFi+HF+2bSByu+UoasXmbZwfkyGX4hxt7fiOrVZv
	 QL6+vKzOaR97n0R1hQ0WldHSkqLHWWbMpMAu/+95WR/EA8NXKHY8Zq1SC0chG1NPLFLn+
	 kt634xxw4SQbK0l/ZpKDJQ+OFHuTJtHPeErlfrEmPzxerKklVAcp4MVIE4tR0ZjXxUQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=w4nlZ+HC7FTenhWRwDne09jSQnF5FqrmpEskBaJiK90=;
	b=G5qtHNjNC0PmkRjygn0YEVDUj8zqRL03pkyl5iONQ7soCUhS1UgEISHSu6eFNaYWBRqD
	 6MHbUr7K5vYeM37FUoZIt6KICPZJUz0rHMA/qMU1VqQT/2Mhw4j/UR8WVVdeRlKzYyEpV
	 0EjtBqOZI+J2+SwmI0Zr4QKo2nO/LUk7C0QlZIvHrTr3+9cnuhL2prp3RgP6kLoYJwAJ4
	 eP62FkwNCp3Wpj5ZntfPPrCHtmNzfHg7t5c1JeZyeGrONR+vFPJ/Wiq2NEZ7ceQUd/P4C
	 61wvgYrPbz8wmO8i7ieLAZAjOZbBdavv0I8nGKhj7goMMjbswjLO2IAbtSqfXb8NmSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F95Uq4Zg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0341960C299A;
	Wed,  4 Nov 2026 21:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F95Uq4Zg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAEF1F00919;
	Wed,  4 Nov 2026 21:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829399;
	bh=w4nlZ+HC7FTenhWRwDne09jSQnF5FqrmpEskBaJiK90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F95Uq4ZgIHA76XEwzfPdA8+ATpwIDUdTdArz9TAtAInqA3XNHYyOYqf930FrAe7tP
	 SsvKvPkwTb5yCVPHn/1GkJIMwdMT8kop9jexNX012wIKy2kfYGzHjynTBfjlqtAEbU
	 nXY2h5CHoDhyLr5kaVMvskrCsMWtORW+92AzLStc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0103/1005] mmc: dw_mmc: stop and complete DMA also in STATE_DATA_BUSY state
Date: Wed,  4 Nov 2026 15:57:16 -0500
Message-ID: <20261104211046.531495231@linuxfoundation.org>
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

[ Upstream commit cb3fcb8d118b874178251d1f02613f60d25e4ddc ]

When transfer was stopped in STATE_DATA_BUSY state, there was no call to
dma_ops->cleanup function, so the DMA mapped buffer was never properly
unmapped. Fix this by calling dw_mci_stop_dma() function also in that
state to ensure proper cleanup call when DMA transfer was used.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Reviewed-by: Shawn Lin <shawn.lin@rock-chips.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/dw_mmc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index c5db92bbb0946..90cc41901edaa 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2213,6 +2213,7 @@ static void dw_mci_work_func(struct work_struct *t)
 			}
 
 			dw_mci_stop_fault_timer(host);
+			dw_mci_stop_dma(host);
 			host->data = NULL;
 			set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
 			err = dw_mci_data_complete(host, data);
-- 
2.53.0



