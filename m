Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038935;
	b=QO6bJpJUoY/isCRcRMk7ru3F6BUVhzgDUNexcDFfh7KenTnFpWPiRBl8v5p3hYOLiScF
	 3Dn6f2uml+/oy1S2E2+5aTIkQJRWDh3FHYna0CtKFehJycXNbUEAXKmC5LRSulf0NLeuv
	 SGpk5WVb1iMM0+x+s1klbYtqHyakvLIbQF/FKK4mbqrPNYMlfOrzRyDhe/u8WrYapqrQN
	 agrLLUdBnhSczRzsIr/IPHXNJK0usvqGGqQsUgLfje7i4YyZpvFhqukdOhdPy8QX7tA9/
	 8ROEgM1Sb4Lu9PLvA3T6C5rqV8yF0Vrh8gC2iW7CvSJtn5EpPDvF2q4qcTOP/GC5y+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038935;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+hRdx/II96QrkNPCU7NxSh7Gu6ceewQDy8FCETsKxvE=;
	b=nbo8rLE1QV8J3CT3GP8JVsCnlnp1Dq9oaRAbDyLH58L/qWAh3nZo6vXgTc50mdjyVa7X
	 e+Uh6MDWfU3ZlZ/nO/TbMf+mRLVANMtTr2FRz9yMsR+nOODLmeVMXyjinWbWOiTvNRHes
	 i+XP4cVd5SGUm1+Qw4kNIykhSAjmdgn4trAYHctz46Gms5fSpdHaC3RboWvng+iZ/Ub7B
	 qsTEe3hOPL+JxPh19+K9b+lWtiFCHWBzWKKy4NeSffYlbzHOCt6MUy+UnsBuaunBJ1e3d
	 Zt4f1UKdr6RkDRB8pr99Ec03e3dg3JENOgxee3ltg326AH9yfpqPZW3p+ckrxybiQzg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fFaXeq6f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ED4606A320;
	Wed, 18 Nov 2026 21:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fFaXeq6f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ECF01F000C4;
	Wed, 18 Nov 2026 21:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038934;
	bh=+hRdx/II96QrkNPCU7NxSh7Gu6ceewQDy8FCETsKxvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fFaXeq6fDpWT6upvaj1RN6Bb7AzPh+DEms5iiKLqzotH+nZySLiFRjK4Bekp5DfbO
	 WYW1xRhTf3euPezl3ovmOPNSv0zs8S0ZJlz/C1+AxEJwTaVK5KkCP9bt5z1684g0cV
	 tyVyCYakyjg7+YP8coQzTCP+fHrFa751ZDnu1Bus=
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
Subject: [PATCH 6.6 1879/3318] libceph: initialize CRUSH choose argument weights
Date: Wed, 18 Nov 2026 15:41:41 +0100
Message-ID: <20261118150418.353463837@linuxfoundation.org>
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
[ sashal: used kcalloc() with an explicit element size instead of kzalloc_objs() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ceph/osdmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 803514a1bc7ce..fdb8c398f5ecd 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -320,7 +320,7 @@ static int decode_choose_arg(void **p, void *end, struct crush_choose_arg *arg)
 	if (arg->weight_set_size) {
 		u32 i;
 
-		arg->weight_set = kmalloc_array(arg->weight_set_size,
+		arg->weight_set = kcalloc(arg->weight_set_size,
 						sizeof(*arg->weight_set),
 						GFP_NOIO);
 		if (!arg->weight_set)
-- 
2.53.0



