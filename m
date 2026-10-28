Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215680;
	b=pI8mx3C9vasq78WxEnS7DiSzvwyIw8/7ma1r24rk6OAmbyZxLLzOHSxqoZP4hMThY61G
	 /TbI8pxnp6+buSwkdJDbO2obPmOwtBkqHACmE5AI9qDVHmFK6qb4hB40pQ/z3eZyFLfDA
	 GY9bLc/j0kcA9bvBQ1DV70oFoZLK7GX6L3MZOSlgTdRNAd9mcX+ED85YswbpJFTdVe6qy
	 ckLjBbsgNhbbcnF8PanpYfge7/8R0zqrUtSihBmHoA2v1MGiWXsvcI4z3IZwJWlY+WK9S
	 89egIDPQBt5/L0ICm60vRx6AJYc1ylIyjwxifRvdpO3Ehbc+mP4IZfyArlTtTETaFnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215680;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=UvuqR36WHDA0Pr/7lFVBvAxJpF9sutxjQv+193E+DfM=;
	b=xirw0bCgNbK71hufLm3hmeeWEmumEz2WGfHcmNDbsA0tOpVngDVzh3FvmfyhwMNqS/C4
	 dLveUig/fBMGy0FqXwVjelOyeiKYS6/oDb2zuWSIm831/GQjR1uGl2JwKqGD/GzhfAADq
	 gjgVQL0Q1bDYZMwgI6FsARo9He0hpkqDiFUSr6zcRTTU/P7zH78SmzbLlTv5nI+cUkuJc
	 CqNTK8nAZZ+hTAB2Fqi2d/34WabndrRXzVOvaTcSfn527FU9Pwj38xMI5MCLLWucXgIEb
	 80+4+CSpOLZy9asQHPhF11cpl16h1mI5vk6YWLWoa8IR+oFvbcEzgY1gHtHFyyB8Piw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcNckX9Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6BD606A31A;
	Wed, 28 Oct 2026 19:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hcNckX9Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10521F031E0;
	Wed, 28 Oct 2026 19:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215680;
	bh=UvuqR36WHDA0Pr/7lFVBvAxJpF9sutxjQv+193E+DfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hcNckX9YpR+ytSlKpPXq/gHyhl2G+gUhLPzpn1lKRf3/qinb1yGa95xIbEEjwSzU3
	 SE8iRFFslyDl47NEBKZzOA0l7zGKCjV/Y3Q1NmVbtos2+N71QjbECXEvCk/0djbEGG
	 jfr5ZfY3SNOH349ScbFUnmzsxHa3kvTajk/VYVgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jiri Pirko <jiri@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1295/1887] net: sched: cls_api: add skip_sw counter
Date: Wed, 28 Oct 2026 17:56:31 +0100
Message-ID: <20261028170528.893718415@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit f631ef39d81956a2ee69d25039781ceae1162f62 ]

Maintain a count of skip_sw filters.

This counter is protected by the cb_lock, and is updated
at the same time as offloadcnt.

Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a347304b2ca1 ("net/sched: cls_api: Always acquire rtnl_lock when destroying locked classifiers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sch_generic.h | 1 +
 net/sched/cls_api.c       | 4 ++++
 2 files changed, 5 insertions(+)

diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index ae7b5535eeb13..b3c7325339eb7 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -477,6 +477,7 @@ struct tcf_block {
 	struct flow_block flow_block;
 	struct list_head owner_list;
 	bool keep_dst;
+	atomic_t skipswcnt; /* Number of skip_sw filters */
 	atomic_t offloadcnt; /* Number of oddloaded filters */
 	unsigned int nooffloaddevcnt; /* Number of devs unable to do offload */
 	unsigned int lockeddevcnt; /* Number of devs that require rtnl lock. */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 44139ca96a1e7..44215aada059b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3302,6 +3302,8 @@ static void tcf_block_offload_inc(struct tcf_block *block, u32 *flags)
 	if (*flags & TCA_CLS_FLAGS_IN_HW)
 		return;
 	*flags |= TCA_CLS_FLAGS_IN_HW;
+	if (tc_skip_sw(*flags))
+		atomic_inc(&block->skipswcnt);
 	atomic_inc(&block->offloadcnt);
 }
 
@@ -3310,6 +3312,8 @@ static void tcf_block_offload_dec(struct tcf_block *block, u32 *flags)
 	if (!(*flags & TCA_CLS_FLAGS_IN_HW))
 		return;
 	*flags &= ~TCA_CLS_FLAGS_IN_HW;
+	if (tc_skip_sw(*flags))
+		atomic_dec(&block->skipswcnt);
 	atomic_dec(&block->offloadcnt);
 }
 
-- 
2.53.0



