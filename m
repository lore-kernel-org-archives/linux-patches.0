Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042902;
	b=n0QeL/kBkZgvJIYerDtCZTkyOnuNsfSJODfRkHZWhy2qETI0zaHcbx+mNXd8AWIIBsQa
	 DBCzTwtm26psK4cOfExSdpU9AuTOmmtiWfj1H7vqNtmGBd9Cyxcd5KXNHUlAdIOHxWz0b
	 bOICDmFwfG53qmtSMqRGby2bX/fk1qlYf80ykouVCUCHU7LylYzCFyj6fB9gRZP/K9UF0
	 oosSRM1Edt+LgsdEB7MPMOLkI5jT3CdX4VtGrT0p/AjWgR3m5mWAAaUjeI7RKu4Wss3X2
	 HOCjc/7xLzwiQBYEqptvXSg6hfJ4hc/hDXNkG5KMJlvr1AEKtU7GcOSekjWj2njblEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3G0nhJCl5OYMB3/O7sQYbDhxJgBtiiX62eSutIVXM8s=;
	b=0jUEtK08oxc4r9Ud7s55gNP7xV6wvQkUCpHk7hC1Bzjn/BovYifhtYzAhBBERNSyksRW
	 er4h2YS+0q4d1QSZvk40nMZUV6rZs/BLyYuFwMBWpuHqUHkpTAVASxLCtb5IqEXl1i1Bo
	 HOPA3169hVh6vuAxC332sZ/ZavKr7HU16YdUJ/DtwkPnHRPi2K5sedwvK07N5tmcCBTbV
	 J6sRzqio1b39MQeaOpOZHEf2fMXpzcovcH5xEbp1Qos+X2MdfDwaoUuuotB2tvmPiNCFC
	 4RrVlPP5vEpy5/Gm+J8CoeE4H4LCgXaRjFAVEFkxr1ak7QdlNi+M/oHy1c45iL0MPVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TU7be4m3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08FD606A325;
	Wed, 18 Nov 2026 23:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TU7be4m3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C42061F000C4;
	Wed, 18 Nov 2026 23:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042902;
	bh=3G0nhJCl5OYMB3/O7sQYbDhxJgBtiiX62eSutIVXM8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TU7be4m30k5E8IGeoY4rvO+MEIUbVdu9JaHYnQyJb4N7vlP/iebxjeXyZeWov2zL0
	 p3+yplMf04cemRZVRMZ+qazrTsxeTcSVHVAh4cKQWSWcfFW+7OwsK8732RNy/cNh1o
	 jlVKA+ArQ8ZuD4k257B4FIm/yx1MD4D6hmgR/3jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Zizhen Liu <pointerliu@126.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0003/2857] net: skbuff: propagate shared-frag marker in skb_zerocopy()
Date: Wed, 18 Nov 2026 15:17:17 +0100
Message-ID: <20261118150201.447584719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
@@ -3376,6 +3376,8 @@ skb_zerocopy(struct sk_buff *to, struct
 	}
 	skb_shinfo(to)->nr_frags = j;
 
+	skb_shinfo(to)->flags |= skb_shinfo(from)->flags & SKBFL_SHARED_FRAG;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(skb_zerocopy);


