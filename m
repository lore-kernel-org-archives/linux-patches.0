Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E4A28B4FA;
	Sat, 12 Sep 2026 09:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204251; cv=none; b=eQCedjJKzkpoDdjfRIealb14491rA4F9yILQvuk5ybnpThjLmDgeeRJVP8J4xpK3+mhJ9gLAKbXFrLTnr/YDqQE2qW1JbqvOKPA1q7ysnRjrOaFpJbT71rHcldqRqdsp6khYFdjlUzSDvE5k3z6fmqzjvoZ4deXevIYsPI8POvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204251; c=relaxed/simple;
	bh=G9CufTA6VgqW7K2Rck74i0ScvhlNs9oUesZ18oNIVnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mz7SD3f6345GwP6HypWsIcFVZNR6I4KRFybrDGFJuKuTho4lgqazkUp7YWt94flTpyz9EHF9HUYWvGZHwOZkI13VpF35wJNTo2/XqqWSi6SUxS1qMR5f59A156hWWdC3k5OZgpEPh7MojLz1cTdPRHBAGQqSWc7nrJe5V9k4bpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZAu5HhGp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZAu5HhGp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 178EF1F000FF;
	Sat, 12 Sep 2026 09:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204249;
	bh=NDMqpYo9i8wlWmRNkPQtb1/suy7aB/nKXYeb37QIkuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZAu5HhGpn6Qn9xm+aT/iXSw/Fi4DwdxoIJG4uaR6RhPRA6m6CDhkKCtBGPkadq+SQ
	 QQmA2KU5OEEMsAbYRBZCXPlRh0b0Qi1HDI8R3kZ2scf4uGLwfrjQFrFpc2iJp5soW1
	 aP+vlHWEqCg2zhmjTK9AhDAeZPWliOt3xX6GUjPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1574/1815] netfilter: ctnetlink: do not expose expectation DEAD flag
Date: Sat, 12 Sep 2026 08:55:24 +0200
Message-ID: <20260912065725.942540384@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 322371b09058ad10d0282a0e7ec8eaa764e6aaac ]

Expose expectation flags included in the NF_CT_EXPECT_MASK bitmask
only. The DEAD flag is internal, do not expose it.

Fixes: b8b09dc2bf35 ("netfilter: nf_conntrack_expect: use conntrack GC to reap expectations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 31cbb1b55b9e6..11e873a0bd149 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -3042,7 +3042,7 @@ ctnetlink_exp_dump_expect(struct sk_buff *skb,
 #endif
 	if (nla_put_be32(skb, CTA_EXPECT_TIMEOUT, htonl(timeout)) ||
 	    nla_put_be32(skb, CTA_EXPECT_ID, nf_expect_get_id(exp)) ||
-	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags)) ||
+	    nla_put_be32(skb, CTA_EXPECT_FLAGS, htonl(exp->flags & NF_CT_EXPECT_MASK)) ||
 	    nla_put_be32(skb, CTA_EXPECT_CLASS, htonl(exp->class)))
 		goto nla_put_failure;
 
-- 
2.53.0



