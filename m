Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051624;
	b=ju7XpxdVSuOID7eQYXfIvqXWuXmYCq6kT2BocEZ5+iG52PgoGKDISeYf5Lnkx9ZU7OH9
	 s5jtgJmPb/kZQ8V2mAbz6j7KIajibmpHoS2LBjiXWlO7b+/c0XvOfIUYlnO0IYYX+NRm1
	 dSApp1mPLC6dZ8m6USE7fj8CLj3iJ6JTrtaArb8EkZsdDNZDQDBfR2R8DiTeIkgA5iWkv
	 EY/0tjYJOGfowb080KtzwJbWQOtkHeg9zeXCMvZOLoESOJSkymjXAsNbGA7L7GuHc9jf4
	 KrNZVvstosHYFTYzje/ffd1QhVIHdni/PpcP7ze4IJA+nfS8Exnp1IcLri3reA8XMWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051624;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Cr4Dd70Msuqf7Of3VRfsD1nGsnsm0AT5r0nfv0DI6c4=;
	b=elQvAHA8BJkEAxXb2Do/oq3O4hXtDTzqnDtg2Fba+NpjDJmX1Brkv1H7dwMZwbQv1/Hs
	 RUNeG1mAouL4JL30yjwMcjED/0YoNj7yuKedlIIbp4rZAsLJZNhQVtGvD8IhGR7iPij9n
	 Gk5JFehVwIqwOF2LZA2votVjPXn1oUJMlf+LoMvuoaHtoeVpdjTYhVzFn3/j9uet0Rwpr
	 KUUNUtMfVvDeD5NjGRm/w5MB59Z8f4Q5ZaMisgMp1msWXqTr6ZgVVosrKxk2xywqxjIMc
	 rbH7gPiOfPmwwDt4lTZHAjmQalzJ1qxBPUFhTLHYga/4kYDp0/LYl4wPKtEZccgAMXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O73kdPW2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED382606A325;
	Thu, 19 Nov 2026 01:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O73kdPW2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555FF1F000C4;
	Thu, 19 Nov 2026 01:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051623;
	bh=Cr4Dd70Msuqf7Of3VRfsD1nGsnsm0AT5r0nfv0DI6c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O73kdPW2YU4+Y1U/OcIWkZPcTT6KZfFSatHeV+dr1brAI2Ei1/igHplHKbuxmYgu3
	 ZY0gJWeoMNRluaUnThDm72W1xPsuwwLvMgd/hk8EKgQk0uboeel0XM8SVlVMDvnjqy
	 PfavX3vkaD51NDxY1B8M1p8MmXdlSom5NXCoX2AE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Luo <luoqing@kylinos.cn>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0275/2214] sctp: auth: discard auth_chunk when skb_clone fails
Date: Wed, 18 Nov 2026 15:32:31 +0100
Message-ID: <20261118150021.073057052@linuxfoundation.org>
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

From: Qing Luo <luoqing@kylinos.cn>

[ Upstream commit 9ae7ed101cf28613071ebfbc42668c8917a670cf ]

When processing AUTH + COOKIE-ECHO packets, if skb_clone() fails
due to memory pressure, chunk->auth_chunk is NULL. The original
code still sets chunk->auth = 1 and continues, leaving the
COOKIE-ECHO to be processed without a valid auth_chunk for
deferred verification.

Discard the AUTH chunk early via pdiscard when skb_clone() fails,
so that the receive loop can continue processing remaining chunks
in the inqueue instead of stalling the entire packet.

Signed-off-by: Qing Luo <luoqing@kylinos.cn>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260723061107.384106-1-l1138897701@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/associola.c   | 4 ++++
 net/sctp/endpointola.c | 4 ++++
 2 files changed, 8 insertions(+)

diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index a957142672cb2..5149f744eaf21 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -1029,6 +1029,10 @@ static void sctp_assoc_bh_rcv(struct work_struct *work)
 			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
 				chunk->auth_chunk = skb_clone(chunk->skb,
 							      GFP_ATOMIC);
+				if (!chunk->auth_chunk) {
+					chunk->pdiscard = 1;
+					continue;
+				}
 				chunk->auth = 1;
 				continue;
 			}
diff --git a/net/sctp/endpointola.c b/net/sctp/endpointola.c
index efffde7f2328e..2313ea9fbe065 100644
--- a/net/sctp/endpointola.c
+++ b/net/sctp/endpointola.c
@@ -362,6 +362,10 @@ static void sctp_endpoint_bh_rcv(struct work_struct *work)
 			if (next_hdr->type == SCTP_CID_COOKIE_ECHO) {
 				chunk->auth_chunk = skb_clone(chunk->skb,
 								GFP_ATOMIC);
+				if (!chunk->auth_chunk) {
+					chunk->pdiscard = 1;
+					continue;
+				}
 				chunk->auth = 1;
 				continue;
 			}
-- 
2.53.0



