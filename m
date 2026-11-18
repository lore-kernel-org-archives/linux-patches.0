Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050542;
	b=DWvKZcPkDJhjGoEZdSItzJQrwagLDKfHn0rakbzMAPBgmz0V2/3IB/CSP4KZKqNfU4l4
	 9NnWa9E4fjiXXR4BGFXKq7tUdNz3ossJ+ozewDt5lY+6RQiQhJNfCZMXFyuugT66PxHFw
	 P00EVdc6I69rKetUSkuh2jjhoBl8+x8r4Ok5X+QmPwtZjDVyPQd/BNuv7+ERMyuopmLgs
	 kR9MWt6nKjOf5jCkmdogyMxLh4JFQHLt/Kp5J4ZWxOUqRzs6Sfgoak+4aKJH0OptW9/Vk
	 hOxCDYd3lf1nNdTXlDMI6yLdFrKJz6AYizVIuWsn2pu2yuD580eANuqVoPVCRtWbV4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050542;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nLeHX5HvA0olqsj/+g0zSYjvQ6uPVwnYzyYSfW85e6E=;
	b=0WzYRSIStdtLqfBhhTvEevu/WheZG6P555YcBijc7XNULOeJK07WGJYJ56NiWLH23Ryc
	 4blQ5WIMe22qt82+xXd4T8hIvrnNiGUd3TmyvKBg4btXv0PLZKO0LP0qqwCaKTE80uVBV
	 RC2lfVS3ehYNCQUV2eyyrD3yxIYpWUWbTpNkygDfRamS9NklpYBJ2Nqm5EUBosAT5Z7hJ
	 89vy1XBeXtCATYbSbOrltG+dlgGjGF1Gi6qCgrnPvgiwoR8lzE69c3PqFn2xyTyRSo/g4
	 QMd8DDwvW+W76RKU+kguJnyNGIbtJ8sQ+/XBfkKx72qItJ0d3eaG7BoYKQ9rKeFfBpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teuE0wZP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC376606A31C;
	Thu, 19 Nov 2026 01:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=teuE0wZP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 574CB1F000C5;
	Thu, 19 Nov 2026 01:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050542;
	bh=nLeHX5HvA0olqsj/+g0zSYjvQ6uPVwnYzyYSfW85e6E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=teuE0wZPH28ya92sb6QpHx0k8IvbTR7aBTdvtmGKaU77oPl9bo33kl/McPwCKCfBT
	 f5UcV8Kydy53hwCUUDbZQpQdKeW+yJ25YnQfzKCNl2sCD7syrbcZ8hYfJOqqhehIIB
	 DEfYCQR0Cgtsl21qwj1bqDe1NcsGbBlS0eF/vVW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <qingfang.deng@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2744/2857] pppoe: drop discovery frames with no MAC header
Date: Wed, 18 Nov 2026 16:02:58 +0100
Message-ID: <20261118150340.418831063@linuxfoundation.org>
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
index 49758d9b075a2..789c9d8284ee1 100644
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



