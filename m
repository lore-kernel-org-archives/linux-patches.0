Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618341;
	b=Vt5mLaK1wbjUUsADpFPb/5bdi8c2G2pKYxWk+HBzTCIdW6Z2nrUTR7fDbdUHT3RQC8M+
	 UmIzgZCZRLW7pueIssdK3/nIIpN09qci6HDIhdo7LVOsapCgXgF058ZhEmipobJ+DDXs2
	 8F5ROSpVM8acSlh4WJbXPCWyF60ADZFORpYFoG+El+riaO89xxM7B6BJOEWlCav33jxj9
	 smhaw2rdlvvnUoI2joAAz8+qoal32jkJXXd4vH+hsrl5RmKgEh0/30LVRBLSYskUvWpwk
	 IjFurXLPbsAjmxr9gPMWOI1kpf+oJ4Ox2hpa9rk42dyCi+dmx63Dof1+SDAr7WiNOvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=11LrvOmVRgb3FYZosFgsJnGCwugzNR7mFZBOLBzNbGk=;
	b=3d6L8AvPT5SO2R+Ln4rHg4ZyhS7Gf6Co9CjIOSC7t9G8+/Hd9OSTodywAjqiE8lzRvYj
	 mVNGHs0/dCgbQdqJZ5fczpPkOljIT773xHV//Vu0r5sVhY2qrjCXyWo6+bSfO2dAGHCuO
	 FaI1Jcc/aIvADRzZwWck4a6xioyNAWjXgEqdcpSLBOrosas8cgOqbtlgiqjZdrwWI/iS5
	 HpK2+x8Kc2DEhTeYDSmo7te7E26lrtXkx1cgVDRy0cw7wEvAAnXoiz2dQeoqRGLKD1rkf
	 z7qjT4N54VCY71J5Ah/rAJYfGt/2hwHCPpif1p7UHAx90x2z1gKAOlTHai7GSSEOehg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qV4aO4Fk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20747606A31E;
	Wed, 25 Nov 2026 14:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qV4aO4Fk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26A9D1F000C0;
	Wed, 25 Nov 2026 14:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618340;
	bh=11LrvOmVRgb3FYZosFgsJnGCwugzNR7mFZBOLBzNbGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qV4aO4FkiDbdwR58FMu8RwpxjwacbWivKc/h2IkNknjZjTUT8OlYuhKNHEob4PFzw
	 o7ETOASw9AAaNdFjNm1nOa/TUOTciz4WJXuIG8vSjf8A0N4imyGZ/vH5e4WD72xuyJ
	 xoDKNxYCst7wLorLFLFlhA/hORPLNV7uJiD73BW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0248/1005] tcp: wait for TIME_WAIT teardown before freeing per-netns ehash
Date: Wed, 25 Nov 2026 15:26:26 +0100
Message-ID: <20261125143827.546528431@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 647b81ddefc6364290e67bf33c89d54971f8995e ]

inet_twsk_kill() removes a TIME_WAIT socket from the established hash
before it finishes using the ehash lock, hashinfo and bind tables, and
before it drops the death-row reference. A running timer can therefore
unhash its socket before inet_twsk_purge() reaches it. The purge cannot
synchronize with that timer, and tcp_sk_exit_batch() can free the
private ehash and hashinfo while inet_twsk_kill() is still using them.

An unprivileged reproducer using user and network namespaces, a private
TCP ehash and a FIN_WAIT2 timer triggers a KASAN slab-use-after-free in
inet_twsk_kill(). The allocation and free stacks point to
inet_pernet_hashinfo_alloc() and inet_pernet_hashinfo_free().

Wait for an RCU grace period after purging the whole batch, if one
netns in the batch uses a private ehash. TIME_WAIT removal runs with
bottom halves disabled, so this also waits for removers that were
already invisible to the purge. Keep the wait under
tcp_exit_batch_mutex, before freeing any private hashinfo.

The same window exists with the shared tcp_hashinfo. There, the
hashinfo memory stays valid, but tcp_sk_exit_batch() can decrement
tcp_death_row.tw_refcount from 2 to 1 before inet_twsk_kill() drops its
own reference. This triggers the WARN_ON_ONCE() in tcp_sk_exit_batch(),
then a refcount_t "decrement hit 0" warning from inet_twsk_kill().

Adding a grace period for the shared case would be costly on busy
hosts. It is not needed: struct net is freed by a later cleanup_net(),
after the synchronize_rcu() in ops_undo_list(), so inet_twsk_kill()
can safely drop the last tw_refcount reference itself.
Use refcount_dec_if_one() and only warn if tw_refcount is not 1
after a grace period.

Fixes: d1e5e6408b30 ("tcp: Introduce optional per-netns ehash.")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
[edumazet: only call synchronize_net() if one netns in the batch uses a private ehash,
 use refcount_dec_if_one() to avoid a false WARN with the shared ehash]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261030075843.2567707-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b414313381020..df2763f31dde6 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3550,6 +3550,7 @@ static int __net_init tcp_sk_init(struct net *net)
 
 static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
+	bool synced = false;
 	struct net *net;
 
 	/* make sure concurrent calls to tcp_sk_exit_batch from net_cleanup_work
@@ -3564,9 +3565,27 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 
 	tcp_twsk_purge(net_exit_list);
 
+	/* inet_twsk_kill() unhashes a twsk before it is done with ehash
+	 * and bhash, and before it drops its tw_refcount reference,
+	 * so tcp_twsk_purge() can miss it. Such callers run with BH
+	 * disabled: wait for them before freeing a private ehash.
+	 */
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		if (net->ipv4.tcp_death_row.hashinfo->pernet) {
+			synchronize_net();
+			synced = true;
+			break;
+		}
+	}
+
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		inet_pernet_hashinfo_free(net->ipv4.tcp_death_row.hashinfo);
-		WARN_ON_ONCE(!refcount_dec_and_test(&net->ipv4.tcp_death_row.tw_refcount));
+		/* Without a grace period, a concurrent inet_twsk_kill() might
+		 * still hold a tw_refcount reference. Let it drop it: struct net
+		 * is freed by a later cleanup_net(), after an RCU grace period.
+		 */
+		if (!refcount_dec_if_one(&net->ipv4.tcp_death_row.tw_refcount))
+			WARN_ON_ONCE(synced);
 		tcp_fastopen_ctx_destroy(net);
 	}
 
-- 
2.53.0



