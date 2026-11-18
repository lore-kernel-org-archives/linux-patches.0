Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061931;
	b=gDMfQTPJn/CerjXYIllVfnY0EgcKRBWH9ygBCu5IEqt+4yVEhATppFXWRJctRDe7YjXI
	 89G3uM0+Ku7om34us5kbdYyKJsniDu7Mj1IqzqPYvVtFUJucfMuhsQJZhEsIm0bmwnR9l
	 y8Dc+lMvba8fMRWC2yEg0PltzHlRWXB6tyxS1bLI5FZelT8kMwC6sl3aDv+nDtfN2u81E
	 qF3WA9njHIfRNvDb1SvGGflhMemWCXFrNgY7/bn4ejkqWnhk2K8VMXx+4sojrGTh6l9BC
	 Ge//PuY7eR3eKvSWis0cv9iIKvfY28cxouE5Bp9tPYNZsbf2CcHXm3A+0g7uUaKlMPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sb4gVfcR6d7yn1y6QnfZBvasVyvLGSNOWv8ikaADZTQ=;
	b=lk9KK++KHcxf8ln1IRdWAXjksaomU3mrOMzHI0s026iqsXKJi7aSTpXcqTE2NTdxQ9pw
	 8D7M59PQHtUvm/0DH4lWyPAimOfJhS4+3DRhmVnmQwARjgughzYPLH/p5a9+ClHMzjFnw
	 GuK0LiyeQegoC9Mw2/8f/ydiQqqguF+isMNhdDUdfghAVsE36TI+TxibMCa3Y4UZkZ7gp
	 oZvSrXcQ74QoaLvdBd7nRl4bfgjRYLEE9Jz/ePscQ/3TfqVnyRki0Jei5WbY9Q1UkOynt
	 6vzXXmvAtqXIhVrDirr1+6dlcHlhf45McK3dY50dFtNls6jCyNWg9NJD/Qfn6422BCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2p4Pt89M;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95190606A320;
	Thu, 19 Nov 2026 04:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2p4Pt89M
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93A61F000C4;
	Thu, 19 Nov 2026 04:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061931;
	bh=sb4gVfcR6d7yn1y6QnfZBvasVyvLGSNOWv8ikaADZTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2p4Pt89MrZvY/8kQwxbCnm/XmtkV6WnHPPjrcLkGfSn/UahDXpBesYzZiMKKrCeNQ
	 GNqIVrEcfrpnMXT2XqOFkQJQlwMeeB3Ll2pnpM+vZQjjnsyywdZIBSz74lLaYEyAgl
	 7wtFHb2bhnYOzhWfq7llD18mG2TmoUbS2BPCHp6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	Waiman Long <longman@redhat.com>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1727/1848] cgroup/cpuset: use mems_allowed_seq when checking a policy nodemask
Date: Wed, 18 Nov 2026 16:02:45 +0100
Message-ID: <20261118150031.901215030@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 304fa45a1d7e9..62b9ac240ec93 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3516,10 +3516,21 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
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



