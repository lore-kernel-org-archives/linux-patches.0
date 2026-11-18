Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034829;
	b=j9UTEmj3D7teMiUBqOPnA491MxL+PozggYLcLS47vScP4GtVso7LTv+eD10Dy6z//Eu6
	 +2mBklmF1T3YisbI//DmT/lYKvY+/Wgm9CFMs7VD/FO1RGdkjNhmUwtFJ/WJ8iDJu7eeQ
	 91TfusUH6UEjcekeY16qlI4impnn5wciWVJU6ODzJBOnbFoRWNDbOHk0aaVYt/75WdUBO
	 zjiAWgQwEvM4xEMfWa+f3xM423BOCIdmaFOBUW16EglPaYa8fIZseB5yXEp3bKZeDgKxJ
	 8ihg1E3dfZ8DLaRdj4doLPbBWy68hKxD2p6R7Vq+U/1oQ9422lVzY2DBNyKMYPd0c0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034829;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I7AyqWPrtW0fO2JNJ0vQjtCy4iroxfamYa1ywKVDsKI=;
	b=CTqQShbXrG7GWfMgQZDStAwvl+CmwX1eImUjXykTTfvwr1TOwc2H0g4uTBbOJznvIe6Y
	 JM8rcG+Jst4sZddTZlNpc1YlowTaQ9sGDMPHFHMOBlTzmk5DJapsB2NhI3ca17hPzts00
	 Qo+fEklcpjOZfX6WeFV3LMr1GTSBKF3WTgWeZ8G/AwWNUgy2f2Brf+54HDHByXk9iogx6
	 7c0K5NpL7bFAeF2gTzt21h/udPY7fXNDkt0LhiVGIOfooo85jhGcSy/nnSbiL3piMQ9r/
	 4Gy7cZQb9WgnVt35vgjTxUCUARs4jLnKxnUqEV4N1fFh53ZJS21oqXINqT6MEp45PJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5bX3EtU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60F1606A31C;
	Wed, 18 Nov 2026 20:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5bX3EtU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E6B1F000C4;
	Wed, 18 Nov 2026 20:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034829;
	bh=I7AyqWPrtW0fO2JNJ0vQjtCy4iroxfamYa1ywKVDsKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5bX3EtUeobSmnofZue9j5EWfV6wXo+dLBmW1PQpwC/W37IkzdZgz5RlBEm6ogXBQ
	 9FAqmiYUKG3bEBWCKB671vHOIC7CObPkFLL5EiAs48g2iBzgVDzZYzs44tcj9PO/AY
	 +hYStIesgbABiC+ycRZ3/26mrM8Rg41sA6n2Owk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Hui Peng <benquike@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0509/3318] mctp: route: iterate socket tag list in mctp_lookup_prealloc_tag()
Date: Wed, 18 Nov 2026 15:18:51 +0100
Message-ID: <20261118150332.376873119@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hui Peng <benquike@gmail.com>

[ Upstream commit 26cc0e69cce062cd3aa6fae33074684669c35a71 ]

When a socket transmits a packet with MCTP_TAG_PREALLOC set,
mctp_lookup_prealloc_tag() iterates over the per-netns &mns->keys list
and matches netid, req_tag, peer_addr, and manual_alloc, without
checking whether tmp->sk == &msk->sk. This allows any MCTP socket in the
same network namespace to use and consume another socket's preallocated
tag.

Iterate the socket's own tag list (&msk->keys via sklist) instead of the
namespace-wide &mns->keys list in mctp_lookup_prealloc_tag(), ensuring
that only tags allocated by msk are matched.

Tested in QEMU against Linux 7.3.0-rc3 by allocating a manual tag
(0x18) on socket A via SIOCMCTPALLOCTAG for peer EID 9 and sending a
4-byte message with MCTP_TAG_PREALLOC from socket B in the same network
namespace. On the unfixed kernel, sendto(sock_b) using socket A's
preallocated tag succeeds (ret = 4); with this patch applied,
sendto(sock_b) fails with -ENOENT (errno = 2) while sendto(sock_a)
succeeds (ret = 4).

Fixes: 63ed1aab3d40 ("mctp: Add SIOCMCTP{ALLOC,DROP}TAG ioctls for tag control")
Suggested-by: Jeremy Kerr <jk@codeconstruct.com.au>
Cc: stable@vger.kernel.org
Signed-off-by: Hui Peng <benquike@gmail.com>
Link: https://patch.msgid.link/20260921051002.1656692-1-benquike@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mctp/route.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mctp/route.c b/net/mctp/route.c
index 53580774334b0..12a9e2af8cbc4 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -764,7 +764,7 @@ static struct mctp_sk_key *mctp_lookup_prealloc_tag(struct mctp_sock *msk,
 
 	spin_lock_irqsave(&mns->keys_lock, flags);
 
-	hlist_for_each_entry(tmp, &mns->keys, hlist) {
+	hlist_for_each_entry(tmp, &msk->keys, sklist) {
 		if (tmp->net != netid)
 			continue;
 
-- 
2.53.0



