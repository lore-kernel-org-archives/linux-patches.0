Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051632;
	b=eBj7GeUH16Lo3KOiuJI1p6ZqWkUguFOYH+RxNB2y8vy1oHenS81QVlU+2KEtPWy2sMpt
	 Yt8X7Msare8cIL/iWjGghazCBOZbGtyJW/FAqCVbjDVXvPQqgN+2dj7tIzRaRdEzGp7gI
	 R2XJr94CoK17oNf0ghY3KSizRJqd6W7JqxJTPRysjAFScf9JO9NLTgNWYjqubUrxJf3EI
	 gdwGuVGyKBeRXhTqO/Jz2ArsiMAD8XNofVZEg5DHHG9G1OrSHLez7Df+KdwYuaYrbp6Rd
	 FW4XUas3NqdfYmdv0l7eUZn4tCMXUDaDOaeYY1Ze16BTXWK5vlaTl9+8UXIxWfQEuig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051632;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nr9LnPv8Z9tu3wE9ABEx6SQdlvYm8Ui9Stl5rvm2PK0=;
	b=GyYZlEA1yktOu4R7AvWcQshv+RbnAAo5oE1+LmrwvbzsWIL9RNjBS1OYRtCwfMp1aAmA
	 zb/ZxGzSXH4jqvMHE58tlGW9T5NTQtayVg88dxQbUdLykY0yQOeXWKpFvsiqibwtyZ6PH
	 QDGPyCvchRi8QrhMte36DS6oJArY4yW0EXFBMJDOAYaH7rHdp59KOeWjMiwoZI09wEPSY
	 YvD9dc/PVHBr1fAx1yDPPhc/Q2hF7Kqjq/zJWr2IUIJtmqnhvWZY8ObsKTima1bqOzM9w
	 JlxtUFI65beD7L8PjKWi9+9kKIA2duwkHUgkytrX28IOpusw+sNqO6lHpHzJ2+WvSqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOUV0CHF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B83606A33D;
	Thu, 19 Nov 2026 01:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bOUV0CHF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6E01F000C9;
	Thu, 19 Nov 2026 01:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051632;
	bh=nr9LnPv8Z9tu3wE9ABEx6SQdlvYm8Ui9Stl5rvm2PK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOUV0CHFmg5+sBwlJIIegV1u6kHvZVFcK4eCQehwsEYFovEvMrXJhR/YnJZmVDUVj
	 PD8Z9MMxAyOVqP7xeK9o0/oYzzzKhEMij3TPbMY9u780kSVi07M/GbjfbhWlfEwgfa
	 hA9ROUOplvP0TrMnSz66ucZKt8IGXslxvrt3KW2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Imran Khan <imran.f.khan@oracle.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0277/2214] bpf: Fix UAF in sock clone early bailouts
Date: Wed, 18 Nov 2026 15:32:33 +0100
Message-ID: <20261118150021.143833930@linuxfoundation.org>
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

From: Matt Bobrowski <mattbobrowski@google.com>

[ Upstream commit 7cbd0c4cebe4c9f678d15e6b9ba975e1155a107f ]

Similar to recent commit 9b51a6155d14 ("bpf,fork: wipe ->bpf_storage
before bailouts that access it"), sk_clone() performs an initial
shallow copy of the socket field ->sk_bpf_storage via sock_copy()
for the cloned socket newsk.

If sk_clone() bails out early (e.g. if sk_filter_charge() fails) prior
to calling bpf_sk_storage_clone(), newsk->sk_bpf_storage still points
to the parent socket's BPF local storage. When newsk is subsequently
freed via sk_free(), the deallocation path (__sk_destruct() ->
bpf_sk_storage_free()) destroys the parent socket's BPF local storage,
leading to a use-after-free (UAF) on the parent socket.

Fix this by resetting newsk->sk_bpf_storage to NULL immediately after
sock_copy() in sk_clone(), and remove the now redundant initialization
from bpf_sk_storage_clone().

Fixes: 6ac99e8f23d4 ("bpf: Introduce bpf sk local storage")
Fixes: f12dd75959b0 ("bpf: net: Set sk_bpf_storage back to NULL for cloned sk")
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260709025316.999913-1-mattbobrowski@google.com

[Imran : Conflicts resolved:
  - net/core/bpf_sk_storage.c: upstream commit 0db4941d9dae ("bpf: Use
    rcu_read_lock_dont_migrate in bpf_sk_storage.c"), got merged in
    v6.19-rc1, and is not present in these branches. So the line following
    RCU_INIT_POINTER() in bpf_sk_storage_clone() still uses the old RCU
    api (rcu_read_lock()).

  - net/core/sock.c: upstream commit 151b98d10ef7 ("net: Add
    sk_clone()."), merged in v6.19-rc1, moved the body of
    sk_clone_lock() into the new sk_clone(). That commit is not present
    in these branches, and the code relevant to this backport is still
    in sk_clone_lock().

  In all five branches, sk_clone_lock() is the only caller of
  bpf_sk_storage_clone(), so taking the NULL initialisation out of that
  function is safe. ]

Signed-off-by: Imran Khan <imran.f.khan@oracle.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/bpf_sk_storage.c | 2 --
 net/core/sock.c           | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/bpf_sk_storage.c b/net/core/bpf_sk_storage.c
index 4953abee79fea..9db272dd1d8af 100644
--- a/net/core/bpf_sk_storage.c
+++ b/net/core/bpf_sk_storage.c
@@ -191,8 +191,6 @@ int bpf_sk_storage_clone(const struct sock *sk, struct sock *newsk)
 	struct bpf_local_storage_elem *selem;
 	int ret = 0;
 
-	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
-
 	rcu_read_lock();
 	sk_storage = rcu_dereference(sk->sk_bpf_storage);
 
diff --git a/net/core/sock.c b/net/core/sock.c
index 7ad291f06c1c0..860b8d3cfb9c0 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2070,6 +2070,9 @@ struct sock *sk_clone_lock(const struct sock *sk, const gfp_t priority)
 	sock_copy(newsk, sk);
 
 	newsk->sk_prot_creator = prot;
+#ifdef CONFIG_BPF_SYSCALL
+	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
+#endif
 
 	/* SANITY */
 	if (likely(newsk->sk_net_refcnt)) {
-- 
2.53.0



