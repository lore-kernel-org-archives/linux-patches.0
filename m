Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027434;
	b=R5TkH5ksUGcNYtZ7v5BW7RBa6wo3HYNc3dFj5Y2kjfUH6qaH817vSJtIW0W15+FNAiLk
	 9dpokNTVR61wQCgD89NYWyBDBp1JPsO64l2rjqUOOVqmzjJpxivvER/rBVUD7D1ESw3Rs
	 npGu6Le+i/23ygbw1nxLgJXpInDbHV4uO192jmcge71S02jijK+wr4S51l27tJ+mOihJa
	 xEgP8So0BT5zdrg25gPYApIAT8Jl6vNNhQ50TyoFI7FgpRB4MWzXIMXMT7oW/7IogosNL
	 Tp1bWShbhmabKMzrffi3d9XIT8tEZIY0KKijqpcvtBvG7uof/XFya+ydbgB2Q6vy7Qw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027434;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XuW4iSTYynqk2QMsjNNKtGlhyxwP/K74fDtu39SCvTs=;
	b=3NtgZzeE2X6QocRQacZatpNu3qCn317RxpE4fzFNPF7BuEtf9wX8mLUR/Jj/NxxZF8x9
	 ESxuHYw0/XmbyQuFIlnFGNcGUY2SzthYL21X5Lq4Xk3OYUpUcUrfUByxwO4qZu/EQSrsJ
	 10zqAmpMkElOKi2oPO5TqjCLGllBYIO0SQ1ngX7dzQJT2ToIHTHppdYMvoO6rVnozNRnJ
	 qvOekj3iLWhAjSiMclIYxr6ZllS4zx5v0dOv90reuaPdoypzUfTANMZpe+iKQ1kA4W5mj
	 SxJg7wdbn2j75r2ldykqs8u7r3+2xRAAAtm2xM/X1jjq9+OXo7UhHLiXDi+ajjHIXyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TE6v1AK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5AE606A33D;
	Wed, 18 Nov 2026 18:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1TE6v1AK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 726531F000C4;
	Wed, 18 Nov 2026 18:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027434;
	bh=XuW4iSTYynqk2QMsjNNKtGlhyxwP/K74fDtu39SCvTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1TE6v1AKph6znedBQI4dRjUr+Viz+ebA2O6BWsJPTSaM+pqBmtrb80X5hZFHMAnxv
	 L3vA2/FFhahtql2vjN9zMXJy2beQL43GmMHSh4RLrUaD/OIxo+FPOALjC/LdAKiX2h
	 h7/0uaKjdnroeNwF+asWqt2A12MHXZu5yJ0c/Mc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Waiman Long <longman@redhat.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1789/2151] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Wed, 18 Nov 2026 15:58:44 +0100
Message-ID: <20261118150226.988685200@linuxfoundation.org>
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

From: Gregory Price (Meta) <gourry@gourry.net>

[ Upstream commit b0cec62d2867ab3ed27604d5c177b8960c43b17a ]

A cpuset update changes the task's mems_allowed and rebinds its
mempolicy in separate steps under mems_allowed_seq, but the check
reads both without it.  This can cause a spurious numa placement
miss under some cpuset/mempolicy combinations.

A reader that loads one mask before the update and the other after
it can see a spurious empty intersection and drop the nodemask.

For example, a task with cpuset.mems={0} and MPOL_BIND={0}.  If the
cpuset moves to mems={1,2}, the policy is rebound to {1}.

The allocator can race and compare the old mems_allowed {0} against
the new policy {1} - which will result in a dropped nodemask and a
misplaced allocation on node 2.

Simply retry the intersection until mems_allowed_seq is stable.

This covers the task policy, which is rebound under mems_allowed_seq.
VMA policies are rebound afterwards by mpol_rebind_mm(), outside
mems_allowed_seq, and are not covered by this change.

Fixes: cc9a6c877661 ("cpuset: mm: reduce large amounts of memory barrier related damage v3")
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 968a50997ac1e..4f73656ff5c37 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4367,10 +4367,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  * @nodemask: the nodemask to be checked
  *
  * Are any of the nodes in the nodemask allowed in current->mems_allowed?
+ *
+ * A cpuset update rebinds the task's mempolicy and changes mems_allowed in
+ * separate steps, so retry if an update raced with the check.
  */
 int cpuset_nodemask_valid_mems_allowed(nodemask_t *nodemask)
 {
-	return nodes_intersects(*nodemask, current->mems_allowed);
+	unsigned int seq;
+	int ret;
+
+	do {
+		seq = read_mems_allowed_begin();
+		ret = nodes_intersects(*nodemask, current->mems_allowed);
+	} while (read_mems_allowed_retry(seq));
+
+	return ret;
 }
 
 /*
-- 
2.53.0



