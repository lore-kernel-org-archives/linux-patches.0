Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061422;
	b=nLF0gQIxCUzMidJ/dvBdEfDQC2FkAG7yTwc7nUiScoc6Dm4o4Qs/8ge3CELU0oDRMrHf
	 /ha88nQsJnODIDQu2spMC3PgGwYAbp6SQnZbblIqpRbuY0AZTPSHgSX4jqf/l2axcV2og
	 W45u1DSKVEQqbBffkYT/yS1P9UHwbFfZdLGPh2Br8biV1W0SYpzQbCrH+O1A6SXMrSxuV
	 J56iMBrA+lQreWFytst0m9lx/kmyOIzJ5JmCTtRD7VNzRDZtan9wVFI7Uo3spnZbfmjoJ
	 GMAZshysjTS6wXhTFPx4Knw1JHkqmPd5rOdvn8+ITKKcyBPGQKLw4DR39Ke8VVgILig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061422;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V3llOphLK5ChRmmBHQ0fWpahnLSF5vXWnQgHLNCr3GM=;
	b=wZ0yb5QLWEvwjHMPtmBVPDXHwS7jWSH7ZLcb1F+wMc+h+bnBmAyUoDDT5EK1dt+5Ntpp
	 4hedthjUrqiF4ydUABcK4l4Wt7BDQYb3fv3y1+Stch95De8gkqHEt/OypOKSDwpkVuLic
	 X5SAZDJkoRw7nf5VXTcxK6Lj1Ylmep1g5KSfx1iG8jn59woZPPQTppdXeL4FkbpQ/CwrR
	 dY4ujkQ2eCMpeEOa85jopg9NS97if4mptnGcr8Zv/jo9L+Z36yeb5kEl1Sh6O/P1M+d6B
	 9uQH0MozgTVUwnNl10KK5ficxnCZ9ajp1b7izKadcVN3ONBzlTZmbnsF8jIg+8CvRCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ij1pVjQV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AAD606A32F;
	Sat,  7 Nov 2026 14:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ij1pVjQV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E37B1F0089F;
	Sat,  7 Nov 2026 14:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061422;
	bh=V3llOphLK5ChRmmBHQ0fWpahnLSF5vXWnQgHLNCr3GM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ij1pVjQVoLLi3Pq4GQvvqo1OjnX4weOOkktw3lquLXj/cEctbN7oDDc3UtSgpIAxE
	 k5VEFcyQS5VBMsJNZWQ8F+mc/EE4kbBNcpyVqgxTquJguPeJ84ZMslJbthTUXUpPbq
	 4mV+lxZFDx82Zrgwn4GOjGkpMhFXzoqi0DWaF2dw=
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
Subject: [PATCH 6.12 0533/1536] net/sched: act_ct: remove add_helper dead code
Date: Sat,  7 Nov 2026 08:42:29 -0500
Message-ID: <20261107135012.581182121@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
[ sashal: Adjusted context because the helper-run block sits after the mark/labels/extension setup, so the add_helper removals and condition change are applied as two separate hunks. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 9c7e089f55d39..38d177dfedfa6 100644
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



