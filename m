Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830835;
	b=CInbPwJ4pNYUA8EGYoyH/gdIGOSfIWpzOJAInPr0yN0rZjGr9/31CIMPXCqoPAWFGJJ+
	 KQfkZA2wWKzo4buqmL26Ib0825elI/2lE8ps5tyDDMogS7l/M1cGNHCk339Pw+j2NvZDn
	 Z6eqUi0MhKq47r0x9l9iQAU0E720ZCqtMRzuIDQNJLnCmz7HAitsFtZINoKFzO8gPKp9C
	 /lh3iGxRKcvkGIIycNnj7PM2xODToiB0TVzX2twk7DhaPMGJw9c/tm1Wf/Jynl8iP4uGu
	 jv8PfWRFF9DU+5tL23TWTfZtB2ab4N2xZlWmFStidJ9EXjNYIcFK0kNUc/Hiau2VrNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j/iLmTrEc03qFmQV+MD7wo5wWoWA05kA5oK4v5auTYw=;
	b=NIhMzO+4t0iZL4D8SwLm3g0C64L6yNaSbxtJuRuLAzzacCFYy6kenvlQ1DtF/ST5jXem
	 lkl5zRZL0hBci81tTzhbHroUk3Zs/335BK62foR064iQeHbo/4bgGnF2T490M3tKHEm0V
	 byS7cCGgP0lIwhcmFf9+7sm69Khl3iyThTehCphab2ocoVxJAmCGUa5rQfwE0xM89Rwya
	 q1Wvlr4BhzIjLP/tT7pt/QJN6EU1Nn2Fq4bYDViz9IjF5MjvepMbS9QLb/uEZysn7eKK7
	 ys9fQCzRV7xlF0kmdoLCCAsGKiNv2LyQ4WbDjyz5aNE39AEjXhfDjTam9XvIYd8w0jQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=swbLO9Dw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92F7606CA02;
	Wed,  4 Nov 2026 22:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=swbLO9Dw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394DE1F0093A;
	Wed,  4 Nov 2026 22:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830834;
	bh=j/iLmTrEc03qFmQV+MD7wo5wWoWA05kA5oK4v5auTYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=swbLO9DwAfbY3YwV9EqK9x6PTo8PNxpIJSxtWsduQ8opTWZ2YeNAvT8KPrkEJNfhj
	 Fa1qjOlmtD++z4wCcHyTfJGzB9EYp+5xrHx0xisBs6wGGDuxLPRIZFImzijP6ElEUF
	 +ekOm+X9ahTJYj22YSvtn1suml5SxHenRW66T44g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0310/1005] wifi: brcmfmac: Set DMA direction for msgbuf packet IDs
Date: Wed,  4 Nov 2026 16:00:43 -0500
Message-ID: <20261104211052.615181456@linuxfoundation.org>
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

From: Can Peng <pengcan@kylinos.cn>

[ Upstream commit f0ba5fd51ff23077ce66cb9be79d41a4b7c19c5e ]

brcmf_msgbuf_init_pktids() takes the DMA direction from its callers,
but never stores it in the packet ID state.  Since the state is zeroed,
pktids->direction remains DMA_BIDIRECTIONAL for both the TX and RX
packet ID pools.

All msgbuf packet ID map and unmap paths use pktids->direction.  As a
result, TX buffers requested with DMA_TO_DEVICE and RX buffers requested
with DMA_FROM_DEVICE are mapped and unmapped as DMA_BIDIRECTIONAL
instead.

Store the caller-provided direction when initializing the packet ID
state.

Signed-off-by: Can Peng <pengcan@kylinos.cn>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20260724092530.674624-1-pengcan@kylinos.cn
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 45fbcbdc7d9e4..de47d6b7e02b2 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -310,6 +310,7 @@ brcmf_msgbuf_init_pktids(u32 nr_array_entries,
 	}
 	pktids->array = array;
 	pktids->array_size = nr_array_entries;
+	pktids->direction = direction;
 
 	return pktids;
 }
-- 
2.53.0



