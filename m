Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619154;
	b=Wl51FRtxC1LGG4CYahJuPA+TPfcc5P9YWEHzBlLn7oVKBq3I+fJAMCy46lRrMD1sStp2
	 zeiI7WVZXkp4qF1j9UNbYJkjZbYluzAqa7coyXNOSy6F+aQCeDShq1tKa68iT1nu1PATa
	 RKrb9LIZ5SxUalFZVVyWojjgdQOGq1NRuuEx2YL4HWj30K1tJxm3iFiTb5oz3MnLNyG6q
	 WIEr2EGF96w1bJ4krmFbYim577uRl5D7TCSkCsyVs34GAXCRzah7ubtoTHZYMEMsxTRfS
	 JH2R3o0FSbGqc7V92UlBFSKp4zIeWAaoCrjSr1XOTIPm75alIKlXSjtkav0zIcRd8Zw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619154;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Am9WGWmBRrn+8lwd08C57dgRFk6UXmy8v2De4PV2KaY=;
	b=ct5yZCDFP/zAL+ET2tYqBrCg5E/kBwNyvqWmd5ZgaatlqL+gxBkP7peCLTI7MYZTIqet
	 46PXqzREb4tA3LmRQCRx/vLvKA+YY9GkMkMpGlkTEADTQNbXDN5C66MN5FsdVHfiS1ehl
	 VhjBlmAbzTtY1D+1TJszEPp/7jC5L+ChmLsocr/y0irGfCukKLiV8RNzIBWn9QTfGA1lM
	 2CsB8I5rONqtuKsue4Dls+1J0bpBNb11jFjSMK3t8ZabESB6IpN+vxkFTKx03IMbN3iPN
	 hA4xdwvl9ebAkaj1Cc0qhw9IC1vH9UyhvIO/i40cZZ0AnH747LdgBSrrlVJ0uMV9Zeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ua2FJSLj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14830606A31E;
	Wed, 25 Nov 2026 15:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ua2FJSLj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6564D1F000C0;
	Wed, 25 Nov 2026 15:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619153;
	bh=Am9WGWmBRrn+8lwd08C57dgRFk6UXmy8v2De4PV2KaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ua2FJSLjp/9uPBWQIuvuP6NwZ5g+Gt5uAQ875hT6B86URnYAA4X76M1JaKRYt7Yda
	 xz5kHMeKUqDoFAUVTuAeQVypMd2pSMgHgBCke1nyWzXi/kIVREveHtDpdY9r1JavKN
	 VJj6I2U2N+eZbXCgBVMFwKiDrIyQ1Dd4VIMvwpt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lim Chanyoun <onleaf322@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0453/1005] af_unix: Convert unsigned long to u64 for GC.
Date: Wed, 25 Nov 2026 15:29:51 +0100
Message-ID: <20261125143832.359084352@linuxfoundation.org>
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
index da774f56ca648..a0b515354e8b8 100644
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
@@ -372,7 +372,7 @@ static bool unix_vertex_dead(struct unix_vertex *vertex)
 }
 
 static LIST_HEAD(unix_visited_vertices);
-static unsigned long unix_vertex_grouped_index = UNIX_VERTEX_INDEX_MARK2;
+static u64 unix_vertex_grouped_index = UNIX_VERTEX_INDEX_MARK2;
 
 static bool unix_scc_dead(struct list_head *scc)
 {
@@ -450,14 +450,14 @@ static bool unix_scc_cyclic(struct list_head *scc)
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
@@ -553,12 +553,12 @@ static unsigned long __unix_walk_scc(struct unix_vertex *vertex,
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



