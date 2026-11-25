Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619544;
	b=ySAJjrPX19rZWoe4L/mzuRr0bmzmjoAQE0Be7egrv8lHrJ2PUo2b86EZV45byo5mupji
	 Jb22ZxkNJIgb1UUj0F0GoloQgc+GMxhlvBpdcJGEsUCtVL90iYQpeIxPTbXCFhiUhb89E
	 whNpHka14LXZLi7pv9kwlxierr3K6bd4y7A7VPMOcNfm4NtAmiHZzQD7n0zItEJpkz1sx
	 N34DQun+S/Wo2It4S1IRPVpj1JD0sKV4Vp7WE89I+Ld7JbhqhNASi06hQTAFTuwDOx3Yb
	 jtCQyaSX6/8g7nbyAVSrv0MxMZvelugUTNHxBRHRx6/99iNwRgsU8hafXIwLltCzanQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619544;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OzOPQXWJNd7gNMg+XSSK2m+oUDWZoBJkvA/22mI3PmU=;
	b=S/beqSZb4H85E722NmE6F+/v1IT5xFa7xTlRI13ONcbb9buTbsoLI1mqRFsKkDsDrDJj
	 fzRwYUR96yrbHnX42x1Ei4KvoNMADXA3Qhn5q3+8xAa+nuMnPQGJhu6HVUYrts74EdqCE
	 7gyLTnuExj2hdDvFYcyeKp2hNKj3xEw5TnmV7UfovdKGs62VfIg3fCBhInDdfYkN8Bd7V
	 h/rMatS4yxEHleZSSQtWSzp3lzeER55oJrQ1w76N9BdvQOwnnClWUulBOjTox/AI28E8I
	 JIxurfBQnJjTG/RYCT5WCBV64otcYmRr43lCJlT1Nok80VjCW7n500xXbNh6aWYSQ2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWn3EM8x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D12F606A31E;
	Wed, 25 Nov 2026 15:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kWn3EM8x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A55CA1F000C6;
	Wed, 25 Nov 2026 15:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619544;
	bh=OzOPQXWJNd7gNMg+XSSK2m+oUDWZoBJkvA/22mI3PmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kWn3EM8x2NvAlSXOdZNmb+VtVkupxNskdxGoWuq8fZCQfa+/9sD6BPMHlVeRZz1wF
	 Harn/vRtQXWo5LrlrEstqMtKmvwg9IlWwvSyERRoE4++PpyzUoO+viORTMDKx1zObZ
	 9BVz226ADtzhD4AAmLyE1ROgwC501w48meKTuWFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.3 0630/1005] net: netns: fix INT_MAX nsid cleanup
Date: Wed, 25 Nov 2026 15:32:48 +0100
Message-ID: <20261125143836.503901653@linuxfoundation.org>
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

From: Zhao Gongyi <zhaogongyi@bytedance.com>

commit dd6f1e7582f0f7f12c2d620cf50446aa987d7327 upstream.

A syzkaller reproducer assigning INT_MAX as a peer nsid triggers an
idr_get_next() warning during netns cleanup. With panic_on_warn, this
panics the kernel.

alloc_netid() also overflows reqid + 1 for this nsid. Use
idr_alloc_u32() for requested IDs and idr_get_next_ul() for cleanup so
the cursor can advance past INT_MAX.

QEMU/KVM reproduced the warning without kernel changes or fault
injection. The same reproducer ran without warnings after this change.
Kernel selftests were not run.

Fixes: 7acee67a6bce ("netns: optimize netns cleaning by batching unhash_nsid calls")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
Link: https://patch.msgid.link/20261111033525.65828-1-zhaogongyi@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/net_namespace.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 52c2bd44778a..c94718429771 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -270,14 +270,19 @@ static void ops_undo_single(struct pernet_operations *ops,
 /* should be called with nsid_lock held */
 static int alloc_netid(struct net *net, struct net *peer, int reqid)
 {
-	int min = 0, max = 0;
+	int ret;
+	u32 id;
 
 	if (reqid >= 0) {
-		min = reqid;
-		max = reqid + 1;
+		id = reqid;
+		ret = idr_alloc_u32(&net->netns_ids, peer, &id, id,
+				    GFP_ATOMIC);
+		if (ret)
+			return ret;
+		return id;
 	}
 
-	return idr_alloc(&net->netns_ids, peer, min, max, GFP_ATOMIC);
+	return idr_alloc(&net->netns_ids, peer, 0, 0, GFP_ATOMIC);
 }
 
 /* This function is used by idr_for_each(). If net is equal to peer, the
@@ -639,10 +644,10 @@ static void unhash_nsid(struct net *last)
 	 * use for_each_net_rcu() or net_rwsem.
 	 */
 	for_each_net(tmp) {
-		int id = 0;
+		unsigned long id = 0;
 
 		spin_lock(&tmp->nsid_lock);
-		while ((peer = idr_get_next(&tmp->netns_ids, &id))) {
+		while ((peer = idr_get_next_ul(&tmp->netns_ids, &id))) {
 			int curr_id = id;
 
 			id++;
-- 
2.56.1



