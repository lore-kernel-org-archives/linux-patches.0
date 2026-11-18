Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054320;
	b=pYWmoObr150cxX9aKAirakcvq8b7FYx2dpNdR4258JqZY/q2NOcsWRzvNplNrmsaZe6M
	 xoveOMwl0sTHGp8mlVPUUdet2FGEfRIIgIgADAa7Hw0erJmiBSbHiICq+UXpKT0NlTc/2
	 10UsgIr038ZuX2EySJiunVrxK5LYwWYny0ELX2+zitxla0Jswtju4Va+2wmWV34Mv2Y4F
	 5814K0FUpilzuNaNyEC63t+ccQCcnomJg9UP/K31RWEY3wvH2NWoMZgERHFrPs/vGYEgk
	 JfNo3TKGH4409ZF2HfEbWxqr+h0vB3xrXA84IWSKCP/Hl2wGt2XtTcIckxgv82HTOxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/GmJzsZKCKW1axxp7POXBaerIdyxLfXymxMkMVNAx68=;
	b=jRKPhga8PSoYfdpkb44bDZYcX22hotPFSUxoni4MBwz1wf8NFb2VvyLn/9+MDGC1Tw+n
	 hO0Y+z3rDiPzgNeezWE8x3Y4hhf3QbdZseO4O616zf9PlZExQITWUSG4MpJnrDaLDe7j8
	 sHmQCaOb16caYfmcUR3Gsqkv+hg0jPVsbYkSrRW92UNpXeD0GQnmCkJ7NRtKpAGUD7boc
	 puumEtCBRWtCzfj9XbnfrbytB/YBwVgi/udVvh26LbqJpYWOIs9LfNR3N5sNHsWpfKCTQ
	 oCS+OJKu3EirDXkj1WLvQEzYzIVNL+4lqOyzAHATV7LXUIW65mkddC8KRUzNkoaB8GQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gCajj9s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9FC606A325;
	Thu, 19 Nov 2026 02:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2gCajj9s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1DAE1F000C4;
	Thu, 19 Nov 2026 02:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054320;
	bh=/GmJzsZKCKW1axxp7POXBaerIdyxLfXymxMkMVNAx68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2gCajj9sCSznrWcMxMcW9iGEqFZtLdbsenZ5o7tVSRA0HrxzpNPjnFjRIqA+TnLp7
	 q9Trgxfkd3OVVeb48+gK9LATvyOqJ33p9Qx2uzu6B2KZ3m978v2+gHjk6JDvlXEwmN
	 UeeJxTfVq6X1mclMoDXyEouSsz0N4ajRHcO0BMk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Darong Lu <zzyy19904204639@163.com>,
	Ren Wei <weir@nebusec.ai>,
	Alex Markuze <amarkuze@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1232/2214] libceph: initialize CRUSH choose argument weights
Date: Wed, 18 Nov 2026 15:48:28 +0100
Message-ID: <20261118150101.032799983@linuxfoundation.org>
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

From: Darong Lu <zzyy19904204639@163.com>

[ Upstream commit c3a995ff0782587789333c621e1f6bd5e574371e ]

Initialize the CRUSH choose argument weight-set array before decoding so
entries start in a defined state while the decoder fills them.

Cc: stable@vger.kernel.org
Fixes: 5cf9c4a9959b ("libceph, crush: per-pool crush_choose_arg_map for crush_do_rule()")
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Darong Lu <zzyy19904204639@163.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[ sashal: Adapted kzalloc_objs() to kcalloc() with an explicit element size. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osdmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index af8b6c01784ec..4fab2aa5789c0 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -304,7 +304,7 @@ static int decode_choose_arg(void **p, void *end, struct crush_choose_arg *arg)
 	if (arg->weight_set_size) {
 		u32 i;
 
-		arg->weight_set = kmalloc_array(arg->weight_set_size,
+		arg->weight_set = kcalloc(arg->weight_set_size,
 						sizeof(*arg->weight_set),
 						GFP_NOIO);
 		if (!arg->weight_set)
-- 
2.53.0



