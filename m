Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033429;
	b=X9JKbggwZ+M1/N2vS9/Gc3SPARwIBmSZgt08uec4XzfyRhtWl/iDZtk9rod7SvOjKVhL
	 Z4jBfqI9lh85Ui3mj9mRZMHbrlDvZZ4DoRTHKw856Sjdk5lM8ekFJi4XC7kOhVau7kAOY
	 KeCbwXoq7T5sjP9h2pig/Za0PlwMN6xyFt0N05/rXuFSE0Vi9d/nVvk4a3PAPW8kG/CAp
	 Qp2jdQPZesIULDV3eSDs92vvE6W1yJGxge30F77R47jp6t6U0Hv3q23jKWeM/3m9q+elr
	 RJH3SyEbyQvfFcaRZgDUSWeXzWq5iR0jx5kfcrkaRz6gdoihpVzc7tndPytM506MB0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6b0bmXpTb2POHcluIZq10kHjn4U6FxTE5tAyq8gr8YI=;
	b=Yn2Df/MHDXBJD63rJinRlpOP0SBz3xwz5Y5ECjiS5JVyhnZ5x8s4QB5NrN7kziaeAvPm
	 nxVS4DcLkacVTQsGACEtMxDHhANX9rHf/+qaFFi1hIiV7hMPmj7EB0WC+VRnDWzhiFzxX
	 Y62A0TzjpE7Sb0wff1LMApX2ooU6lHFNm3KzsfeUWVOG06y27mPJ1CKEgbNIBpxKAA3EI
	 uKRDNMu4KKQRNWZqtOi2fHtz+30g8Xyxu1+SIqczXkaCKRMroqcJajF4kP2bmKVbD+3KA
	 7ya8QEXzNg6wTqlM9iTqHjQ5O+bYQWyHp4qjMxa0jbHuWGEqo3WSYk97HzlAOVxr1Sg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GcX22W2j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12A4606A31C;
	Wed, 18 Nov 2026 20:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GcX22W2j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20C61F000C4;
	Wed, 18 Nov 2026 20:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033428;
	bh=6b0bmXpTb2POHcluIZq10kHjn4U6FxTE5tAyq8gr8YI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GcX22W2juWjOuoWO5Zaj7gBqVSxx/3x83XzfBWYryezK5Ozcz3lWYs9WxntNmmJhq
	 0F2dYFq1/p2SfmepEvV2Ofo7SOzbqy0yVCJW0dk6eL3Rt6HK6McGILZYqWMvLLFFaG
	 670/MvOBpr5k+HvlpDN5b4az1OWodmu3wa3ckMfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zizhen Liu <pointerliu@126.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0004/3318] net: skbuff: propagate shared-frag marker in skb_zerocopy()
Date: Wed, 18 Nov 2026 15:10:26 +0100
Message-ID: <20261118150313.745356913@linuxfoundation.org>
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
@@ -3649,6 +3649,8 @@ skb_zerocopy(struct sk_buff *to, struct
 	}
 	skb_shinfo(to)->nr_frags = j;
 
+	skb_shinfo(to)->flags |= skb_shinfo(from)->flags & SKBFL_SHARED_FRAG;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy);


