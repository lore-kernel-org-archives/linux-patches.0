Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021967;
	b=noXmWGjZwwWrd3nrVtWNHO3Oc0C3zQW5sYsJyp6A7+aZxWFvhNn6U9soXi2093c98Y0i
	 5A0MSV5QepO4VOjVPJbBx5vJ1TblCeR7bm4xOp5umiRj6rmLGZTcgPyuuUvrP6ZuuMtH1
	 72bjIlBc5zThaickspwNa2+RMJbjlj4O/DiOmnKbvhdWbFnnncQ8qqRLD2jf0jkyHsoxH
	 5s4HHg8miRC39pV/WG9MJZscZe/vRB3wUuWFlADmHMFf4SPEK18Ors7ceLpctz1Jf1tE9
	 RpWgb0QlNWKk/KOZkbzQXrMG/UT3qSTZO5mRljk+JxPQpGXDgiLEViXwbs9wqtA8usw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021967;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JJj+YJx+7rreApxwkiegAcxKeo+v6JUmBo4yXrTNLFs=;
	b=qCrS5BDa6vU2+kW8u7GquT4vJYizfBZlY7herw/TcLg2RWIfPRy1Cj8BPzgJUky6AViz
	 n+SLSLm+ty2Zsa6IuSCY5FQgW7QriLLOCPjGR1G5nDq6M11flHd8Y6uLpgV1y+RIOG2r3
	 k87TK/HSjNqkdmPKjwYu/JTvcJpHszUIUJpMN9bWd+QrphjMLipU9vR9AMYc0NRQFF7AY
	 GxKNNw/zaAy+767aStx580oZuNz28HNhHK0psgIGxRhWBoW5oWG4VqMKN92kRXvFU2/Wp
	 IzRIwTg7bvMr0Uf4Husj4MgYz005DZowKWLFORdvI54UqCCspiipb/mv2GvIaAUPAHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEzHLRl0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28EA3606A330;
	Wed, 18 Nov 2026 17:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AEzHLRl0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 818A81F000C7;
	Wed, 18 Nov 2026 17:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021967;
	bh=JJj+YJx+7rreApxwkiegAcxKeo+v6JUmBo4yXrTNLFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AEzHLRl0rFH14YsD+i1hZ4C2aBV1Xn1VywTD0RoB9hlTapZyZViZOHW5FOLsXc7K+
	 xT0Ad/xcPYLRO5hPQLNlntFiGQh08Sx8X7nOdy04Nfp4mzmDrSgl94mqZyFiwTSgPG
	 Ri4W/P0yBMAwA94D1CwYEiz5fPJTVvfP4KOomCVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2454/2651] pppoe: drop discovery frames with no MAC header
Date: Wed, 18 Nov 2026 16:01:34 +0100
Message-ID: <20261118150413.436601687@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index ee0e318d6a2a4..bdaa8cf8404ba 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -460,6 +460,9 @@ static int pppoe_disc_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->pkt_type != PACKET_HOST)
 		goto abort;
 
+	if (skb_mac_header_len(skb) < ETH_HLEN)
+		goto abort;
+
 	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
 		goto abort;
 
-- 
2.53.0



