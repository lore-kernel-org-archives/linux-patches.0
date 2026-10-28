Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213232;
	b=i3uzC+9g7z+AhE+OcY4KCmdcueiZDm7XSsrT3WaDiq9ApUQvunU26UqcniCElo0lrDYS
	 7NpTGjsoc2lSnbaVAK2IrE/BhTTawZ5LZ0gO/6wmv6l9cyRQu3/9iSHyEqf0TRWlR7Bif
	 58Kooyl3L+uymiKdY+YyqtBo2+kGS2Z2eqJcj65eIj4SiL68H7nNmxEdDPDC046IHfNPW
	 hDtnvLjrbImamJmXOJzw7JV83SsCoSxuusxBhdKI5wcs+pVjIJt4HROPZwSvbB/F0nY1j
	 qFLYx6WBaftugV/61EoscdMan2t9sCJl8nLMQLb+tvwsmZr2QxpIw+2k81xOrBzRrwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213232;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FCryEU4tzrQjjFauDU1ma2W8cVajVBVVBG9dw/r9wb4=;
	b=U9bhm4Rl7uvoieQJqPWRBHDtqvW7UT/WzwwNYntUiaGGnP1IfE8q4iV3efbm6mtQg4WV
	 RbOK1GDrhifA+fo42QxoYjb0i5HAh0eJlDxupAq8Uidb8eGC3p+0SM0/vbfWAvoN2WJfl
	 8spCj5zoUzYWVcQpFdn+ZJTWfQmM1ezCy95AA2Ojb9dFHn1fMqd7+85LSTqi32q6MlfHg
	 UaL3hpTDMN1+IViCPpbVdq1yZrSZoQRVv2GwEHXltpys5KjREDYK//ILMBx5gRPUoOr+T
	 3xXEgE9FmfWmE7shb/bNIAVJ+z06FChrqI4CPBmAFcf5DbfS0fSXaEKqWnQ5BEY0s8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=St0tylKX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237EB606A31A;
	Wed, 28 Oct 2026 18:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=St0tylKX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3482C1F01825;
	Wed, 28 Oct 2026 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213231;
	bh=FCryEU4tzrQjjFauDU1ma2W8cVajVBVVBG9dw/r9wb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=St0tylKXA7PAQwFuKn6XIVzKRGDvg7YlYUO+VX7Cqsr5FvB6D5yjC1OwO8cJ9CJO7
	 6pPHjDg3gbbgI1eFzT/uhZRUqqKI2utMF0TZSxVbz0OisJUPpEyZCG+jUnaJ8vYLFj
	 LnGNLASnv6U/CalzN3R3pA+SdxbjZg9Hp/d5RmIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daehyeon Ko <4ncienth@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 0431/1887] ipv4: stop route notification sizing when nexthop group shrinks
Date: Wed, 28 Oct 2026 17:42:07 +0100
Message-ID: <20261028170509.041336208@linuxfoundation.org>
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

From: Daehyeon Ko <4ncienth@gmail.com>

commit d3daa33c7af92e38f2274bbd2576f58bfbaf89e6 upstream.

Commit 680aea08e78c ("net: ipv4: Emit notification when fib
hardware flags are changed") added an RCU-only fib_nlmsg_size() call
for asynchronous hardware flag notifications.

fib_nlmsg_size() checks fib_info_num_path() before each iteration,
then fib_info_nhc() independently reloads nh->nh_grp. If
RTM_NEWNEXTHOP replaces a group with fewer paths between those loads,
fib_info_nhc() returns NULL and fib_nexthop_nlmsg_size() dereferences
it.

Stop sizing when the indexed path is absent. Nexthop groups are
dense, so the current snapshot has no later path.

Fixes: 680aea08e78c ("net: ipv4: Emit notification when fib hardware flags are changed")
Cc: stable@vger.kernel.org
Signed-off-by: Daehyeon Ko <4ncienth@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/1054fa46165bba1b473782fa41367804aa908e86.1790915964.git.4ncienth@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_semantics.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -514,6 +514,9 @@ size_t fib_nlmsg_size(struct fib_info *f
 			struct fib_nh_common *nhc = fib_info_nhc(fi, i);
 			size_t nhsize;
 
+			if (!nhc)
+				break;
+
 			nhsize = fib_nexthop_nlmsg_size(nhc, nhs != 1);
 
 			if (nhs != 1)


