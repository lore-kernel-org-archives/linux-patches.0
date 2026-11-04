Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826760;
	b=LzhLzhUwLVYRElMND9TyKAlWdefAlPbFdd0IgxUYj5POzDn2w4LsiZ5QIRDYgWZCJzHU
	 eOcB9H1QbrvVXiI51fs4sZ+K3275o8UpjGOpMEvelVuJSl2k3GG6Fv1Acn/X78xJ0SdRp
	 14wk0AmY0KtRrfKvgVuxOzwXif2jxXVJXyuradv7HvZOxghjVqcRtOVSZgBeP+CvJugiM
	 q3KCazR71ykWnJxo3Ektn9+eX2Yw21br9i1295Pdu2yJcsvVNrfY/72S+6iO3ifupJfX7
	 t+vetTexLlVQIgyfat9U3iXGpWGBusY0047Kh/HonsDrxfa0qLjsON9ZR81HOBxPFSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826760;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7DKAsH2pI6t6KHr47nJPrN4RKM7uzGIYlgH/kJryk0c=;
	b=SAgaBNeQ3LodlXtk4NjPMt+qHipmeHjBA6GdjQVvNopxqVxvA4moIY2rx1I4xLiPk+2G
	 I/+nFXDCc8fHhrF9jZEC5PMSYElb1M37PGutJXuSatpUVozHL2D2oSRWG3DRFrVHOdtxF
	 kDa2rVyVc+F6ffk3OKfxb84h3zNummQcvAn+T87naSVxgA8ufrPHyq37fXPFxVAs0rJzK
	 lNpcX+knssXO27iLC0kDnireV7ORotdSQKIy8nknXZdkghIDmJj0wFERnrzBhBsdRUuMg
	 Kl6b4aqO7fw2jI3ACXHCYpMJevX9Y498cnq4X0CS2ht/20vlMz7d5ShfaaipWAGak+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6jj6hd6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16AC960ABCEC;
	Wed,  4 Nov 2026 21:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P6jj6hd6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA3E1F00A16;
	Wed,  4 Nov 2026 21:12:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826759;
	bh=7DKAsH2pI6t6KHr47nJPrN4RKM7uzGIYlgH/kJryk0c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P6jj6hd6M7Co43JqSu+LTh+orsrB65Rp/1Sqzs0zGYplqj0EKtbRCw+HqDMRJiu8e
	 cWFl1Ve+RW+6AKcQro+9tKXGYyo9aKAfBlMDuy4wNp3xkIhbkAvNOp6UacD7Kqz3eN
	 FJe9aQaRmoTCE0E8kIL5c6GWqUGwk2GYM+WgqT5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zizhen Liu <pointerliu@126.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0001/1005] net: skbuff: propagate shared-frag marker in skb_zerocopy()
Date: Wed,  4 Nov 2026 15:55:34 -0500
Message-ID: <20261104211043.566861521@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhen Liu <pointerliu@126.com>

commit 79dc34beb1fdb3da79753e51e15c68591a2561fe upstream.

skb_zerocopy() moves frag descriptors from @from into @to and takes a
reference on each frag, but it does not copy skb_shinfo(from)->flags into
skb_shinfo(to)->flags.  A destination skb holding the same page-cache
backed frags as the source therefore reports skb_has_shared_frag() as
false.

That breaks the invariant relied on by later in-place writers.  ESP input
checks skb_has_shared_frag() before deciding whether an uncloned
nonlinear skb can skip skb_cow_data(); with the marker lost, an skb that
skb_zerocopy() built for nfnetlink_queue or for an openvswitch upcall is
decrypted in place, letting an unprivileged user write into the page
cache of a root-owned read-only file.

Propagate SKBFL_SHARED_FRAG when frag descriptors are copied, as done for
the other frag-transfer helpers.

Fixes: af2806f8f90a ("net: Export skb_zerocopy() to zerocopy from one skb to another")
Fixes: f4c50a4034e6 ("xfrm: esp: avoid in-place decrypt on shared skb frags")
Cc: stable@kernel.org
Signed-off-by: Zizhen Liu <pointerliu@126.com>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261022104217.1852191-1-pointerliu@126.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ sashal: Adjusted context in skb_zerocopy() due to missing from->unreadable propagation. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3883,6 +3883,8 @@ skb_zerocopy(struct sk_buff *to, struct
 	}
 	skb_shinfo(to)->nr_frags = j;
 
+	skb_shinfo(to)->flags |= skb_shinfo(from)->flags & SKBFL_SHARED_FRAG;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy);


