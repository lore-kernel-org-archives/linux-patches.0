Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619240;
	b=aaBSgW98358kT+09PUu3k1RzEk1/MEQY01qhIEsu2dnC2bAzzQOuuV3f6yC/Z7LRbODa
	 pJFGwUrqAo+jduJHlkA4424I2g6SZOROOTwKiD3pBfp9hJo9aX2yYL3V85BQOqyNEcqeK
	 YK4+G7Dc4yoKsMIXi09l5VO80H3sP8lB9eOQcUBwNDlD1EgnU51LBUB6FkoBoVcSqfFJE
	 iGVwgffJQFAPSBa0n+i084KXo2rkLSfVLA5vF2+6b/otkSy87l9tDOHZe46j9d5RSsaJQ
	 k93Is0RtcVO/yKtAMR+TTRsW3PIEiuShADWJJWQAl8j2mLa+G3kwgS19qo72qXVnclQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619240;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zRrpl5SLgCFNDi+k5kuyUN2HIDWC/5D8/gABwn3Uue0=;
	b=u1cFnMZgzxoNS2yx/cdt0rY0HwhjqMfs9ha8cq/KDzWTqry7ao6/I/6MxzJD6cvq5Ebe
	 cMeFeeZWW/lYNyqKRj5YIA9z2f2JC6MRE59ioolXf/pk0MhErw/kIJCIEBQeaIEt0Q+eI
	 TbMrWTLy6moldRJvWo0iWmoZk/apOqndtuoJ+ixiR8Z+n0X6M+WAXcAELm75NVfzFfdQD
	 T1zJ/t2v9JSP3uUU5nr5x1qBbCVu1dJpmFQzAN82kYKfHicXRB4M8e2KqqgSKT84U2wn+
	 VQ4mYhGdUtmVQ6TGfiVtgEoZWJa0AKa6kSzWF6fxrMuyucrQPw1dCUmnROLRMYxy4rA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNUxoUmH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E4CC606A31E;
	Wed, 25 Nov 2026 15:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hNUxoUmH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 666A11F000D1;
	Wed, 25 Nov 2026 15:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619239;
	bh=zRrpl5SLgCFNDi+k5kuyUN2HIDWC/5D8/gABwn3Uue0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNUxoUmHin0/8Qsr3/98yJC69AFgGrjbcYNAu61LgT/yVmKJgH7y0qJ0mIaU9LEHB
	 OtLu/z8T+gI5ERQR3Jk6GHhfEPUH30ljXYGvh49MtepjuK6gP+VPUffqL8QArRYwgY
	 ODFgU4opL73XumMsp2wmo1ehd/1p6KNffSmqgDw0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junyoung Jang <graypanda.inzag@gmail.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0533/1005] igmp: use the joined device when leaving a multicast group
Date: Wed, 25 Nov 2026 15:31:11 +0100
Message-ID: <20261125143834.233371916@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junyoung Jang <graypanda.inzag@gmail.com>

[ Upstream commit 19ec8416a76c08326fe5f814410a1b43046e63be ]

When a socket joins a multicast group, the ifindex of the device is
stored in the socket's membership entry. When leaving,
ip_mc_leave_group() resolves the device again from the request. If the
request only specifies an interface address and that address is not
assigned to any device, no device is found. The membership is still
matched by address and removed from the socket, but the group is not
released on the device it was joined on.

The group is then leaked on the device until the device is unregistered.
An unprivileged user can trigger this by joining with an ifindex and a
non-local address and leaving with the address only. It can also happen
when a socket joins and leaves with the address only and the address is
removed in between.

Fix by resolving the device from the ifindex stored in the membership,
like ip_mc_drop_socket() does.

Fixes: 4eba7bb1d72d ("ipv4: igmp: Allow removing groups from a removed interface")
Signed-off-by: Junyoung Jang <graypanda.inzag@gmail.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261109125312.2208874-1-graypanda.inzag@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/igmp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index d56355aca7977..4221f2b9c658b 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2463,6 +2463,8 @@ int ip_mc_leave_group(struct sock *sk, struct ip_mreqn *imr)
 				iml->multi.imr_address.s_addr)
 			continue;
 
+		/* The drop request may not resolve to the joined device. */
+		in_dev = inetdev_by_index(net, iml->multi.imr_ifindex);
 		(void) ip_mc_leave_src(sk, iml, in_dev);
 
 		*imlp = iml->next_rcu;
-- 
2.53.0



