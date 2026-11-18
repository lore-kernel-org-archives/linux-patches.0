Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023763;
	b=5Io8ohO/TbZZ5PHYAbsgZhY86GsMn/tRJR/HUTxMfbs6rO44LJbsiDSkTqe19oCrx43W
	 1N0xI9myxmvCF4qzAhPFWi3e6bxg0dJ4S29JL09TE1g430wIuJX/AF8hB5MDJzyQHBNsR
	 nsGzV1Lkr6+WR0243ejK+IAGNhicwjm4clTKVUcFZA409y/Uy5OKV0ewpipTYCXilQCxY
	 Qk6JnXuq8WkqrQy8n8Z2BBPCOWwCnhzsOqgpLQb3GBbU182XkZfVuWfMszGnPF0sL+C6N
	 ddK1vJYj85l7BvkFeICewVwDC2xYzOc1rTqrkrCk2eMp24yFdPyjeCVrzdSiRY06DOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023763;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=scYQx/KufSkNdqk+IdoeccH4hfQMcZNbhEghAva3TRc=;
	b=eIiiopEjv1xZp9tZJmBB3EE6XhNCSn1APEzoNsn72T1Cs4jtSWJJWB54xf+6atIm4mCa
	 u/PST5+MeRk4R+hlvUHY2GhnEs+amDlrXqrePsJS/B5hqR/n+4y9UzJqInT8sGLtv6glY
	 k1/LmtJHk8bfIBCZ4E6As3sCUpIWfIqOKxeH4XXz3QQ5R/pQ/8UPI4Ly/wrRIR68XGBRh
	 +5aPi+jcS7jGxDAiZOXJiWHvo5hCnNmWsnqJhMgTQyNVbvNJxOs5UfYR8qiNK5piQOPYa
	 VTa9GM4YrYlhdmvK+FUl/UxdJIjAMHsu6H3C/EvxJI4gb+XqtDC66lMD/gEfm6qkOjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EL9YHepG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10780606A32C;
	Wed, 18 Nov 2026 17:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EL9YHepG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EC2F1F000C4;
	Wed, 18 Nov 2026 17:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023762;
	bh=scYQx/KufSkNdqk+IdoeccH4hfQMcZNbhEghAva3TRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EL9YHepGYGHNgqScOE8DuDJVx8SVW5794X2OjgfqYnKnlCHImESrwDvYkZS9tQS/j
	 AOKjmcAjdWF1mxz9UR5gIqIRNYt1wymskfgLJF2r9PiIG/2pQ0VnRCc55P5mc1PcuI
	 A51x555okR9ZCUn4/6u1x7liOoISLAfbDm8z72Nk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0486/2151] kernfs: make directory seek namespace-aware
Date: Wed, 18 Nov 2026 15:37:01 +0100
Message-ID: <20261118150139.755427920@linuxfoundation.org>
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

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit cb76a81c7cec37bdf525164561b02665cd763421 ]

The rbtree backing kernfs directories is ordered by (hash, ns_id, name)
but kernfs_dir_pos() only searches by hash when seeking to a position
during readdir. When two nodes from different namespaces share the same
hash value, the binary search can land on a node in the wrong namespace.
The subsequent skip-forward loop walks rb_next() and may overshoot the
correct node, silently dropping an entry from the readdir results.

With the recent switch from raw namespace pointers to public namespace
ids as hash seeds, computing hash collisions became an offline operation.
An unprivileged user could unshare into a new network namespace, create
a single interface whose name-hash collides with a target entry in
init_net, and cause a victim's seekdir/readdir on /sys/class/net to miss
that entry.

Fix this by extending the rbtree search in kernfs_dir_pos() to also
compare namespace ids when hashes match. Since the rbtree is already
ordered by (hash, ns_id, name), this makes the seek land directly in the
correct namespace's range, eliminating the wrong-namespace overshoot.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5ebcb578adee ("kernfs: don't repeat or skip an entry when readdir resumes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 1265ff74d9070..0fcebf4201206 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1853,6 +1853,7 @@ static struct kernfs_node *kernfs_dir_pos(const struct ns_common *ns,
 	}
 	if (!pos && (hash > 1) && (hash < INT_MAX)) {
 		struct rb_node *node = parent->dir.children.rb_node;
+		u64 ns_id = kernfs_ns_id(ns);
 		while (node) {
 			pos = rb_to_kn(node);
 
@@ -1860,6 +1861,10 @@ static struct kernfs_node *kernfs_dir_pos(const struct ns_common *ns,
 				node = node->rb_left;
 			else if (hash > pos->hash)
 				node = node->rb_right;
+			else if (ns_id < kernfs_ns_id(pos->ns))
+				node = node->rb_left;
+			else if (ns_id > kernfs_ns_id(pos->ns))
+				node = node->rb_right;
 			else
 				break;
 		}
-- 
2.53.0



