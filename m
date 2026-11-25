Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619013;
	b=uBfBM/+WIIUycmohh1DI0aXKhFv+XKBWLiQOv7aWafE5rvwTU14QW2yw6nhqCF0gevN/
	 JMwFSLkqvUNOuUyk9JlLke2Rg5tECbjTgGX2NwDKqTdxXOUEOO8yOFn1V1tWTybBE6Z/O
	 MQ+gWp9MTjU2bplN6b2po0DP1Bo6CmLrQEutbrKc3Ugft3kbvr/eLKjgsH2hi0Td7cMrX
	 lDogGaRvVdWhfhsq/rT6m+V2loJdLt23NZ1F5u3p7uHRw7VdQdEYB29qZU2yJmwGxYHb+
	 q01rWmh2jaYOM7oHsLe19xvZBkonCTtfhaClXFBuxGIyZF1/1XQHCfHRw3d98biWOlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CPhbMci+lkctqKH5O6PQu/8k+i9uXWCYCqRh8y3CnJU=;
	b=cO2bbnmiFZMVVaTH0rB7gc0hAfT+G3EA0CC0AxWc4RIUg35Ej6um9gKDdxslQP6JUvfM
	 PheUKGzfn3sdF0aCMpex4/KKpX4T3Z7OLN1EIY+7MHDU4FCBrvp8nMe3KOhHnBaospZtJ
	 0bvyKuTnE5m3D8mD+L86DPEtliKZyTmHEmwvFuSCVLgLQp8iOiwrFO/JDCcdHBSkX31f8
	 NCj6be3t0He5QBElZpXosxKuNVuSb59TaO+5GhrfuMZayCcJkXTXz9MjEAtpwinXRFJmy
	 XsPXDeOMK8sp4pad7VJvjvGTV8tWj2vLBtpRM40F8YgvM+MTSIH4BjiqwCg7yM85R+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRtmitd1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FB9606A321;
	Wed, 25 Nov 2026 15:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yRtmitd1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077751F000C0;
	Wed, 25 Nov 2026 15:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619013;
	bh=CPhbMci+lkctqKH5O6PQu/8k+i9uXWCYCqRh8y3CnJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yRtmitd1XDH1chutiPUkRjb9v7adc2TLap7gUZRIrDgmeaVkRvuNdR85k9egchsOM
	 x7cIU0ov07WNYrzgazCg3QapjErog+FK1DoM/PiPT3KAncWd57B5788aS28feT0RyZ
	 BOv/G++qULaZI8gfFrl4YQVtXoq0Sv6odXUrJAuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang Tang <q.h.hack.winter@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0454/1005] af_unix: Remove gc_in_progress check in unix_peek_fpl().
Date: Wed, 25 Nov 2026 15:29:52 +0100
Message-ID: <20261125143832.382983300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 0edbc945eb9edd0086f25b151a79cfe4adc0dfa8 ]

unix_vertex_dead() and unix_peek_fpl() are synchronised
with unix_peek_seq to prevent GC from purging a live
socket's recvq.

unix_peek_fpl() skips the synchronisation if gc_in_progress
is false.

However, on weakly ordered arch, GC might have already
started working while the write to gc_in_progress is
buffered.

This does not occur on x86.

This is an unlikely path that happens only when AF_UNIX
fd is peeked so not worth complicating.

Instead of adding memory barriers in unix_gc() and
unix_peek_fpl(), let's simply remove the broken short-circuit.

Fixes: e5b31d988a41 ("af_unix: Give up GC if MSG_PEEK intervened.")
Reported-by: Qihang Tang <q.h.hack.winter@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261104162858.991930-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index a0b515354e8b8..fbeabfb0db34e 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -329,9 +329,6 @@ void unix_peek_fpl(struct scm_fp_list *fpl)
 	if (!fpl || !fpl->count_unix)
 		return;
 
-	if (!READ_ONCE(gc_in_progress))
-		return;
-
 	/* Invalidate the final refcnt check in unix_vertex_dead(). */
 	spin_lock(&unix_peek_lock);
 	raw_write_seqcount_barrier(&unix_peek_seq);
-- 
2.53.0



