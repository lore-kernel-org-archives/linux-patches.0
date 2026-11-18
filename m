Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027981;
	b=JJglpnln3Dn54l2YV4u8MT2ntTgSi7bL1dH8/ogY5Kk01tbbWPy/nTjJIOhAL8XNhTWY
	 BP+rPT8oIY2YDUN82k1ZTKQO1sntcdjoDk8zY1D23z1EeXzmV4Ukmd/r5T9eacDsXpUio
	 M8A1DLOrVYrDGUV6LZUng6Msq26AqIPZRuw2G5UE7IEglVyaCO0zdfVRKF2PXInjl3fG+
	 ZfSRFxkOBGZWWo8c8k61gW+pbANqkUI6zjNUj0E5YQx9cYOA4oBuvEBeGXpRfuZV0iO7m
	 v2hKc1E2x+KPia5twBFVfbMcOXPCTVKeFMSYnnZ5jofwOfNsQl5SbyFCcBNCl+pcMaA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BRB9FOvLktfboU5fLKn7OJ8M3Ga5FkDawVBsUF8/UxA=;
	b=vGIlulXtT9tWCuNuLXe9Az8p/rrcvCLuaYJm9xvaLP6zH8KJ+vw0HxMHU52ElzRKRf1K
	 XQ2Y7p/wSzTnLib1i8/JJGUWP45fum6nKgwSUO08gZIyM7uZD169fGJpjJdrNErcM3mJW
	 bfDk9dqOMEbR1Uc/vEWR39FERxTA+XEY1Tw+uG3/qQ1aWaYx+UKpYL3zX4KR+cUfUolbE
	 aYgz8NPuvwKUGEt9DYKioCm0Q+ohhxqiMDi3Cqe9fU/oiqo7DTO81QL1XeYw9OTK5Clj1
	 Iqez3o20o9GaapmjslJjdyV8KOvo2ineCSgUEiD36E2maggxoVtNksuMuOTODa0mNMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xfg9VHk8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D81F606A32A;
	Wed, 18 Nov 2026 18:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xfg9VHk8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF5531F000C5;
	Wed, 18 Nov 2026 18:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027981;
	bh=BRB9FOvLktfboU5fLKn7OJ8M3Ga5FkDawVBsUF8/UxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xfg9VHk8IA291v6+x2+O+uigHsWk5D3Y5dkuqJwfvTk1me7BhFJkA9NcP+6xpWNy1
	 EIezftLx3q1Pb/SLHRLz9b12VBs9Xy6SyA7RGjTej7rW92XnSvOWENA95LBi7BEqoT
	 vQn/C/btk5LaoSyqbhIE5sRINXozPncsEOW5bB9U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1982/2151] pppoe: drop discovery frames with no MAC header
Date: Wed, 18 Nov 2026 16:01:57 +0100
Message-ID: <20261118150233.935814993@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 0bfb048c291a3..f6ae4d8d84b0f 100644
--- a/drivers/net/ppp/pppoe.c
+++ b/drivers/net/ppp/pppoe.c
@@ -492,6 +492,9 @@ static int pppoe_disc_rcv(struct sk_buff *skb, struct net_device *dev,
 	if (skb->pkt_type != PACKET_HOST)
 		goto abort;
 
+	if (skb_mac_header_len(skb) < ETH_HLEN)
+		goto abort;
+
 	if (!pskb_may_pull(skb, sizeof(struct pppoe_hdr)))
 		goto abort;
 
-- 
2.53.0



