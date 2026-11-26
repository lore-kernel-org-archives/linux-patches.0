Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705396;
	b=MZHz4CQQ6k9EZ9N+eOp3W49SPvBg1z3ijrOwmAqQcHqVwyUSs+r1xqusvN3FuFxbOX5x
	 wm+aGACcaIAMINIyR8vC13bMnqfik2MufoB2AWZ3Y5Xh0ktT0WJi12b1Iwj6QkKgkM0W2
	 XI+kilO7PLzFLGz9q0EWmz7HwHrSSC/+YelQN14uzPGkQBOzwTEcFDSHqhsEuhhEAVllS
	 q5OzMwXDvnDMv3r5Q1tNNpAiUPPhAMv2a72yNXntwmX/mWqujRDBM/GifPDlognIrbfqX
	 H1ho6LUoMOLMG3jniKOTYVDAwnC7ePQQaNmhSavYRMhqOhC5WxKFqz5XRdY/g5B9Q6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kSdkYxU7bMSS0OSDPbDhuCd0pJV+cG2PfKkmvl+Dd1Y=;
	b=XW44Br7bIE2aJPKaYx5Ex2AZJyavHBma0l0EVjRx7xahRpdMr/81ROAqzlnSQGCcsEav
	 wuQFpdbux3t0sU5FHra20h9TtKbmUjzEZhEA5EtGw1qEm2boA246Y+vAZ+w5Op10HqsXy
	 UuJ65kcvqsoQDk27jkWaC5F07NKQyv902G0XJj3qe3SCnY1gescElWOUQ6Ry8i/do7vqO
	 UcXcaKcQpfS5UXvRXxhz4lryd+1bJ97ZuvvYwWb2cqpVR6ydv304LsBC+NaEQSc9fHYzf
	 2rJYD+DA8e2KvS/oYmGzQ5VK/MgtktslSTB58r1GQE52WgOCYuUpXoaJu9xxvXxIXpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmaw3X1x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F89606A31C;
	Thu, 26 Nov 2026 15:03:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jmaw3X1x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300591F000C6;
	Thu, 26 Nov 2026 15:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705395;
	bh=kSdkYxU7bMSS0OSDPbDhuCd0pJV+cG2PfKkmvl+Dd1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmaw3X1xkX1aJSNQ/1F1939B+GfFVZgLMMl7msW1bjKzZ8/aKvvbqjJf+UmzSoW+I
	 CHOvHzwiewvN7Xppx8/RkGRhOc5oyh+pgh5F+c6TwFRi6M3s1+08FdYdg+7weKpe7K
	 7FGscgCoibMj7LTTtU36r9NX0NpnGmrcYI+yaHJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davidlohr Bueso <dave@stgolabs.net>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 185/319] mctp: accept MSG_CMSG_COMPAT in recvmsg
Date: Thu, 26 Nov 2026 15:39:13 +0100
Message-ID: <20261126144010.921150457@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Davidlohr Bueso <dave@stgolabs.net>

commit 350e1d0d3b386fcc0cff2d37aa920fab4800bf72 upstream.

32-bit userspace running on a 64-bit kernel is unable to receive MCTP
messages on an AF_MCTP socket, even though sending succeeds. There is
nothing for MCTP to do with it beyond not rejecting it, as af_packet,
af_key and can/isotp already do, for example.

Fixes: 833ef3b91de6 ("mctp: Populate socket implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Davidlohr Bueso <dave@stgolabs.net>
Link: https://patch.msgid.link/20261105160704.2546031-1-dave@stgolabs.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mctp/af_mctp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/mctp/af_mctp.c
+++ b/net/mctp/af_mctp.c
@@ -148,7 +148,7 @@ static int mctp_recvmsg(struct socket *s
 	u8 type;
 	int rc;
 
-	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK))
+	if (flags & ~(MSG_DONTWAIT | MSG_TRUNC | MSG_PEEK | MSG_CMSG_COMPAT))
 		return -EOPNOTSUPP;
 
 	skb = skb_recv_datagram(sk, flags, flags & MSG_DONTWAIT, &rc);


