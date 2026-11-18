Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028813;
	b=YEb7j2cjkbt/kAK86+UjHVQ2g5d7NrPaWgQYAMQnG9j9ysDKBmceF29qoFW7FRTFyGQl
	 8pkCt6vTpuQBUGs1pW+0DPPQ9tGuCn71mhSeD4vHkwLWR8hOYNccbUg7abNglYYN0DSlz
	 5kbbKUKIpciISpodm56n4U7Q3Jhp5Ss4KaYjYcP69qW+LxrmUxZ+DAQ1Nn/KBjPvXqdCD
	 ShPhx0dJx0Iz0KOo8tjSBByeUKsEXdLhPaGvIHPreWWH/ULpZBBVXzNluj8yjMiGMJOZW
	 5Ke/Xl4YTwrvTWMg0s5nH+taOYgC5822qDS1cr/mLlr6o4CuX8++kohZSilkbG5qcfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zIhtI0DyD/bqkjW8lPloE/xbXqF6v3xTQI8n2pUkdyY=;
	b=PwI7PSe1e8UHNCLC+30PhtL5uPeFbXLxOFrEuU/xYdXV9khfcKp6wp3GAXNupWOXeO5X
	 ack3vQPP8M/evsvLWKbwGC4WUcx0yAHP3xQJcQoGMNkfRNUqcCLU0TulbQyEzq9vcDw36
	 +/MST+myWvzjz1PGIKku3WhXDpmI2H/nQ/061aWX0Cv6U43eWfVrNqOEx20vsyJtRkjfi
	 GxkjD5rXal9oqPOrA8zMy/ldRfYKTow2Bm135Bz9Vp5KaTDAE4xAP3NCmNa3peikFF//u
	 m6bEUYrPsjuA/qqQeVRrZJHx1Zk8lwyXjPGDfKYC1P0VoxPEidP/h0tEi7EKbAx4FKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="A/EMIBWI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DD64606A33E;
	Wed, 18 Nov 2026 19:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A/EMIBWI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE241F000C6;
	Wed, 18 Nov 2026 19:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028813;
	bh=zIhtI0DyD/bqkjW8lPloE/xbXqF6v3xTQI8n2pUkdyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A/EMIBWIrvn1rAKSsbr6Is+1xSl8XB5IG0LTW1vquvIFz15aqw0OSuskj60/uD8UX
	 9dLgsA+OySXACuo+MSCoC/kSXfsnIzOnbVKGqwi7ELjqY6WRe/ha6RricNCJ9I1Ewh
	 z1o8FzF2URobejJEHvxPFdWDt4Dnl9Dma4NQCS/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0111/1756] rose: refuse an empty message when the Q bit is included
Date: Wed, 18 Nov 2026 15:37:18 +0100
Message-ID: <20261118150012.618981276@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

With the ROSE_QBITINCL socket option set, rose_sendmsg() takes the Q
bit from the first byte of the message and pulls that byte off.
Nothing checks that there is a first byte: a send() of zero bytes
reads the Q bit from beyond the data copied from the user, skb_pull()
fails without a word, and an empty data frame goes out with a Q bit
taken from uninitialised memory.

Refuse such a message with EINVAL before anything is allocated.
x25_sendmsg() checks for that byte too, with pskb_may_pull().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit fd8a23b811b7c46d0b9aefc2a45955ea8f685a8e)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index 1b5230ed4a452..2cb096068e5ed 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -1286,6 +1286,10 @@ static int rose_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 	if (len > 65535)
 		return -EMSGSIZE;
 
+	/* With the Q bit included, the first byte of the data holds it */
+	if (rose->qbitincl && len < 1)
+		return -EINVAL;
+
 	size = len + AX25_BPQ_HEADER_LEN + AX25_MAX_HEADER_LEN + ROSE_MIN_LEN;
 
 	if ((skb = sock_alloc_send_skb(sk, size, msg->msg_flags & MSG_DONTWAIT, &err)) == NULL)
-- 
2.53.0



