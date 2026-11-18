Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022716;
	b=DRzIsKebR5kgpH50zuMYKNso9dwFia/JEBJQOlj0CwEXMHWb7WDUiDxRV7m+ns8roxQx
	 kGEC54KIxgjkQTzbYP4BEoD0UCEn7M5Qh3TxbzVMZwY5e7t1arioI657EN0hBmzku0gDX
	 mIl3dBld2WcU/wRRT4mlvZTG5Zwg5KM3HryalG5ZT0cLZ6nu6OK5c8EwpiE6zQLKLHUE7
	 KwDsO/YLFigb51Z0jU61MowoRcYJfPfFWSKMPIeFOBbMALh754XGdL3mwHEA3CrnZazTK
	 oPq2tvP/tpzAmyeF2Ofedi0phh/kyAO3YE3AKqrtrNgCZ89m8ji9TpLIuKr4Mf5Q9dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022716;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+GfAlPaWDbwQipWVtPXiXlbf6LmSii5O7kErIGWRHX8=;
	b=AOzhn4y58ALs7pdQ8HrfVIzVXmdPhFn3x1/KhD2qmyTzhShfm7lzbbSWWUAN7Ol2e4DI
	 ATwVvkzbrZgGUwCe8nlb4I2BaBWSYvZOJ931kaCYeJ8Nse6qszoOBwnTUzUADpmi0XJ3i
	 2J/KScGQPBtMRuVOUUxZ25FpgxplKLQ2whXIPkok2swZ42aHNTLoZpclZzEe1p59UsWAz
	 rdQuxFs7wJZS+95TfllY0k+jT7qdEOcXPkA16dUawZ0ozAWd8MjF2n8njWmk0ayhhmUJV
	 4ZqLUYwEAx1b1I+IA5ZBgcgtPNTZt/I9S73iZ1cS3e8qseRwmIF8O14DtDpv3dRxPow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlSfgec9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2941C606A32A;
	Wed, 18 Nov 2026 17:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VlSfgec9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 814921F000C4;
	Wed, 18 Nov 2026 17:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022716;
	bh=+GfAlPaWDbwQipWVtPXiXlbf6LmSii5O7kErIGWRHX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlSfgec9pG5SaZZSuoNPZweWn3xKfahyEDokDzJBkMg7zgabQQate0I/9KRaCvyKT
	 HO26xmMl7hc4/dBjJIVrk1Yhey0zx54j/0X/eENi9qKBjcSHSZ2VCRLP8dgVQRLVC0
	 ICuh3xWFq2gur9KY+YEe4mZDuF7KUdqv4W9c6jW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0112/2151] rose: refuse an empty message when the Q bit is included
Date: Wed, 18 Nov 2026 15:30:47 +0100
Message-ID: <20261118150125.873726562@linuxfoundation.org>
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
index 52f279aa189ee..5a8585627feb9 100644
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



