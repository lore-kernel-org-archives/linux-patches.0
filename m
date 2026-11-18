Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795062191;
	b=PeJq+5+QpgnKWDBKc5ofpdbJ0yFeo++iXvKDzRo2x+RjAaPzfpMvgM5PqbcUyfzG0H+S
	 x7XlcL/pbj+ukx7wJ6VD6T3nhJQuKLHuOI5kt/tTTpgoo7vZ5FbqiP/4j4rWtUKgi/2kT
	 wrbVAD52jgumWgKl6yk7NKjEYi9DwKTvrm5mFH52UqkH337KMoEgRK7GjgAUSdqYqX1LR
	 r3YjFWkRAPE9D7WXhxCTnHXPVmjIh3JY1qmgoSA78uPBMd3/Ei+Z4Zv12wWqeLu9UvD+1
	 lI/yIh6uzg3fF3UP0oz+9ej8Oad7xWNxbxmBxMm0Ql/aQEpJwWZLAHWBCiannU/kMkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795062191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2Rig5mZrYwG7aIx7BveXchmiEacb5f3unw1rFLZXqsQ=;
	b=zS+JxVCekJG0csUTHfi5Z6xnKUQDztpjATVtWQ2GgOk2WxMQiwvTB3T38nDk28+sOk+Q
	 ibSUwq5N5JJmuVdYsn5DHN3Xj+xB0Wup9qXRKDu/P/tUsjSWkdCCjh2DBUHWumazcZjfF
	 XB0d9gQ55uE6bOiuBed/7L/h8SFBxXaZH/AQBM1oYKCskKO/p5MsfI2Rbq22ogY/gGxWE
	 otpo8hUoFsflTL7SO9VOeq0gxfYb48x0aY/JLnw8DwreVqBSjtkAl8F8exfRtAEQnoGVQ
	 xGbuOOt6JTQjww3NobuG6azmptPD2kSkIEgFZhRZMrrad8G8fixMKJhn7Ih7glkqhLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1KxYaZj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1F2606A330;
	Thu, 19 Nov 2026 04:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H1KxYaZj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4511C1F000C5;
	Thu, 19 Nov 2026 04:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795062190;
	bh=2Rig5mZrYwG7aIx7BveXchmiEacb5f3unw1rFLZXqsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H1KxYaZjsPTWFUXKWK/30qcfuSKjWJ1d4cmd0sqrY657hwLMB9N09Fz0Ju4O9Yn5f
	 Te/kZf7Q9/t+z2qDY31kGa51gZyj0sjOAdJVeg4M6W0G8x+fkvMyuyF5hrrGJad5Yi
	 x0QDW65fV780fseRozINTispgA1tv0mXXCDb6gf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1781/1848] pppoe: drop discovery frames with no MAC header
Date: Wed, 18 Nov 2026 16:03:39 +0100
Message-ID: <20261118150033.903706229@linuxfoundation.org>
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
index 8bd9ca71f4c8a..021dcc8118e73 100644
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



