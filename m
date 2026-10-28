Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209455;
	b=ZUR/0Uf2D+rR1x//WNPJKwb/R4DSK26yt0u5bZgiehN/aLmrmLUwINqshvXaEC3g1tHV
	 3g1e5kqdy3CfzPb7fJCE0NkKYdOVUdxI0tscyn8gAV4Xx8dEU87/RWcLhJKgvoqZrFx0g
	 IbB0Uk8QGJkvZWjbaHlCrCHopdRmsounGx/WKzTmjiwP+VcOWVO6pTavW9KPqUEaTW6CX
	 raGkF4/H6zILKWcyhTx+DC8wqefAsRTCLGbgobgX2RMKnYuq3uOCyRpf4UiNo473U0TUL
	 9J1tfqhkVDV6tB+YoW4WxQ8rz4mXlC94ERhmPEQ5i6fEfV1NCsZPH8uVeA89kjxTQfw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M+sWS1fB92qy+slU5+x8AJrIwWe3O5cjDCps2vec9aQ=;
	b=J6E0MwVxKmGPXP0Z7FsDfm3uo5PDfEhpuns92cr2wKvSdQB0RB9l2ACQZr0ZbZk9a5pz
	 WAMomdUlc4lTokxefiV+JY7Bad3TsfRIUYXQWgW40SnxGhHQSP3W9vPzNT2gURQkj/7uV
	 a5SawV1fLlON7G4Dc9NvdR1G4jdH/Yx+l4QFRDvUc/V0drHeU75rZfsWWWgtqUsZyfAtN
	 xWY4+OB9RmcD1Qiqr+0xY86zWTwl67ldA9fZT0p6BHzes9E72QyzVDAfP74uCB6D2mRch
	 +QNAhgEWf/vxpdkXSTfe7xpouUER9Gh5pmN/Uic56pp1Z7K1nTB/pvUPo8gePFAG3hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZI49O/Ue";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6720E606A31A;
	Wed, 28 Oct 2026 17:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZI49O/Ue
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C721F01825;
	Wed, 28 Oct 2026 17:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209455;
	bh=M+sWS1fB92qy+slU5+x8AJrIwWe3O5cjDCps2vec9aQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZI49O/Ueo88LClX+wWn5nt5tUaqbByUnYn3uDWuhoT5CNRGFDOPyC17zTf0U1Egzv
	 nI6KwiO8jI5EfI37JW90Ozl5f4DnSNbJ/C52sM725bRzIg4s+xl6Ze1dXi4r1hfzKH
	 fT6mwvx9B7Kj3mQtJPVUJTx21jEJu7B9qgoFB/kM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Changzhong <zhangchangzhong@huawei.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.10 478/516] net/sched: cls_u32: skip hash tables in u32_bind_class()
Date: Wed, 28 Oct 2026 18:00:30 +0100
Message-ID: <20261028170014.804887190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
index 5221ce128526a..38455c91633a5 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -1323,6 +1323,9 @@ static void u32_bind_class(void *fh, u32 classid, unsigned long cl, void *q,
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



