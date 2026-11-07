Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794059973;
	b=pvD+yyR7ol9bJt9b5erBy/A8UAg3PRVZU0pjoM2MXl/2jHKWD82Vyrjums8W7xESVdzO
	 VVXhYXCXxlfYh6FGJ9KUESeZdn268xeS47UQ5Ol8cElz3YDtaANBdpGRvyI4wOdY6U491
	 VWfDM3q5urtn13KTwsY3ZAGWWEP1+MG9NIQYCtK+IY0T3gJrRZhw1rQ6B2fWsYpvN4Dp4
	 gmJtzbVMnb976TXDgWi+ZljJ9ArKSxq3MwK9tYm72HCftjIBCkTc3bK12/NCyl8LLcxjT
	 L/HfcMm55VHrKlbs5xDjv9RXhivIvlxxYb5G/OrqQxk29peq479vHDhKNt0m2DVOVNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794059973;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=20gUTUUMZJ1yL0NwgXy9iJ31Pkx+EfypCEwRsHe2gDA=;
	b=qBoZ3oTS4V/KnurLl6q+xgeF5Kis7EkZpK/yWycMVLSDxr0RtI3uYURC2EjzBHw6NvNP
	 orPvxgFxkZBqVJjftYq2/advKizH5i78RIxAWpjLNjtr2e1m1o1g6yv4zaMfBIUE7Uhnd
	 wiEcGF0WLDWuDUC4IaDrug9z34LkqNNytS5Tj2XKk08IaK7xrzTWd7z9/DGlBuhqCng4U
	 E+mXIVCwUZO3H72do0V6gEybizz98gXaD65eB0tpFpwuxmKtVcooo63TZNClnP0f0tPPF
	 O4WbKfZDKwT7lnNqzJxfkC9gWJxE7SlhkbQxbk0DCWcpfMXZuejt90BxgLost1PeNyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooGrTqF0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCE3D606A32C;
	Sat,  7 Nov 2026 13:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ooGrTqF0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2438F1F008A1;
	Sat,  7 Nov 2026 13:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794059972;
	bh=20gUTUUMZJ1yL0NwgXy9iJ31Pkx+EfypCEwRsHe2gDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ooGrTqF0q1AC+mG2BXpFlKoor8PJf2zJd8RRP5xqfaJHOS1shNxRaTR1EENjkgR9S
	 OD/pBJ8KCJdENsLCk6eN22O/Q1vxGtgIz+IyZdusMnOPMffZLFwhAz1Wc12icoyrIk
	 cbFcLDQYeDGTIe7qBe5KyyErrWXFYWmp3c5jDzz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zizhen Liu <pointerliu@126.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0001/1536] net: skbuff: propagate shared-frag marker in skb_zerocopy()
Date: Sat,  7 Nov 2026 08:33:37 -0500
Message-ID: <20261107134957.708999806@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
@@ -3871,6 +3871,8 @@ skb_zerocopy(struct sk_buff *to, struct
 	}
 	skb_shinfo(to)->nr_frags = j;
 
+	skb_shinfo(to)->flags |= skb_shinfo(from)->flags & SKBFL_SHARED_FRAG;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy);


