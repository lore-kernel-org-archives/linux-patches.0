Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065265;
	b=zszAdCBmEpk7Id+qlTaDX+SIOKSMjxu/kR8qjLaeU/q7cGKLnDinPAs/VsYzJeZ4OFQn
	 yyjX6yFZG4F+NHMwrTkNimqv0NLrxcTCZ0i5Ow0z/7kzQ6p768SF95111d/gQ0J8bxQ4D
	 YAjMlov4BojJ+lSVG7+AEIFRbN/yYlonT/JsvlQPWPnznm2oYjAM2G/slbdEb2rDpaLU+
	 ROZLIEAPzoDB21yaKzepqaVlNhUiF3GaXcQhZZ9+6z3cAUWrkgoF4IlGCicAe/71ct6W2
	 UCZe3wljHBKum3EM5YbsBKRtSN+m/9RD+yXOfkpIX5vL4EYUOMxC2UdpTl/9PUT22kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065265;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GPeimKHjDLNWvj5PZ8hJMXJHb1JarFKH/4U3Usy6s6o=;
	b=0C+7Um7X7fyMQt6ezN3Xh+/IFip3/WJj1e1bi4eT1iJ00vxkHBSeAtpamkHwVPcyyUKK
	 vqzDtRWJ7MidsJBkKEjMtga5QD+zeqOglGpDI/cCVFo/zNHgYefcJZhslkst7prkVRC9a
	 3aVTI1tCpLBWbD8TIoyaklYtru0AIamo5odK8yg1RuB+LwDp8faZkfiXNKR2jOI7mQDTf
	 c+v/SjTBCzw4c8J/furoIS6BG+YCf4njZYBGohGoGrX85zRWS5QqNq+LMpn4oKUhm9xdD
	 C0qymMQiE9oGXWhI6uUvGhw7dcw9silNZBU2RBNn4gknzq7i4Fs9NTj/OzeDWmmk01Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppEHNeU4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B73606A326;
	Sat,  7 Nov 2026 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ppEHNeU4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A42F1F008A2;
	Sat,  7 Nov 2026 15:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065264;
	bh=GPeimKHjDLNWvj5PZ8hJMXJHb1JarFKH/4U3Usy6s6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ppEHNeU4Fno7OIn/QD4usxNQu0kGiwbVzBcLU8dR3wOkOOJwxuIoxnRV6DID78dzF
	 GXSUe5z8jkVI0yY1i4jTPkYpwJsvLxygZICFRcqKWfWEn7pK7gUXbWrsmaMFuhhE3L
	 CS3LrvpsGX3WBN2U1ID8XxeLZgjp5+d7X2jPCfQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0981/1257] net: unix: reject negative max_dgram_qlen values
Date: Sat,  7 Nov 2026 08:54:37 -0500
Message-ID: <20261107135006.456712306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Yingjie Wang <1075151112@qq.com>

[ Upstream commit 1a4e7bc6e3457ad95515a9d2c042452c3161bb2c ]

net.unix.max_dgram_qlen is parsed as a signed int and copied to the u32
sock::sk_max_ack_backlog when an AF_UNIX socket is created.  Consequently,
a negative value such as -1 is accepted and converted to UINT_MAX.  Since
the receive queue length is also u32, its fullness check cannot become true
for that limit.

max_dgram_qlen has no documented negative sentinel.  Its existing signed
interface represents nonnegative values only through INT_MAX; negative bit
patterns are not a supported encoding for the upper half of the u32
consumer range.

Switch to proc_dointvec_minmax and make the established 0..INT_MAX input
range explicit.  This rejects negative values without adding new accepted
values or changing the default and zero-value behavior.  Very large valid
values can still make the queue limit impractical to reach; this change
corrects the input domain rather than imposing a new resource ceiling.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/tencent_A643419B56079E9A448D97922763FF069F08@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 3 ++-
 net/unix/sysctl_net_unix.c             | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index f7af0286341c9..8edd2eb2ac49a 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3823,5 +3823,6 @@ l3mdev_accept - BOOLEAN
 max_dgram_qlen - INTEGER
 	The maximum length of dgram socket receive queue
 
-	Default: 10
+	Possible values: 0 - INT_MAX
 
+	Default: 10
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 47660d5726bbd..fa1fbaec3aaf5 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -19,7 +19,9 @@ static const struct ctl_table unix_table[] = {
 		.data		= &init_net.unx.sysctl_max_dgram_qlen,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 };
 
-- 
2.53.0



