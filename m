Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021427;
	b=niNMtRy/Y4AieE8BoysoVwge8vBPGVIujmoiWBvZXmMPiJVpBoCpf6bUxTE4ty4oXSSg
	 Fq1iBlINzzHxAfdtrWoELT0MoT9YHQBWEi39XT8lWth+hxC+7s17bXibylh0zhAClZ0aW
	 U7zPDSpa0tfAvDsqRm+1IyVJ4ql/vHWNrZqRt9WaDMA3tZEhtD1izyvl/ESdBFfeFEo1o
	 KDuc1dJ5Dr1lSotZd9WTduRcuASKr31aOeiLQ2qLZNAf3rNG0NY9afkZoYu6vZg+nSqyD
	 5OYd/0ojmxauRcBlbl3qU/jHQck1BARxsAXlvdO1AylrYmwirZsyInTqQdx/kz+CMuA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021427;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CQH6q5peKUyBwXqhwhplRoUg9/tyaPCCjy2E6zBle9Y=;
	b=Jubm4aEMuPXWvIxpftcysAfa4E7xywA0y4vOIFkRFLo8B9rIN0gTng2uITopuNapGSDL
	 zBEE/+E34d1OdRT/jWpL3qeYBirM9KwWzaS+vd2Sfxnzuk6fXdT9ZIScIGLyVaJ8t0jeJ
	 Ej/DiFZvUSyF4+CbMvgRoUlpX5coMci3eKRyvKZ6otxvWBbnmOMZtwaUJUMFzh9tvTu4i
	 rRkNZ4gpy4+Lhx1m3j1jYPYCNMQtGltK78lY+JddxEJf1q9ADtLLNBsT8mYisSwobEP2t
	 GmGj/26ZUCWJ9etCaSZVciJVSpjz9HuSPt9Xa49Avl7apQgl8cRfjz24yK4l0gNeRnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gF5D+0Dv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2DE606A339;
	Wed, 18 Nov 2026 17:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gF5D+0Dv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 417AE1F000C4;
	Wed, 18 Nov 2026 17:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021427;
	bh=CQH6q5peKUyBwXqhwhplRoUg9/tyaPCCjy2E6zBle9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gF5D+0DvUx6C96IxBZZfimLANS4e306nS6muJQrQ774GPvkHQbYS1LEKTjv3yZObo
	 AKMUM+0SQQdOwErEUpZoVdZO7e4vNAn0pyXqFAvsZ7pQKtWzFQGPC5fWDiFZa7AvZk
	 eP3qXY6cW9Rkga912EzDbWttghAvGqa/DwscSAqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <shodan.ai@mcst.ru>,
	Dmitry Antipov <dmantipov@yandex.ru>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2302/2651] tcp_bpf: propagate error code in tcp_bpf_sendmsg()
Date: Wed, 18 Nov 2026 15:59:02 +0100
Message-ID: <20261118150408.078310169@linuxfoundation.org>
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

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit 82e31923c0553fdbfcddcd910ca07952880ca9b9 ]

In tcp_bpf_sendmsg(), the value returned by sk_msg_memcopy_from_iter()
is checked for error but not propagated to 'out_err' label, so error
handling may not work as expected. Fix this by assigning error value
to 'err', thus making sure that error won't be silently ignored.

Reported-by: Sashiko <shodan.ai@mcst.ru>
Fixes: 5153a75ef34b ("tcp_bpf: Fix copied value in tcp_bpf_sendmsg")
Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261019082214.102398-1-dmantipov@yandex.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bpf.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/tcp_bpf.c b/net/ipv4/tcp_bpf.c
index 2e234d155b5e6..0ce583f68d3b7 100644
--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -581,6 +581,7 @@ static int tcp_bpf_sendmsg(struct sock *sk, struct msghdr *msg, size_t size)
 					       copy);
 		if (ret < 0) {
 			sk_msg_trim(sk, msg_tx, osize);
+			err = ret;
 			goto out_err;
 		}
 
-- 
2.53.0



