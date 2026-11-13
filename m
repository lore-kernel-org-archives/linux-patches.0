Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591401;
	b=h4ii2H7DtaCmoY2revixGLrI6blsKjVlowIFu8Ou2Bl8p1+7MB5Mssy3wc0xPi/itHCd
	 bk65Qi0xRrWMbp/0D1sjggQhIoiOD8g/lK3uFj2tJ6B6up9mXmklkSO3UMTO857dcWcgS
	 GEeeNjWN1ami+9OIr00qfZ73HrtNa86KjNmN/yuDawyK9zKs79PtY7f4ss/xXES0HQ0vO
	 +bYCtwGqk6F9vZkIl7uN96OsSxmnDmEdhMCNsdSmsP2Px/be2CdJ+FEubCd/fSvPMnVKA
	 Y/l18TuznOEkPhr2TS1YCI7HdWjiicv8OOxvh3gH8wvz+8eyJUUMc1ru1fb1/F61aTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NTyVKilKc0ULsmXlNUSNRICnGHzMrRna0x/WjC957NY=;
	b=Gknfek981ophRooPZ8rqUkUp9JJ5yqp2FBn43GUhrQf+n9zWPIhTVQz4GFWIYWrugrgG
	 dArAqZ0U5K77rkq2eO/CMD5O8vMwDtFX+0PElMnuePf+r6mGhcFBWO1OJQ80sJTiymoOs
	 oPHDlhIgDCwxjIp+sYAJQVtXrRKDxPpqxBmBtQ1rINmR0KFgN/CRmMRDojJmgi756Xs4B
	 LAMjqDBpgsXniMvEckqh16Gp6lxvXpmgJvAEvZqB1eMN9H27hQTXw8YO/X6A/QgamMuI9
	 ZhUUQsqkCi60DbFcTuWUPBTOxDF9NSnOmw33bDVqgiiLtAYJkL0KOdlZZTYcPzahDRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1FU4oOR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE68F6079D4F;
	Fri, 13 Nov 2026 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1FU4oOR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59B711F000C5;
	Fri, 13 Nov 2026 17:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591401;
	bh=NTyVKilKc0ULsmXlNUSNRICnGHzMrRna0x/WjC957NY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1FU4oORcSoKbKwhs7EW+zDFJ/zgQGUv52rNQ3nzHt6Qfbjf8qvQnOSD9IEIFqBB7
	 jcBGfG2y+kK/6WQqcxOSO1wx2RxRKkCFIANZmXEE+Gie+tQtQ5QtSZ8FMWxQ8feZST
	 A3UzSGKsQFse8YsrpS4rkCbOHCgwKKgLqxRKdHAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanglei Zhu <zhugl3@xiaopeng.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 499/670] apparmor: check accept index + 1 is in bounds
Date: Fri, 13 Nov 2026 10:51:03 -0500
Message-ID: <20261113153828.873930448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ Adapted for 6.12.y: this tree predates ACCEPT_FLAG_OWNER (2e12c5f06017), so aa_lookup_fperms() reads perms[index + 1] whenever fsuid does not match cond->uid and every accept index of a standalone file pdb gets the pair bound.  A compat-mapped policy dfa has one perms slot per state (accept[state] == state, table size == state_count) and aa_lookup_perms() never reads index + 1, and unpack_profile() aliases rules->file to a compat-mapped rules->policy when the profile has no separate file dfa, so verify_dfa_accept_index() takes a pair flag that is set only when rules->file != rules->policy.  The pair check is thus skipped whenever rules->file aliases rules->policy, including when the policy pdb supplies an explicit permission table; unlike upstream, this tree still uses aa_lookup_fperms(), which can access index + 1 on this path, so this backport does not address the aliased-policy case. ]
Signed-off-by: Guanglei Zhu <zhugl3@xiaopeng.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_unpack.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/policy_unpack.c b/security/apparmor/policy_unpack.c
index 46420587bcd52..61d7ef232f320 100644
--- a/security/apparmor/policy_unpack.c
+++ b/security/apparmor/policy_unpack.c
@@ -1202,13 +1202,22 @@ static int verify_header(struct aa_ext *e, int required, const char **ns)
  * verify_dfa_accept_index - verify accept indexes are in range of perms table
  * @dfa: the dfa to check accept indexes are in range
  * @table_size: the permission table size the indexes should be within
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
@@ -1272,15 +1281,17 @@ static int verify_profile(struct aa_profile *profile)
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



