Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038238;
	b=WhDzK31nhRLLOP1Gdo1zhHElZxGAbrkySxS1zP3rR2k0V1ITYVmAvnOohRqEVw9ZkKA8
	 LevmwJbI4EYf8D1Q/7UdL6ssNTIILxuFRw2LweXdqSO+Uz9peL8ymi3KiHnYRvmJOH8Eo
	 rm4hEJMQWLk6tSlPzJvz0shFlIUTwLLPeX3ML7/WBg84oXVLR6ZspHj5tzBYlW3TVuK3O
	 4D2OWMXG0tpSVi4Ei3w51c9MmBVWhJAt/meMVCC5iOlT47Zdwgnl17E+vVVz2Lmmh7YFB
	 ojlWyIr4Nj2Yhd1Ur/2QeEMR5Kq9D5u1gXcIGpfM9csxOFa5741hUkbgwwNFbsuCEhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=azFX8I4F5BEkhkIKLxKyEtiNvOPrV07Is8w6W/EjSlM=;
	b=bbC0vU4+JfBoKJ+PstLBGp/4ko88TQYB433oiGL9kc/j3RrpxbwcFkbwLY6gyUgWE3i+
	 yfbqgs+DS8PiTe3cil3i/KaOMziVO09WOav8zK4mQdC4Q9nOgANY7wCUKM5fxs5c2fq4T
	 9fbX5VXxOOEVKASz5pH6DDjQpcItmvSThy2DR+k041JOaAmV3MxHiH+CHJUDbZHO0EIaU
	 mO4032qwOqjpn53epTR2qJGdQHHWzmGl7AhS6YvQ4S8vz+9EhLcy7WM/ZLPGHE3sm3qNU
	 tRJDOLtlCfjT0VziixNAXguZdP41PcadXw0KFvTMEUGylTgvIpMR2f4sAKnl8ORhmAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gcs5LsQa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D1B606A31C;
	Wed, 18 Nov 2026 21:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Gcs5LsQa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6CB51F000C4;
	Wed, 18 Nov 2026 21:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038238;
	bh=azFX8I4F5BEkhkIKLxKyEtiNvOPrV07Is8w6W/EjSlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Gcs5LsQa/PFSJj4iv7sHI2tADWoLonYZocND69Ds8ePbN7XhITYj6cR6PP9Y2ySmQ
	 te3opHoowtQwWjZo4Nz985iMK8PTUjHYttnnXe+qE6OtubErT6qC3AbHk0Rd6do80j
	 OH+mCgon7phdQXHZ1uhxNEx8FFHs28wi5EydCsbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1674/3318] apparmor: check accept index + 1 is in bounds
Date: Wed, 18 Nov 2026 15:38:16 +0100
Message-ID: <20261118150412.021253906@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guanglei Zhu <zhugl3@xiaopeng.com>

[ Upstream commit afe5d5a747393cb3d00795db31d7fce5108a766a ]

aa_lookup_fperms() returns perms[index + 1] when the current fsuid
does not match cond->uid, so such an entry consumes two slots in the
perms table.  But verify_dfa_accept_index() only checks that index is
within the perms table, so a policy whose last accept entry is reached
with a non-matching fsuid reads perms[index + 1] one entry past the
end of the table.

The perms table is allocated by unpack_perms_table() with a u16 size
read from the policy blob, so a crafted policy can place an accept
entry at index size - 1 to reach the out-of-bounds read.

Check that index + 1 is also in bounds.

Fixes: 6f442d42c0d89 ("apparmor: fix profile verification and enable it")
Cc: stable@vger.kernel.org
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
[ Adapted for 6.6.y: this tree predates ACCEPT_FLAG_OWNER (2e12c5f06017), so aa_lookup_fperms() reads perms[index + 1] whenever fsuid does not match cond->uid and every accept index of a standalone file pdb gets the pair bound.  A compat-mapped policy dfa has one perms slot per state (accept[state] == state, table size == state_count) and aa_lookup_perms() never reads index + 1, and unpack_profile() aliases rules->file to a compat-mapped rules->policy when the profile has no separate file dfa, so verify_dfa_accept_index() takes a pair flag that is set only when rules->file != rules->policy.  The pair check is thus skipped whenever rules->file aliases rules->policy, including when the policy pdb supplies an explicit permission table; unlike upstream, this tree still uses aa_lookup_fperms(), which can access index + 1 on this path, so this backport does not address the aliased-policy case. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 589b43c34703e..2514672214dd9 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1194,13 +1194,22 @@ static int verify_header(struct aa_ext *e, int required, const char **ns)
  * verify_dfa_accept_index - verify accept indexes are in range of perms table
  * @dfa: the dfa to check accept indexes are in range
  * table_size: the permission table size the indexes should be within
+ * @pair: the accept indexes reference two slots, index and index + 1
  */
-static bool verify_dfa_accept_index(struct aa_dfa *dfa, int table_size)
+static bool verify_dfa_accept_index(struct aa_dfa *dfa, int table_size,
+				    bool pair)
 {
 	int i;
 	for (i = 0; i < dfa->tables[YYTD_ID_ACCEPT]->td_lolen; i++) {
 		if (ACCEPT_TABLE(dfa)[i] >= table_size)
 			return false;
+		/*
+		 * Accept indexes for owner-conditional permissions come
+		 * in pairs, so the non-owner entry at index + 1 must also
+		 * be in bounds.
+		 */
+		if (pair && ACCEPT_TABLE(dfa)[i] + 1 >= table_size)
+			return false;
 	}
 	return true;
 }
@@ -1264,15 +1273,17 @@ static int verify_profile(struct aa_profile *profile)
 	if (!rules)
 		return 0;
 
-	if (rules->file->dfa && !verify_dfa_accept_index(rules->file->dfa,
-							rules->file->size)) {
+	if (rules->file->dfa &&
+	    !verify_dfa_accept_index(rules->file->dfa, rules->file->size,
+				     rules->file != rules->policy)) {
 		audit_iface(profile, NULL, NULL,
 			    "Unpack: file Invalid named transition", NULL,
 			    -EPROTO);
 		return -EPROTO;
 	}
 	if (rules->policy->dfa &&
-	    !verify_dfa_accept_index(rules->policy->dfa, rules->policy->size)) {
+	    !verify_dfa_accept_index(rules->policy->dfa, rules->policy->size,
+				     false)) {
 		audit_iface(profile, NULL, NULL,
 			    "Unpack: policy Invalid named transition", NULL,
 			    -EPROTO);
-- 
2.53.0



