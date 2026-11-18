Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033995;
	b=283TFmpXQi/qm60LsnPALoQo9BVzmcwHjQfwDEULgYhPgH4ez8mRbXjjheR3DmhI5b8T
	 ogn0m4nJtqn8yC4cIZfYy48iUaK/PzliCdgWU6ikwRKZh+Dg95UEwSZvtNdi93vNCJa1P
	 wErf6zMbBy0o5zOL+GrqIua4lCwsux2Aywd8Z8J2jm2ukSBPqpc9/rZXydQY6mtGk5wpT
	 i0Sa4ZI0LB33wNjn1VLBBKJUihjvOiajG5n0g3JmuwgTCSBE+XqLbRTXetZ+4b8ZzY0nv
	 y4z6Q7hXUkcyHe8IAnZ9Y1o7BFsGGZU2WDQpMTg2KYnL8O5NDcn5ihW52xYqaRC3hDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=36I/OugfUdcYgK1+V0G4kbYYVtyJhRReQdNu46bVFm4=;
	b=Shn+a5gkEhl1pb2EDWsMTOxAFhjhQYT6R3YTCSoLO+EKE/bPSk1FjEzsoXiZAugbY3L9
	 ieFz9b3JoSHZk+K1vf3hp7/oBQi4QtY6dRH8twWl4v7H3K7oSHw+HcIW8X+QaPMWJo0/7
	 U4MLfBAITpV0RP9WG+sJGUHoEWReqBEKhPis1YjLEnG5D2aqpUGbEC9oo3cd6p8Pbauep
	 VWRMULxQE+8KRdEY83OXLGlQr45aaSCgtJlAkFhmUmSp7O+uN/+wyxQ5DrR/jEQxzTUTk
	 FX2OpjLhpe65h1jm//AQgAXqq0iHqR2pdCdRJJqqQG/PEh6tQhq6UWSjVEVEQkt8jyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMHwwofx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA953606A320;
	Wed, 18 Nov 2026 20:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZMHwwofx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 458B21F000C4;
	Wed, 18 Nov 2026 20:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033994;
	bh=36I/OugfUdcYgK1+V0G4kbYYVtyJhRReQdNu46bVFm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZMHwwofxXq51k2XV6fxtgzB2llaJfWJLXKLzWLwPQB+SVFwKBB7cLRlR5bLNy+r/M
	 LEvRZMq7+xy2J6Jh7+1rhiJo0fzXzu7k6lt7t5ZyB7ZgqDhlzXpNZtgK1xLxtCZiGJ
	 oyvtU3Ra+dKuH0mSCtavJBDdu4YTXSrnRoPnxdCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Peng <pengcan@kylinos.cn>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0213/3318] wifi: brcmfmac: Set DMA direction for msgbuf packet IDs
Date: Wed, 18 Nov 2026 15:13:55 +0100
Message-ID: <20261118150321.330565657@linuxfoundation.org>
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



