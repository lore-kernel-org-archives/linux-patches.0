Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213223;
	b=E5YkBxXhmfcmPcTt3PaRifdKPMDQ8w/3Ps++rW5br1rODHErG/tL8A+rCu+98LbGwBVx
	 E8OZZhqwrdf8m6/vgty/n7yCt733obsWix1cnuPWWwLTvl+ih4t123DP/Ns4sUU13CbAQ
	 ofU0UcD+yuLgS2bwh/EWwXX7QvoUt2X67Vg4QXNrJEyNGKPyac/oCCS7xChQ5+rVEZPql
	 u+rzTSbiwMMiedW/LPi03NcOk5UmwLRgGafWRo+RLvvLneJma+k7tbcKYffijAxyqoKXM
	 hsrYIlf0mv9s36Doxii70PVqvc1lgiuOuH/B6oFGLORk/ZZCH6/x1tIXB4a8Tdkb03Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213223;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=glCu55NO53tq3uyYWSjzT73KJ8aoLRwG207+3zsmhXI=;
	b=L2EUeXSBKIKJ7jH3hj/kwlv0jKHw1FIlXxwsK1O1OUwRlLfJraHTON0fNMBdVfaA56Fv
	 DURdVjaMD9I4tfrzvTixE04BWE8PoPaG5OMRiDRTG8YWVdxeoKX8fXZS1olF4fr06zDPt
	 4rClJbnBoMhFip42eQ6tSySEnSp+jbFKlkE1RGSMi3PKorjk1dorTBcwmX6DrrKg9wgvc
	 uULQLWjDyUfQbNyIHb5Dawq5WxFL7z71yzEwKBFUxZV3bJP/Zb/YvQxPPtFZxyNSrmw8h
	 lUnwRI9Tu0saR8PpmZcLp0IpwY0vsr7w9jdlW6Hf8bnHsdQS/dLCzPed0gsll6Xy69A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVCX0ltD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B8A606A31E;
	Wed, 28 Oct 2026 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uVCX0ltD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8B6D1F01825;
	Wed, 28 Oct 2026 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213223;
	bh=glCu55NO53tq3uyYWSjzT73KJ8aoLRwG207+3zsmhXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uVCX0ltDYs8LfzbUui1IKrCBzz13YNNHuNsMV6W5oKZ7zdwQPJmMyx0IrxvcPRGW/
	 JrwGcNR92GSfL0Qnp+9F7nNpyr9avVG/u+KIRAdGMrU5HFvhHk70lW2ExQc1V3H8wF
	 1YG+vzoA84Udde8p7IJo449cpjLho0zspt1Zdl7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0428/1887] netfilter: nft_set_pipapo: restore cloned mapping table memcg accounting
Date: Wed, 28 Oct 2026 17:42:04 +0100
Message-ID: <20261028170508.974470096@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

The 6.1.y backport of commit 69e687cea79f
("netfilter: nf_tables: missing objects with no memcg accounting")
changed the pipapo_clone() mapping-table allocation to
GFP_KERNEL_ACCOUNT.

The later stable backport of commit 07ace0bbe03b ("netfilter:
nft_set_pipapo: do not rely on ZERO_SIZE_PTR") rewrote this allocation
and changed the flag back to GFP_KERNEL. Upstream applied the
ZERO_SIZE_PTR change before the memcg accounting change and retains
GFP_KERNEL_ACCOUNT after both.

nft_pipapo_deactivate() clones a populated set before looking up an
element to delete. If the element is absent, priv->dirty remains false
and the clone is retained. Its mapping tables therefore remain allocated
without being charged to the requesting memory cgroup.

Restore GFP_KERNEL_ACCOUNT for the cloned mapping table.

Fixes: a4983e89e3b1 ("netfilter: nft_set_pipapo: do not rely on ZERO_SIZE_PTR")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c27ba1c5ae5da..2e98592a04288 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1466,7 +1466,7 @@ static struct nft_pipapo_match *pipapo_clone(struct nft_pipapo_match *old)
 				goto out_mt;
 
 			dst->mt = kvmalloc_array(src->rules, sizeof(*src->mt),
-						 GFP_KERNEL);
+						 GFP_KERNEL_ACCOUNT);
 			if (!dst->mt)
 				goto out_mt;
 
-- 
2.53.0



