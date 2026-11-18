Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051014;
	b=eiRozQUnE/2OxdNftuD6LiJfhqczp+4ALlIaSvjAR0gLrstojnjwLNRVtVwg9lfDeT1W
	 wtHzSgvdz3JKYxvhB3OeWwazR+ui03eARitXhTB4ydq0aRdzp4FuGtZSTZlUVf0a3wYbE
	 MmTPyE0WQkYStSy8IELZHnErcxi8X+jlwmSliHrs/MwKRytiMgncSQ2G6SeJ/Lg8R1Sof
	 RQCJKNYNfTwXXgxjfVZ+3VRmJ96iBQjvS1axZJ3UlHfabp2Bum7GLOOw+/fNCDqHFHIIw
	 jnNricG96boFPDh8okNa8fodNygmtR9l/Rle54m/Fh8lIB6oIE4IGhz9ul9zSd+FZjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051014;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AArEMNTi+jlVynGUdgM+JdAxze3YClq+486mmCNas+w=;
	b=mnB6EbPNPzCSvd/L16XLaJklHlWTuuJwV367+3MeM3rhaQ+5hiAmwnXnEVe/blTc3aGy
	 iYnvHzU1WcmTcgnrJ7zSRsTm6gP+XPwciWnNusclwf5wzTnJTK9cswbXTTCk8J4v+BWI+
	 fVILJze63UVsQmL7hGiNsQfXfkNsxfrlHReg81dPy+3SOtGyoog0UXoFfN3eFLUL3jk5T
	 v0J4qQZTFDVzZ1LCYRLlnmlxzwGC004B4JBlGOhPWbhFeGziROjbGc35emoQ6moIl/ILA
	 xnyBEYqKkxIKxhYbhyN307+BqBaQdsnCQ9FrtyUuRfR6hSvgKM0t3KnZIza0BdCptgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNlMRUSM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D263606A320;
	Thu, 19 Nov 2026 01:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GNlMRUSM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF54A1F000C4;
	Thu, 19 Nov 2026 01:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051014;
	bh=AArEMNTi+jlVynGUdgM+JdAxze3YClq+486mmCNas+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GNlMRUSM+T7xa+8GwJc6ki8zAKA4ci5qW4PD62iOzI5+imOcB7D8PwX0c6EAorQK4
	 rSyPBGccBzk2v3y3/fgLwt5QAVl+FO9FGf3IS61GQczjP1VZTINU5xz2zhv+NQzZTu
	 NrO1MJrA8echJ/oP+Oi9RmYTx1CfWe2VlVeLgHPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0058/2214] mmc: dw_mmc: stop and complete DMA also in STATE_DATA_BUSY state
Date: Wed, 18 Nov 2026 15:28:54 +0100
Message-ID: <20261118150012.346481504@linuxfoundation.org>
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
index 32927e66b60ca..b3366a3633dee 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2177,6 +2177,7 @@ static void dw_mci_tasklet_func(struct tasklet_struct *t)
 			}
 
 			dw_mci_stop_fault_timer(host);
+			dw_mci_stop_dma(host);
 			host->data = NULL;
 			set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
 			err = dw_mci_data_complete(host, data);
-- 
2.53.0



