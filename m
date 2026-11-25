Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622101;
	b=vUMB6Wr4qBSyvP5Z0jALlICYZpVQYTibIfyOVeo08DRo5b5/DdSOWnCjai3IrjJXT2U/
	 IUYy2IbMlihuK/08mARcyibUGRCt/T7m7AnbWZB0S2hPhSo3tG4IiJ0go+DTPHGk7iInC
	 JZXlFKLEN7fPgek72Tn22lHF4v1tzATu15kzEU49+HiKFUAsa8IpROkHSquFshorZT9B/
	 V6WwIg4BMpalpcDLrhOW6BfzCSH31O1qa+S4VNJ0sLd3nrP16khRaPK0P+Esox75RJJ2u
	 Xzpaby7F0nEGnIxNQbxkyrAJIjYaAyeAmgmbbJ3jchGHREtLoavfao7Ylt6FfN5gqNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622101;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gTovXyATXnXXRuhJstxEzrCW4NrzsOBWDuaoIlKxyQA=;
	b=nS4IjN+EbZaakIOmXVUXvHGP/EhUj2oEVLutShQ5V1N/qBddTjmawFlYvcGNSbg4XSYB
	 I4b4ydvBe83C0swWqt55Cer6cKEu/sr58C4vw5b4++ju0hdr5RTN8/SkW2S82VfiMe2oU
	 +56yj2PkP7C8QSSH9In7XVgyYzwUVcuG0zbvJmaR3CYt+R0S9I3bZeRSQ7C7/8vMAsDrW
	 DPHJj7jOtVzxTJCKud7DdR62WPsy/JCmpTZod1zVajZcBdXi6WGn0lJ0nsxwQ2TFbaj6O
	 +breUdd5YKe8iCmZCSVtPktvbeSlPFScXTynUc0Xmyh8/cKh/rqGnW0umNJmtzDhDwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvnkainL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3AD606A327;
	Wed, 25 Nov 2026 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hvnkainL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B9361F000CF;
	Wed, 25 Nov 2026 15:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622101;
	bh=gTovXyATXnXXRuhJstxEzrCW4NrzsOBWDuaoIlKxyQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvnkainLcC0gfV6ZBggQ523GMH8tMZqCf3L9qcGx6KGhxN91HIVJcp8JfbxIz2m8d
	 VtU5KW8cWGVuhRvx67JoGVxLrOUo6lY35iiv25TwKQud1zWvX9cy37bKegE3L56Xu+
	 wtxqxHf5kteA8t1Tm0XY0Xx239rtlBHCn7tae/KM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lim Chanyoun <onleaf322@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 404/990] af_unix: Convert unsigned long to u64 for GC.
Date: Wed, 25 Nov 2026 15:29:31 +0100
Message-ID: <20261125143831.562866496@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit d5f898d4c47217ce42506698a3a98741393217b7 ]

Lim Chanyoun reported that unix_vertex_max_scc_index could
wrap around on 32-bit kernels, which confuses GC into purging
a live socket receive queue.

I apparently designed GC with u64 in mind to avoid wraparound. [0]

Let's make it true on 32-bit kernels.

Note that unix_vertex.{out_degree,index} are converted for
consistency; they are bounded by the number of allocated
objects and do not exceed UINT_MAX on 32-bit kernels.

Fixes: 4090fa373f0e ("af_unix: Replace garbage collection algorithm.")
Link: https://lore.kernel.org/netdev/20240228030508.31297-1-kuniyu@amazon.com/ #[0]
Reported-by: Lim Chanyoun <onleaf322@gmail.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261104082058.452188-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/garbage.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index 11b75d37ac03a..1007e110e377c 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -78,9 +78,9 @@ struct unix_vertex {
 	struct list_head edges;
 	struct list_head entry;
 	struct list_head scc_entry;
-	unsigned long out_degree;
-	unsigned long index;
-	unsigned long scc_index;
+	u64 out_degree;
+	u64 index;
+	u64 scc_index;
 };
 
 struct unix_edge {
@@ -148,8 +148,8 @@ enum unix_vertex_index {
 	UNIX_VERTEX_INDEX_START,
 };
 
-static unsigned long unix_vertex_unvisited_index = UNIX_VERTEX_INDEX_MARK1;
-static unsigned long unix_vertex_max_scc_index = UNIX_VERTEX_INDEX_START;
+static u64 unix_vertex_unvisited_index = UNIX_VERTEX_INDEX_MARK1;
+static u64 unix_vertex_max_scc_index = UNIX_VERTEX_INDEX_START;
 
 static void unix_add_edge(struct scm_fp_list *fpl, struct unix_edge *edge)
 {
@@ -373,7 +373,7 @@ static bool unix_vertex_dead(struct unix_vertex *vertex)
 }
 
 static LIST_HEAD(unix_visited_vertices);
-static unsigned long unix_vertex_grouped_index = UNIX_VERTEX_INDEX_MARK2;
+static u64 unix_vertex_grouped_index = UNIX_VERTEX_INDEX_MARK2;
 
 static bool unix_scc_dead(struct list_head *scc)
 {
@@ -451,14 +451,14 @@ static bool unix_scc_cyclic(struct list_head *scc)
 	return false;
 }
 
-static unsigned long __unix_walk_scc(struct unix_vertex *vertex,
-				     unsigned long *last_index,
-				     struct sk_buff_head *hitlist)
+static u64 __unix_walk_scc(struct unix_vertex *vertex,
+			   u64 *last_index,
+			   struct sk_buff_head *hitlist)
 {
-	unsigned long cyclic_sccs = 0;
 	LIST_HEAD(vertex_stack);
 	struct unix_edge *edge;
 	LIST_HEAD(edge_stack);
+	u64 cyclic_sccs = 0;
 
 next_vertex:
 	/* Push vertex to vertex_stack and mark it as on-stack
@@ -554,12 +554,12 @@ static unsigned long __unix_walk_scc(struct unix_vertex *vertex,
 	return cyclic_sccs;
 }
 
-static unsigned long unix_graph_cyclic_sccs;
+static u64 unix_graph_cyclic_sccs;
 
 static void unix_walk_scc(struct sk_buff_head *hitlist)
 {
-	unsigned long last_index = UNIX_VERTEX_INDEX_START;
-	unsigned long cyclic_sccs = 0;
+	u64 last_index = UNIX_VERTEX_INDEX_START;
+	u64 cyclic_sccs = 0;
 
 	unix_vertex_max_scc_index = UNIX_VERTEX_INDEX_START;
 
@@ -582,7 +582,7 @@ static void unix_walk_scc(struct sk_buff_head *hitlist)
 
 static void unix_walk_scc_fast(struct sk_buff_head *hitlist)
 {
-	unsigned long cyclic_sccs = unix_graph_cyclic_sccs;
+	u64 cyclic_sccs = unix_graph_cyclic_sccs;
 
 	while (!list_empty(&unix_unvisited_vertices)) {
 		struct unix_vertex *vertex;
-- 
2.53.0



