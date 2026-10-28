Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214184;
	b=QPq6OzOb2Lgtm8m/ylm8GCi3tOjcz0g+UpHk58wn5it2cEJ4cukmy+d8jxJWGfhBHQb1
	 Vft7VSQVWbeh6FqHzSKL18iGqefoUaZEvELeQf4C04TZ9HpIcaAaLfm0mmsWYKda9llyW
	 Qj8cpk8KTU2sRHNvQEopuErF9ya+368wBJKLhElGglrgVbqCoe1u+Ju+JxGlpdTem5sPT
	 QrSpAQbnuIt7u3ZLUuQb53KIAS6IrKp4G/LMJ39EcV15db5Q5MxLPfzCzoYn9DlSE1loH
	 f56i1SksHdao8o72AGLGS10eXk545RLthy1dChXNSIMSy9EBrsqkO2rtTu3hgF/TQEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214184;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kw+aJCJsbDG6lKkNGC/wLDnK4B2LZmH2KsE8WzPh1Dk=;
	b=zsLfBefeqnVLnYwsNPutBnNjjJaONtmU8pGiOP/s7YmD03CR6eGnSlHSUQMbjTpkJZV3
	 MJKHiXsfVWLTEiyu0zxTW/mccawkQFK4AOay/XAFxQKLCyLTGRu7WcwAbwB9OXnwAkj3I
	 iB9TKqN5mnjEU5j73ZUqTIGmi4FKHmMaJnn41X8RHN3KR6posLL+KkMklrCWARzy1Mjt+
	 M1CtvPpNp0W/04EEHUD6tDqy0fVeGcnHNLOd/fgAyAbAgS+WaFyBa6/kV2ArscCESYiau
	 gtoL7w/MQY130CGh7KSrKtVdc0iKcNN01auL5YCW9KcxhP9tktj1HvB1vTVWWCa+ULw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wGqyPjPX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62BCE60A260B;
	Wed, 28 Oct 2026 19:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wGqyPjPX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDC21F031E9;
	Wed, 28 Oct 2026 19:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214184;
	bh=kw+aJCJsbDG6lKkNGC/wLDnK4B2LZmH2KsE8WzPh1Dk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wGqyPjPXkL6rGUnilDetkR3KJ1xFIQ4DA+ILc5pnWGaRy8oC2vy1B5MSkzO3tch2V
	 kGMoob2G/Bq7w2JD+fTgbQNIw4+XTaTwR+8Rzq8jzt5pZ5qXYfScgMEmsbhpU1agOS
	 OmmsKTxy7H3XQg0JJesVLZsAdCApUnN7gAi4iOLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoine Tenart <atenart@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0762/1887] net: decrease cached dst counters in dst_release
Date: Wed, 28 Oct 2026 17:47:38 +0100
Message-ID: <20261028170516.783296236@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit 3a0a3ff6593d670af2451ec363ccb7b18aec0c0a ]

Upstream fix ac888d58869b ("net: do not delay dst_entries_add() in
dst_release()") moved decrementing the dst count from dst_destroy to
dst_release to avoid accessing already freed data in case of netns
dismantle. However in case CONFIG_DST_CACHE is enabled and OvS+tunnels
are used, this fix is incomplete as the same issue will be seen for
cached dsts:

  Unable to handle kernel paging request at virtual address ffff5aabf6b5c000
  Call trace:
   percpu_counter_add_batch+0x3c/0x160 (P)
   dst_release+0xec/0x108
   dst_cache_destroy+0x68/0xd8
   dst_destroy+0x13c/0x168
   dst_destroy_rcu+0x1c/0xb0
   rcu_do_batch+0x18c/0x7d0
   rcu_core+0x174/0x378
   rcu_core_si+0x18/0x30

Fix this by invalidating the cache, and thus decrementing cached dst
counters, in dst_release too.

Fixes: d71785ffc7e7 ("net: add dst_cache to ovs vxlan lwtunnel")
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20250326173634.31096-1-atenart@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dst.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/dst.c b/net/core/dst.c
index cbb6888aa32ba..2ac7d3bbabf1c 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -173,6 +173,14 @@ void dst_release(struct dst_entry *dst)
 			net_warn_ratelimited("%s: dst:%p refcnt:%d\n",
 					     __func__, dst, newrefcnt);
 		if (!newrefcnt){
+#ifdef CONFIG_DST_CACHE
+			if (dst->flags & DST_METADATA) {
+				struct metadata_dst *md_dst = (struct metadata_dst *)dst;
+
+				if (md_dst->type == METADATA_IP_TUNNEL)
+					dst_cache_reset_now(&md_dst->u.tun_info.dst_cache);
+			}
+#endif
 			dst_count_dec(dst);
 			call_rcu(&dst->rcu_head, dst_destroy_rcu);
 		}
-- 
2.53.0



