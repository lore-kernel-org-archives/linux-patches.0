Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056841;
	b=kscfaMak9Kpa4E6oZZJc1L/dhKzDlT1LlCS/GEVQ2tS/lIQ2EE/+wq02QJqgHsIfKOTD
	 +6Y8AIKMCAbE7VM1FG9NN5g6Y+aV6f9LsJabBIlH5ZFHIuhO2Ho0MgLrIbyF/L4XvmwQf
	 WQdlTxMHXNM0zKUdhonNB9r9FGcjeVFjtCwC7n9ouPBJgGf5oDhAv8j/DxLQNIk5+Xvjd
	 60dPs7UIN6XoxOIn3VlBzCgt9cjKv31ql0a/I7SYPeDKCzs4k1dEJ84sG8ms0In+RUqDz
	 yUkGkxJW5oYc1/xGk5jcZ+b2erBFuPydi1h3u27Sqc8h2F7+9kWN8aqdumrfY+esjJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Z5O3Zv06KcuwxoGeWJCbYd7bSWODIyXDRCW6Ds/W3c8=;
	b=hVytmW8x+NO56W0EY/dibfJZaCYHO/htFjVKnfDOtDEA7HVQVvrFHIjNxb0Y/bIrPi4W
	 RoDpdcq9lOJGQbVF2vPs+AEmKbA5V3eKxM2+oOGl5/TGZLXsnIqqapzVfcCRkiIT6YX9Q
	 VMnWGQIysUBWsh4aq1Z/OMZUBRRAK+eRcVQwTm62rZWapA44+hD+4w2UABUWzdrOUC7L3
	 DKFsf3MLZ1kDiFF3tpOHD7IOYRPcEaVmJMmuV1p1qbCUNUYFwrg4Fy+UQv2DXAKOEtgCr
	 UkdqUMydveTZz6E+c3u1UnyZaZiqF7R7uC1DasLhWEVq/ex8B1Jsi6a5uyGluvHfkeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BavkLxOn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA5160A2612;
	Thu, 19 Nov 2026 02:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BavkLxOn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6B1C1F000C4;
	Thu, 19 Nov 2026 02:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056841;
	bh=Z5O3Zv06KcuwxoGeWJCbYd7bSWODIyXDRCW6Ds/W3c8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BavkLxOn9eRNvRSuaW8CwwZGad0nnLx6pftoVJ7w773l+8YO8DFeSzIFLFWPFZbrL
	 /B/naJCK6ToT0DldXtvQ/P08btHlIeg2xoDRGVn5R5LA6FChegabkxCFGVwQQnAAaO
	 8yFdMIByFHFbjPuT3rl3tNX6Nijalv4OCw25jVds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2132/2214] pppoe: drop discovery frames with no MAC header
Date: Wed, 18 Nov 2026 16:03:28 +0100
Message-ID: <20261118150135.833934792@linuxfoundation.org>
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
index d85202e8cbdc1..43cfc6ed4354b 100644
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



