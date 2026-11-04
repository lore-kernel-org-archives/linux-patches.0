Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831262;
	b=r3OZAi7qBG1cnrdXCbUERxha4xR34ujvTXlGGdM/W5zaggOV4zK8ck310FcKosjBjt8Z
	 LE4dbkLFNUXlLprFDFCJEwiKOFCoFxLGHe/QJdEaJSuIGxrk6c07Pg6J4y7h9Ktb4WYxx
	 DYpQ4gNy1NtGY1wDc313b2I0JcmYUb5agsMmdQ705DvnveLfXDkuEYuAWExC6mWLiTJ4v
	 UiiUuwK5On1f2pNwwwcj3pL3OK0USK0HWjSur/FxsiiWTYBgtVtyn7WRdWi71IeVAXcnH
	 Azp+kV5tmFdvsHS3bQp8pcK91UOJys45KO5UMTrs62iZmG6QtC3ZFDdPN+iWff1vH5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831262;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cyOmz6K3frR3J4YUFjzXQWhk1/jJ4IW+JSoad03mcbg=;
	b=wprF5z69nHzavY8J0o6m1FY53yoQZPadEi9/OPgKzDrMuuKDA8AAkGGpe0khaOllnLF/
	 r7WjF/Sfw4fAwUafxqzQWGsJAPguSLsg+MR+nQgJx3iIMXRDpy5zaGQXwXQG0iqhwoi0s
	 SMn6SsdfzS5jqXSyREmhHJnXojUTqB9syoaAvifuAbWU0vqHg5+tWRjtZ8uhTmjeAPV58
	 2SSQYsg/8+fnm6clFLf+wg/6LIyeUe1pS2pMzg1LTIX1dblS5nAT96BA8Fwe2BAOlLkEQ
	 3Y/Pzt6oP0rKMuM3+jWNw8Mjf8R3Sfmxm2yOREJtLJkHnj2TAWI2Or7SXQrxA4g42tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dFeIYHzD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BAD606A33E;
	Wed,  4 Nov 2026 22:27:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dFeIYHzD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B25171F00919;
	Wed,  4 Nov 2026 22:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831262;
	bh=cyOmz6K3frR3J4YUFjzXQWhk1/jJ4IW+JSoad03mcbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dFeIYHzDNnXz0+3En1Z+tdU70zqivaJVF8OWgioGRXGAhJDS+QN7V/0OnC7EKQ3YT
	 7nkKdv1F4RvphuDHQcbrnH7C8o37OAcslT7Sj7+4355apq/Zvsz39VuspIs7m9JuE4
	 1GRley/zhnA0gXGMZg2NyrXEhaVCGL5npSjWgy9k=
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
Subject: [PATCH 6.18 0599/1005] net/sched: act_ct: remove add_helper dead code
Date: Wed,  4 Nov 2026 16:05:32 -0500
Message-ID: <20261104211100.632933541@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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
[ sashal: Adapted the condition change to the branch's reordered helper block, since the context lines no longer matched, while keeping the branch's existing ordering and comment. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 161c62dafaa14..9309dca79bf45 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -984,7 +984,6 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	struct nf_hook_state state;
 	int nh_ofs, err, retval;
 	struct tcf_ct_params *p;
-	bool add_helper = false;
 	bool skb_is_ours = false;
 	bool skip_add = false;
 	bool defrag = false;
@@ -1094,7 +1093,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 		err = __nf_ct_try_assign_helper(ct, p->tmpl, GFP_ATOMIC);
 		if (err)
 			goto drop;
-		add_helper = true;
+
 		if (nat && !nfct_seqadj(ct)) {
 			if (!nfct_seqadj_ext_add(ct))
 				goto drop;
@@ -1113,7 +1112,7 @@ TC_INDIRECT_SCOPE int tcf_ct_act(struct sk_buff *skb, const struct tc_action *a,
 	 * or if we're about to commit.  This has to be done after all the
 	 * extensions are already added.
 	 */
-	if (nf_ct_is_confirmed(ct) ? ((!cached && !skip_add) || add_helper) : commit) {
+	if (nf_ct_is_confirmed(ct) ? (!cached && !skip_add) : commit) {
 		err = nf_ct_helper(skb, ct, ctinfo, family);
 		if (err != NF_ACCEPT)
 			goto nf_error;
-- 
2.53.0



