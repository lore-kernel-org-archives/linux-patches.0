Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052879;
	b=BvqQE4cl8KBqP5y9+adP8L6xYpMWewZfsIjekFkaBXZcsG47ga3DLqqNPrwA4+XH5FJg
	 K1sO197ihgf1Ijq4I6gnm0gK6aYMkhIX7OMNjS9Z3jwAx6KLEoF0MF59NAvKJ25mavqhF
	 0hms+03V57vbS5sYnJ8fpAyZiTpn1d9rujEFKyi2iNv+HDV/2kgTS0M5ZaYj934HqagiV
	 tmUPtFjbhelcjn9Fj87GhK9BsVf2xgDEg6RgbYM7kxdTRzHmMnXuRVo/XkLWFABYZS8B9
	 XtgzNKu77OmsBOq92/mU6Uoyerw29hkSR42CABW514KI5cufqe5pIcVqS0JxLvt6V3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LcWuEW4ZZ3cee1rZliXU9OCkp/FWTtZSis+1yII/wwk=;
	b=lvrqJbRWOPNSP5QfXI3H2niDLIjTz5P9uB9SDkGelOz7yUA/QA3i/nvmNueUbELDRAWt
	 Pa/i8VRGV6ZJHpEcbxiON3SCH6RScRDbeHMDcV+lmNBM6SCDtYD0er3Z5/nfQRVpZDpzO
	 dtDwlWczR5+26OIV06VyPNj4NCB7Zgaiq0r/VzFHM8HjtBMN2vQV75dQ83x9jvyL7HP7A
	 9Vtx2gcNT7CIIHiKSJkkipkfB/VUMy6AXB2sIdWi4x9lLp6lAuTEpyZ83J+hIGxBthHF/
	 x/K1VndPGK3l7p97SEb2rWhWAX2/TqQ37kTDD6CnAhGcL5gvbuuQl5/9E3BwNOW5Pvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJqTbg73;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D456606A32A;
	Thu, 19 Nov 2026 01:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cJqTbg73
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E551F000C5;
	Thu, 19 Nov 2026 01:47:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052879;
	bh=LcWuEW4ZZ3cee1rZliXU9OCkp/FWTtZSis+1yII/wwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cJqTbg73kiDUwlkpcHmIR6LjeIpEYCAFPFy0MlwHSmi4YnhUYQAqWKLl9/X0l4yL0
	 Lc/7lOxloy4NKHYbeFrlK+KtyNgmnUZ1hdxfYEeVP8SQCNelJYx7ZQo86wRkvgOLMQ
	 zOPxHDbNAtiLVeyi5jw8Zt/bQ7FEZPPpVOgetrg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0683/2214] net: unix: reject negative max_dgram_qlen values
Date: Wed, 18 Nov 2026 15:39:19 +0100
Message-ID: <20261118150039.084355321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 883a336309f9f..a824fd4570c1d 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2895,5 +2895,6 @@ plpmtud_probe_interval - INTEGER
 max_dgram_qlen - INTEGER
 	The maximum length of dgram socket receive queue
 
-	Default: 10
+	Possible values: 0 - INT_MAX
 
+	Default: 10
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index c09bea89151b2..1b8508865bb80 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -17,7 +17,9 @@ static struct ctl_table unix_table[] = {
 		.data		= &init_net.unx.sysctl_max_dgram_qlen,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{ }
 };
-- 
2.53.0



