Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053358;
	b=Yo+4SZkxykID4FtKpl+EyEuJTPcvNJJQDjxcaQnVziJLjlAK4nlF0SS+/nYtIPR79MG2
	 fpMYE8YyzXhwqXyjd5hHX+B4jeq+Et1aw+808C6aHyMjqzbNCuUVx9BbAVWodg/oOTvb+
	 HHRVTbESYlCTEtli9WVVrH2plfteffCiKZOKaiWPZ7S68OSc7Oni8PBabbMMOHpHUh5nk
	 078HgTpHwHqm38ha6LuUnDtrvYLDlBWHOoyt61mfDG6glq/7LQPNiSwRK9V4B5FMmEDo3
	 4nsKiH/jYXZv4T4hVSCyfC5ktMJoahfnTfpuPMtQTfbU7F5Zj4XqKD4ZDY6MjU6bH5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053358;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u795gt2mts8KbxMoyChKdyes4q1TDeyNfhM60eKVDR8=;
	b=hevwYA2yszTVALJz0aC8iQ4Jmz3Qefu1NWWtcczsw6JNNZdEUt9MSGEzxJcYMyIY3nkx
	 Zpo2Jyxcc88BXuH/h4U2cVX6Wam/veLv2tCmsz2gytSBEugynjV5mXDaYrPKQlhcbsUfc
	 ChVw11KlLX1gOyilgm1u7Pb6XR45o2Gw7tEXmo7ahsLyfgjY0x/1EbOsC7bRII56B+gqv
	 qY1Zvl46jITNFYDZwUh1OWFZj7530TbZAuoTdTJZHnm6BQRUREAj/sja+Tw86o8bmKiST
	 U+UCOhS/7ZHbijWBE+n72v6qd0nwVGfmUGgtZJfWXs3GWbqqOv+LLn0OXdYEMiu/WOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMHCGRWV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11577606A32A;
	Thu, 19 Nov 2026 01:55:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PMHCGRWV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504531F000C4;
	Thu, 19 Nov 2026 01:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053357;
	bh=u795gt2mts8KbxMoyChKdyes4q1TDeyNfhM60eKVDR8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PMHCGRWVllZYePDSTwKOTFp9m0EgyIjYJHQOPmepeO+6yPsWyY4HS7pzVqVNPJomm
	 AndjIsM6oF+gnDHj57//JuRhI9LHW0UbRTwmqkzIqCrwD4+dWxVcGUmVR9xyjCdqyX
	 GrmfGaCk0SWbcNtang/pT2yOtXA+COPV7uEfnXts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	David Lee <david.lee@trailofbits.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0888/2214] net/sched: sch_qfq: prevent aggregate self-replacement
Date: Wed, 18 Nov 2026 15:42:44 +0100
Message-ID: <20261118150047.784250270@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 2e54b3e187300893688c2c7517894f5d96732e05 ]

qfq_change_class() snapshots the current aggregate settings while
holding the qdisc tree lock, but drops the lock before selecting the
destination aggregate. During that gap, qfq_enqueue() can move the
class to an aggregate matching the requested settings.

When qfq_change_class() resumes, qfq_find_agg() then returns cl->agg.
If it is a singleton, qfq_deact_rm_from_agg() frees the aggregate
before qfq_add_to_agg() immediately accesses the same pointer, causing
a use-after-free.

While holding the tree lock, skip the replacement when the destination
is already the current aggregate. Any estimator replacement has already
completed, so the class change can finish normally.

Fixes: 462dbc9101ac ("pkt_sched: QFQ Plus: fair-queueing service at DRR cost")
Link: https://lore.kernel.org/netdev/20260731140533.566493-1-david.lee@trailofbits.com/
Cc: stable@vger.kernel.org
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Co-developed-by: David Lee <david.lee@trailofbits.com>
Signed-off-by: David Lee <david.lee@trailofbits.com>
Link: https://patch.msgid.link/20261029180957.43015-1-david.lee@trailofbits.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_qfq.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/sch_qfq.c b/net/sched/sch_qfq.c
index 8e5b30c447b86..33e99cb2388d0 100644
--- a/net/sched/sch_qfq.c
+++ b/net/sched/sch_qfq.c
@@ -520,11 +520,14 @@ static int qfq_change_class(struct Qdisc *sch, u32 classid, u32 parentid,
 		sch_tree_lock(sch);
 		qfq_init_agg(q, new_agg, lmax, weight);
 	}
+	if (existing && new_agg == cl->agg)
+		goto unlock;
 	if (existing)
 		qfq_deact_rm_from_agg(q, cl);
 	else
 		qdisc_class_hash_insert(&q->clhash, &cl->common);
 	qfq_add_to_agg(q, new_agg, cl);
+unlock:
 	sch_tree_unlock(sch);
 	qdisc_class_hash_grow(sch, &q->clhash);
 
-- 
2.53.0



