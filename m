Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032948;
	b=pbT+H0LhXEwe3Q5aaJxBce9OFEOu0C8mp8ulm7qDdyH6RvGH4jrg5s1L2l5Ur7tU/Add
	 fBQQQu3c4tlvMjJwVde3gQvP5ZRaQnLCAbMX9P3m+ba0zjHin5WN7/3DvAT6H813uXHgg
	 GXGc6arY5DJPtrVgbBuB/9PBYNnJrWdm/P6yhtSvDVP6RIQmOMInymz7rCUu/SvG6KKjC
	 DLue5dS86yQQV5ttGvCxYR0GiVpL8HLeO/y9pFf8KVokLvQH9dysu9hN/rj9PaO8SDikG
	 gVz3CYZK98OLurY67ao9P7TxCk40ZqKKaPDADBo8hjV+HAuBm7EW+o94JszE+N1st2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032948;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u9W4/jNqAQ2AKyijarOHyAprs7mZutWPS9tKkn63uW0=;
	b=pI8h5YII9k3pOavBeUuxgtjYiISKpjkXvyoh88b2pLGOpJ5Xxn7S2QX34Wva08jTeWLA
	 apY5f87cQ4P46TDSRTvFLKI/jZ5MPo4rYqAOyqbrIRRklfCO7fQkO2kq2ITkgl+4uI2/3
	 LwAIiNt0UruBZwn4htiOkCrHak9g/QQjew1T0QwXucG7nrJRFXYeUtauLbPyPZkHX8SiC
	 hdAFborWTXmPmSY4mWB2GY6SKHiU7G/DFGymm38D6wp6TLphJ17tX175AJkeeM9YaHwpx
	 Qv68wkj/vkD49GrzAbTqHrCjoC+e/dJnPtMF1BahPTi0u3BjvKWBRS8EBiQljTD5mtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eu3ATZxy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D85A60A2602;
	Wed, 18 Nov 2026 20:15:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eu3ATZxy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE09A1F000C4;
	Wed, 18 Nov 2026 20:15:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032948;
	bh=u9W4/jNqAQ2AKyijarOHyAprs7mZutWPS9tKkn63uW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eu3ATZxyNNqcyiun8r1Oa6AD7MZQXB7fV/jUERSxaV5TA5cy18HSiy1BY5oTF1e5I
	 4mja63tjmrImhsgAG94W9wOsX96YWOMyn6p37uWdw+v2Bw4ZWChyyjfoRt03GQraxs
	 /MFB4Mp0r+Jczb7Zxl/Za2yVaxNQjfpQU91tlV/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1592/1756] pppoe: drop discovery frames with no MAC header
Date: Wed, 18 Nov 2026 16:01:59 +0100
Message-ID: <20261118150113.312360399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Qingfang Deng <qingfang.deng@linux.dev>

[ Upstream commit 406bf2dc8d6d3e93fdae0b66d2ae99b6b62e479c ]

Commit 8540827ebac6 ("pppoe: fix reception of frames with no mac
header") drops PPPoE session frames with no MAC header to avoid reading
uninitialized memory.

Apply the same to PPPoE discovery frames, as both functions read
eth_hdr(skb)->h_source.

Found by LLM static analysis, and reproduced using the same TUN
injection as described in the mentioned commit.

Fixes: 8540827ebac6 ("pppoe: fix reception of frames with no mac header")
Signed-off-by: Qingfang Deng <qingfang.deng@linux.dev>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261023080002.221332-1-qingfang.deng@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ppp/pppoe.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ppp/pppoe.c b/drivers/net/ppp/pppoe.c
index 293b6fb1c1e98..97eb18dbc312e 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -496,6 +496,9 @@ static int pppoe_disc_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->pkt_type != PACKET_HOST)
 		goto abort;
 
+	if (skb_mac_header_len(skb) < ETH_HLEN)
+		goto abort;
+
 	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
 		goto abort;
 
-- 
2.53.0



