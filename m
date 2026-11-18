Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044167;
	b=SWNnxn6zihqmcmkt9jWI5tYvb61LI330gzC1G3eNfGRyWb+LiXRmnKiOxz0gCRK+KQw/
	 km076ttu/NsQQ6A2w1Aw588h7xITvt24KaqQ6tg3V7/cTibNme/OUHhhIbD5c+eaelL8H
	 11oblVI28dcLWcOmLZ/u877YJHo0Y3kP0wkLatb8yFd9WYn1+T7pKGOx7JkX9Iux6lXH5
	 eVoGv1gTrM7jsnE+ZNiJ+DR1cHCaRW5sIW6rpb+qXMay8DVFi9UFuPD6Tm2NF+o0TBYF4
	 fkGLVBuXhEwvNBpnvFGGTynsgQI1wiXYUbDdwxzESGD/nyTL3Kb/DiaxhzrnTF1Nbjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044167;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0vfW0+IxBrDQFBd1aCLC0Pkox3zuRw83w4rvRT8GzTg=;
	b=YQEU3Fmc9nPsa/zG0lLnZ7PGvOgQJL/eZRqft7nd8m8pyb3PcQzP/YfXIMt1ObqeTxxs
	 w6PgyYcaBS+I4+AaS4WUOkUtrWg9Elb48s5KRgnz2idze0cr16yRWcvBeBxrCEXFzFp9j
	 xz+nnAAbyXphjUYYTyzZ4IIpiHHEvLfeF26H0uf3kg9wQ1LV+sfGiQeZnQAiR1U+GvFC1
	 hknihEleQ0+8DI5VQmI3MHn/i0avdyea6Ud/lbvhIceHsmwxraabFFRjMPPN0T9u5ExGN
	 4D5PGSQ/KeCk0XblkzsJZ/UF1sOYFqYPW+U977W8PhrMUxCQy8pQyF1qcLNa7Rzvjzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bnr+HG3p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A4D606A320;
	Wed, 18 Nov 2026 23:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Bnr+HG3p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5365B1F000C4;
	Wed, 18 Nov 2026 23:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044166;
	bh=0vfW0+IxBrDQFBd1aCLC0Pkox3zuRw83w4rvRT8GzTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bnr+HG3pZ2BgRjm+R8WsvAacw9a/AgaMdAs/3AA48dug2TjiTjiwS8x5wHmj8JDXT
	 JyreIP3U2KmZtb2pqkMRP/jpWCEOXAo51dcpO/2gSCxb48tAoOTSGWMgAQ5QkYXuwT
	 utzgEZxgoxtWLDXnmmTvo10/snSQNJQxFWpFcik8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Hui Peng <benquike@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0464/2857] mctp: route: iterate socket tag list in mctp_lookup_prealloc_tag()
Date: Wed, 18 Nov 2026 15:24:58 +0100
Message-ID: <20261118150218.144121646@linuxfoundation.org>
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
index 219ef18c596e7..40ab3f30e1457 100644
--- a/net/mctp/route.c
+++ b/net/mctp/route.c
@@ -773,7 +773,7 @@ static struct mctp_sk_key *mctp_lookup_prealloc_tag(struct mctp_sock *msk,
 
 	spin_lock_irqsave(&mns->keys_lock, flags);
 
-	hlist_for_each_entry(tmp, &mns->keys, hlist) {
+	hlist_for_each_entry(tmp, &msk->keys, sklist) {
 		if (tmp->net != netid)
 			continue;
 
-- 
2.53.0



