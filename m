Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028645;
	b=v7eeCJ0GOV+LNK93lEsYqzgy7Gs3ds4GrvxZCtkcGLXnWRT7xng5aoZnZcuHh7pBtDmC
	 D6np7ouedi2gnvl5vRE0a/52Q7mo5VK68764T6Hn9nEplPE4O2asntEfJ48dPC6rtpIsA
	 gNs3JL8Pv+Rg0Y44PSwFn//GB78ziOtA1WJS59eXEQh6Ocp3TvbF4ez89wzh5pPYxg2NX
	 8FqKdJVWjv+lCXRSK3HgS/0njIBXVMeNZZomgpJNleMo+0MpZ5kc794gHrMLW0xHFnnuu
	 nYTy7fMmyKLgO758H81MO8Y8kaCTuyexKIxu+PyXdEXmLECeoRXdV46Mw6a8CVVvONA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x/xQ/DiXwaFg/KnCQ0FBw0t+o3BUTNztJrFDSGMfhh0=;
	b=Djb+92gJ+n1fDnS9Lu6fKqph70x+vc8ckmGfNDkOi6bnBozg7zX3jciOcuJEK3W2OS9L
	 vj9Kh02uJ+udtWIyxAoPzUgvTIaLkwFKFkdb9Iw6aWfw/rModLCP6ura01uDqXhfL5ucd
	 Z4ztLCtyJ3sPKHUjtt67ZKPqLay7EI3iNwB0nS0lwDLdSRQWymWpCHGtmAVEQKsz5P39+
	 OAgHHbx8gX+Yyt0K/vVnrm/1vo76I9Pf1+KBO9w9ls+ZWUcHWrSUVGr2ZxeOAF46MaS3H
	 kcCsQ7yC3Ps01BCn1LTHuYssoCiELAiMAH8cIkB15qUPIJl4nQ8u0yUK3L9M4gqjhkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oljg2eNU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90F4606A337;
	Wed, 18 Nov 2026 19:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oljg2eNU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200501F000CE;
	Wed, 18 Nov 2026 19:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028645;
	bh=x/xQ/DiXwaFg/KnCQ0FBw0t+o3BUTNztJrFDSGMfhh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oljg2eNU/wbzM1zyHNwBdo6hGE2B+UIDwFev/B93JrLesYPFaVR2iqyN78MJ2q3pp
	 aBKICWtodocZUfMxb3tko5dcjUNxnLijTdY4zDpbBxQDXASD5M3rRMlEIYyxneKaVP
	 Jk4gPSv/KISOMOXBIRckrLYpe8gol6eDIXSrwaMQ=
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
Subject: [PATCH 6.12 0026/1756] libceph: initialize CRUSH choose argument weights
Date: Wed, 18 Nov 2026 15:35:53 +0100
Message-ID: <20261118150008.925812735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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
[ sashal: replaced kzalloc_objs() with kcalloc() using an explicit element size ]
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



