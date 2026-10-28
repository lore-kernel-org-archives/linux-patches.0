Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212348;
	b=JgjYf2XHCerSJzZBqDgvG/pW9qtUeXR9JsMNSUfKHE8dRsqL8UCt8Y5ZHSHa7eGiOykR
	 GJSpC+ZI6FNlp+vjGYZ2zZTVlTAER/03r3lc9CUA/i81l0Z66pgLw/lTP3gIPrZiaZMud
	 TgZixFOakqs9W4Oy7IfBonn2LvUVDNBGivNE1pteUzMl2lAN+ovik7eisyRoZVZKb2tYs
	 83UryTF441d9sSVKQ3meZ4M9JW0HE13Tg9IB9GgD+rtqivRL6aIjihu6sNctwPLlSTowB
	 kkGrdLNVcnvtDLAkqoitwSdagRS/rwY12fJVRJXgxxkr+IkWoo2ofjk1QBZhZ3Ld5BA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5OY8S8Gb6HoqDJsOZ4VXZxtYuO0xWxxEnoMvD2o2Wfw=;
	b=OgDGcfH8yAReHFR1D82r6xBuUGsA7tn0oBnt2ELeTj9YcQwsjCq0BaqJnGYjHT0ZpBfT
	 5tehAGh7/tUfl47Wvh7e/uadOOijJlavVo4BuNf1AzpJ4A4Lj6IFQEbKTIV+vMg6NWm7z
	 pFKQmxPXeXYPgqyfMdRyojXnNWlZxjS4aRU5fK+9Wo/2Ha/KwFxK3onCqjo1w7urA2zxH
	 6FvXXw/L6XEAHY1ryeA3OLZQxnU0iDRQyFnpOgumqjv+CXP89JpuG6JBxqb/CVuBVYsTj
	 oB3jJqUImb6YpV5sewwUhw3LZaJbbbSPSzf4kT+nBCqIibXbJjclfqYuGtnfI72Cy5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8XUEYbt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9987606A31C;
	Wed, 28 Oct 2026 18:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=r8XUEYbt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C821F01828;
	Wed, 28 Oct 2026 18:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212347;
	bh=5OY8S8Gb6HoqDJsOZ4VXZxtYuO0xWxxEnoMvD2o2Wfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r8XUEYbtrs8001v+Ru+P1km7mNLf3kTN8rlo3C4DRNol0kGzjMveHj6EQosBDhbZh
	 jV9JVnLiAweN0/7PagzmxkkdrpVrAV0L1QhjWd9WaFf0THUZDeX2KjZaiizSmx3UCr
	 Kwmc2NFSyZvQTkrEjwbbURhNWyOJg2fGYW/gvk3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geliang Tang <tanggeliang@kylinos.cn>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0123/1887] mptcp: pm: drop match in userspace_pm_append_new_local_addr
Date: Wed, 28 Oct 2026 17:36:59 +0100
Message-ID: <20261028170502.038032705@linuxfoundation.org>
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

From: Geliang Tang <tanggeliang@kylinos.cn>

[ Upstream commit 640e3d69d0bc70d7d3de34800a1640793262bd08 ]

The variable 'match' in mptcp_userspace_pm_append_new_local_addr() is a
redundant one, and this patch drops it.

No need to define 'match' as 'struct mptcp_pm_addr_entry *' type. In this
function, it's only used to check whether it's NULL. It can be defined as
a Boolean one.

Also other variables 'addr_match' and 'id_match' make 'match' a redundant
one, which can be replaced by directly checking 'addr_match && id_match'.

Signed-off-by: Geliang Tang <tanggeliang@kylinos.cn>
Reviewed-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Signed-off-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20250221-net-next-mptcp-pm-misc-cleanup-3-v1-5-2b70ab1cee79@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f9f0068e8813 ("mptcp: pm: userspace: fix address ID overflow")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mptcp/pm_userspace.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/mptcp/pm_userspace.c b/net/mptcp/pm_userspace.c
index 129ae1fef054e..e203b7f878a90 100644
--- a/net/mptcp/pm_userspace.c
+++ b/net/mptcp/pm_userspace.c
@@ -43,7 +43,6 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 						    bool needs_id)
 {
 	DECLARE_BITMAP(id_bitmap, MPTCP_PM_MAX_ADDR_ID + 1);
-	struct mptcp_pm_addr_entry *match = NULL;
 	struct sock *sk = (struct sock *)msk;
 	struct mptcp_pm_addr_entry *e;
 	bool addr_match = false;
@@ -62,16 +61,12 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 		if (addr_match && entry->addr.id == 0 && needs_id)
 			entry->addr.id = e->addr.id;
 		id_match = (e->addr.id == entry->addr.id);
-		if (addr_match && id_match) {
-			match = e;
+		if (addr_match || id_match)
 			break;
-		} else if (addr_match || id_match) {
-			break;
-		}
 		__set_bit(e->addr.id, id_bitmap);
 	}
 
-	if (!match && !addr_match && !id_match) {
+	if (!addr_match && !id_match) {
 		/* Memory for the entry is allocated from the
 		 * sock option buffer.
 		 */
@@ -89,7 +84,7 @@ static int mptcp_userspace_pm_append_new_local_addr(struct mptcp_sock *msk,
 		list_add_tail_rcu(&e->list, &msk->pm.userspace_pm_local_addr_list);
 		msk->pm.local_addr_used++;
 		ret = e->addr.id;
-	} else if (match) {
+	} else if (addr_match && id_match) {
 		ret = entry->addr.id;
 	}
 
-- 
2.53.0



