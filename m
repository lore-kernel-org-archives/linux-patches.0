Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211852;
	b=j0OqTb1qeZk+TqIiDOBe5peVTvxY5N4oEUzpWrO8iv3k1Ky7DKciuyJdfWJyAt6vk/zd
	 pScgH1pNFU4iOtSBs9enLy+obo2HJJ4Eu8Jjso2QsvjXoUyrjTu/Mr+xuermG6uJ/iB83
	 NiGVk2JHT3udSFKQ6dOmJOZyojXk9I4ApDLllizokA4u5IPE46RRUNX8kavcyPa8pZ5eN
	 FF+pYd5/MqVt1sQ+5U4i/O0K6rI/Od7dbkdC+zue43MD/Z3OAiDwKEWnt0HzkbwicFowH
	 zXpPARyO3anPm1liAQKdKAZ0iTa6C+hhjxp9EEEKqWmWcqmziTkn0+iIHjviCC1zGDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211852;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Kr4yN178N5p3m6rhKRZqZmuVBkPA9xRylTALR1tlcsY=;
	b=YffnZGRRDmnVVy/lhHW0L6qtWi8CiaB8MplVgQQn9OCS36AcEK5HAzEtFA0tZI4jdSuB
	 4Sx/QcmptglS1u3HFCBkwY9hkDB9mskPGXq4zWtsOftdKRr86vqqdMKI1s81Ct01WSB3H
	 YDfoNHyoxcnK8qUzzAMRLxtL0IPUhh/aAEd1UJxsAhrLpduSQaMrxZQ6EWtbkNl/teWH4
	 54uxAC+LdqL8n6GF5JKTrIz2lyICKV2l1lixSewkaTfiMe8NC3iRqSDJ53UqtWJAaktW7
	 vKNLTIL5FpcKGq7mAArk4/b32wo6jFlQ/Yl+puxl5m5VHCLage6hEt6kZcKpuTLDBjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ID0AHyxk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83183606A31A;
	Wed, 28 Oct 2026 18:24:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ID0AHyxk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D49F11F01825;
	Wed, 28 Oct 2026 18:24:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211852;
	bh=Kr4yN178N5p3m6rhKRZqZmuVBkPA9xRylTALR1tlcsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ID0AHyxkV/HvhNYeJpm2r2UDPytnmGcEwI4UrExhjyTVRov0nxNtctfQZ1lIWNIz9
	 YHA3kaIbMCj7SHdNRJNM5ii8f467c3/mrLp5xu4lRjX7I+YydulSzfxD+2y3W/m+lT
	 TB59cdVEI4i94k6OD/eHj8F03e+97ni1Cb8a3Vas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.15 524/571] net/sched: cls_u32: skip hash tables in u32_bind_class()
Date: Wed, 28 Oct 2026 18:01:11 +0100
Message-ID: <20261028170020.465005500@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 6d3724e616faf952c3adcf8414fc21a828ef3709 ]

u32_walk() enumerates both struct tc_u_hnode and struct tc_u_knode
through the walker callback. u32_bind_class() unconditionally casts the
passed fh to tc_u_knode and accesses &n->res, so when fh is actually a
tc_u_hnode, which has no tcf_result member, this results in a
slab-out-of-bounds read of res->classid in tc_cls_bind_class().

The issue can be reproduced with the following commands:

    tc qdisc add dev lo root handle 1: hfsc
    tc class add dev lo parent 1: classid 1:1 hfsc sc rate 1000kbit
    tc filter add dev lo parent 1:1 protocol ip prio 1 u32 match u32 0 0 flowid 1:1
    tc class add dev lo parent 1: classid 1:2 hfsc sc rate 2000kbit

Fix this by skipping hash tables via the TC_U32_KEY(handle) check.

Fixes: 07d79fc7d94e ("net_sched: add reverse binding for tc class")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/1786089038-36366-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index b36eced10ff40..cb4d2bfd03d24 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1318,6 +1318,9 @@ static void u32_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
 {
 	struct tc_u_knode *n = fh;
 
+	if (TC_U32_KEY(n->handle) == 0)
+		return;
+
 	if (n && n->res.classid == classid) {
 		if (cl)
 			__tcf_bind_filter(q, &n->res, base);
-- 
2.53.0



