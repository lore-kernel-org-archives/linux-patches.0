Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062495;
	b=FLLBb2jQirXck+2zcmHKTbcsU6oymd65t/x9ZuswIS576+bRYbOU8SNKxfw36Gv6JbFt
	 WlzVlxfcNsv1NUco/LwW/aWCqP2pwVHmVfNXCkEoTkS/UhtYDKLgXUZkY0VYzJQApF+PE
	 BPWcyLnexbapfWBfl05B/405uKmRrwZYCNIA9Z1Qc/HUO8tQ/ENt6hnC5hMBN2ZVlSDAI
	 KkCOM4cb1y03lr540aT5VCZi08V2nvaRsny+bz/IqNrd43Tno+qmnOPg/2RNsgiqf8UmB
	 VMW4VJblwtRSgp0ivLTvReCpEa7nlPAJdn4Rki8OYA2c3o+qd//RtFX2Vb+swUxnj7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062495;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1gk9Twlh/AcmHi7P5YMretMyrPxWFcLmGcDWUOAANz4=;
	b=lNaXV2MpOUfb7zjehcu7ZDPW+ARMFJwFmpAAkn725yEgvv5y4Yk8D/IWBevo2btC8pm6
	 F9t0sc/MkLyuqCo6d3Cnwt6WYc5NTaj+Qe/ZmcVw7FAQCyxI3EGgrU8lH0zJ9TXDXHWCD
	 Sb3KSCX5CddOTFI5BNDb7YVUeylRpLalI5VPdFxc5ToCvGEXADV45/bfO2/ZKNtjBy5xa
	 JOn9xuts5NUp3EaR57Iz2llNMBJhuqHk8lrX4XZoMEIcjcp+03zDPC7rLtl7yUB9iorMw
	 +Jc0ekfdonAuFzsv+mynwjCK/cdRJJaPl6wrDwr9fr6/hY82v9Vx5FfTXxOISvl7Jjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmtYJi+2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A51D606D82D;
	Sat,  7 Nov 2026 14:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OmtYJi+2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC3421F0089F;
	Sat,  7 Nov 2026 14:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062495;
	bh=1gk9Twlh/AcmHi7P5YMretMyrPxWFcLmGcDWUOAANz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmtYJi+2Wjq85YpRhPDUfHbl/wjosFT8nyw3iiO1qI7NYfmYoRJnlQy3yzxlhIw+F
	 K6QmwCip7TZHOwN3DZ7DVgxFqvZJ7qG4VabyXYuR/seyaMzrfd5WuPZ+2pZhth7CAj
	 LXId/nb1pN+kWx8OYciecK8CJCSVXVgjgCbsBozU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1393/1536] net: unix: reject negative max_dgram_qlen values
Date: Sat,  7 Nov 2026 08:56:49 -0500
Message-ID: <20261107135036.952567590@linuxfoundation.org>
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
index eb2c136be63da..9e3da2008c412 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3300,5 +3300,6 @@ l3mdev_accept - BOOLEAN
 max_dgram_qlen - INTEGER
 	The maximum length of dgram socket receive queue
 
-	Default: 10
+	Possible values: 0 - INT_MAX
 
+	Default: 10
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 357b3e5f38472..cdd75f68267cc 100644
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
 };
 
-- 
2.53.0



