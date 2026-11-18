Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034833;
	b=k1/EEL2+lywyjry0RtNBVUPiQA5caynFRQ0XKC01jkkoVuZhJeTDqrw01PgFN7JVtn3X
	 1g2LR+usBKgl7YT7bIXQ0Sljq2FBRY+xDxukVGzFGVJgzLDORw9qs0Boio0h+FPKGHhnP
	 aW+rRaI7pJ4FyX3lLvL2VzqTlVPpHaSJ73iO1gwzv8GZduOnOjkUe9jPTx9+8HH9KYBIy
	 4OLHmDFoIwt1UtvejC2cWuf3hJP1+gJ9dNC6pv6vK2whloOWPsi3yhwjmX2Sg5gaxBy3T
	 XVdmUiydihbMqzRpzcy/1sQ5P3jf4AKs+QKk5Mwh+bl8nTNuSZnuWUTKWmYHPeGyzuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fiCoBNQvR5AGfRaoC1+pisRbsAY0Ni775J+o1wsZrtg=;
	b=cLzIGXjjX6UoXuZFVFYa2c3kSx3JQgOa5fVi3qd2qOYL7NIqIzT847Z1R9Z5zczUOkDw
	 I50UNWMgZAtjWixI44Ri1+9E14L2uYianmzsrJk0BzNYYtdtZ2+CYHLQ7Kj2KAMfdYmkU
	 zACrAPRsIGgWvN0Y6o6hQJp7M7blJSxMCqkh+i7LOHuxvhdWuI2/QDgV+EKFNEX90DHWw
	 PWydKrBsYHnpyYvAjXUfCVtvNUyphXtz8kyMpVkhlo1IHPb7r0i74eUmqV03sxiC3Rw4r
	 TGlFAYwD8imIKe/XLXhCaVvOIkpa8JXGaE2/Y0yfWgOZQPZ801ZG2u5X4w5RRcZEsHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssWFWBvI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3946606A31C;
	Wed, 18 Nov 2026 20:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ssWFWBvI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CC781F000C4;
	Wed, 18 Nov 2026 20:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034832;
	bh=fiCoBNQvR5AGfRaoC1+pisRbsAY0Ni775J+o1wsZrtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ssWFWBvIHMN97nQ2/ZACclHS6RNbjfO94pJ3C8Q3pcRyDaqpWeFYugkJn9qwH4GuY
	 WCM4jLpqQrgtrG1f7rOS/cwo3x977cxYla3BdarMjiswrYLRWT4stAAFmiZlSk7vu3
	 fu69tBUEclIY3lFITe7YPL7s2r/sXqSbCK+TK1c0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Maximets <i.maximets@ovn.org>,
	Aaron Conole <aconole@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0510/3318] net/sched: act_ct: remove add_helper dead code
Date: Wed, 18 Nov 2026 15:18:52 +0100
Message-ID: <20261118150332.411527230@linuxfoundation.org>
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

From: Ilya Maximets <i.maximets@ovn.org>

[ Upstream commit 00df72e39f306e2f7adb68528a5c92109da6a0a9 ]

This variable can only become 'true' when the connection is not
confirmed, but it is only checked when it is confirmed.  So, it can be
treated as being always false and just removed.

Fixes: a21b06e73191 ("net: sched: add helper support in act_ct")
Cc: stable@vger.kernel.org
Signed-off-by: Ilya Maximets <i.maximets@ovn.org>
Reviewed-by: Aaron Conole <aconole@redhat.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260921145655.3167436-6-i.maximets@ovn.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Applied the condition change to the already-relocated helper-call block instead of the upstream location, since this tree's layout differs and the conflicting hunk was dropped. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index d0fd701067672..950ed925e69c9 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -980,7 +980,6 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	struct nf_hook_state state;
 	int nh_ofs, err, retval;
 	struct tcf_ct_params *p;
-	bool add_helper = false;
 	bool skb_is_ours = false;
 	bool skip_add = false;
 	bool defrag = false;
@@ -1090,7 +1089,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
 		if (err)
 			goto drop;
-		add_helper = true;
+
 		if (nat && !nfct_seqadj(ct)) {
 			if (!nfct_seqadj_ext_add(ct))
 				goto drop;
@@ -1109,7 +1108,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	 * or if we're about to commit.  This has to be done after all the
 	 * extensions are already added.
 	 */
-	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
+	if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {
 		if (nf_ct_helper(skb, ct, ctinfo, family) != NF_ACCEPT)
 			goto drop;
 	}
-- 
2.53.0



