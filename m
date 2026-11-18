Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043033;
	b=Zt5ofR5nsLh6Q3BWnEILU1cEmviUkbKGpcuEZnv79558DS7iD6b25fPs00R7BmXRZdbN
	 I0gPGeMm3K6axlZk/lbkUR0TBHKImsGVv0LYrs+1NYPo0H9F/fYKQ/rho04jvW+WFshod
	 KVT0psD2PNVIigGp9xRESj4d8WoQfrV+J/crFoo/O6atbWfOGecmK/OsSZBGbb94JijUk
	 9Kx8BLqW58lF8DWlCSw0KZSmTLJLC1toa31e9m3yWGqM2qDS28+qUjrqAaqD9sjaPV5/H
	 6kEFpYlU0EDRWFwg8xjlt41E/SMSQo2UU8yFUSE6HPVb8O0pGUbaWXIstS84qbuGLuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043033;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CJQX/eUqelb9MM0OpJ8BdDH8ZDAzmn3GGz7bGfanHAg=;
	b=0Wn/oR2hKmok7SYj5W32rddaMmiVGuno+sJnyfC7W2Jw5Lg7d3kuzumWZjRHT2lg/1VH
	 8iZ4V2OuHf43jdM8BlNYxetDLrLe8MlRSYsS8UXeh0JvwHNfW120oicJpWQrmZn8sPYJ2
	 v+YtOap9UPrDl+AGEeqokqsC2cV0tnsEmLmZpAlKqTOZmMczYA3oWQAvkpwEBAd6VGeJo
	 ypZsSwtXRE3oZ0fRQLpbVoiZsO/Ps7q4fkWlZDBByndfR0v94/NJHkICVS1GAA9ciHMLG
	 H3knPDlKH+0cZ9IE14YMqh3C0RtCw0dg9+s5j4JIO301a8k6x9T4brM+t+enLnPxklA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bZF8iE8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F2F60A3816;
	Wed, 18 Nov 2026 23:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0bZF8iE8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874BD1F000CF;
	Wed, 18 Nov 2026 23:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043033;
	bh=CJQX/eUqelb9MM0OpJ8BdDH8ZDAzmn3GGz7bGfanHAg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0bZF8iE8nqk8H/3VFT4h81ATIni4E/+qSXFncs60PMM7daupMtiRyyRxs3PTfH4zZ
	 Rzmamjg23upGA7sNdRapqd3a5DsUrYOOHk+F+LTLkL8NomxcuS6Am+4+GeBwshH6Cw
	 jB5OzJYQrMcyqKLXr81SK07c3rHja/DwJXb5gqrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0059/2857] mmc: dw_mmc: stop and complete DMA also in STATE_DATA_BUSY state
Date: Wed, 18 Nov 2026 15:18:13 +0100
Message-ID: <20261118150203.432637063@linuxfoundation.org>
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
index 0822493c949e8..c2920001510c2 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2209,6 +2209,7 @@ static void dw_mci_tasklet_func(struct tasklet_struct *t)
 			}
 
 			dw_mci_stop_fault_timer(host);
+			dw_mci_stop_dma(host);
 			host->data = NULL;
 			set_bit(EVENT_DATA_COMPLETE, &host->completed_events);
 			err = dw_mci_data_complete(host, data);
-- 
2.53.0



