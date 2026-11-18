Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058630;
	b=xy+fZiu/X89IYaWFOGB9uKcuaChENxDx3+kbwFppHcrjEKivSl5KyYEf0kDLEzc2hY8E
	 pPrKacgEqCE/u4rFB1sSZS0QBeZkQEq1aA4zusvP7Or1e0ZXlFXOghYaiSAsk+HZTA/Wg
	 W6lK5mj9R8oDecNjpGOSwg8zqSb6csAz1U64RZlGVvoGYPr3dGGZqjUtNa8vg4L/FejJH
	 eXI0AePOPko/xyT1NnyZ3V3CkUbVwd9TmnApMCbocex66AB4BZwovYOwrImkv0/7HHDvg
	 3LlUhWW0+NMfpipbU9N3ChFZXFXYN2cfE6dOtJNm4CbkO2orAlwvVb0gryRv1VIhrAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058630;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CONIcZLoU2YnY+mkUlTYi+79LD39isZfU94SlMcqIdk=;
	b=fTliUR3udB1EZI01+gp9WmZwpsRtL+L0Bsf4eVIAtHIB5/HEIO0Au/iJtfG5ZWYtTGdx
	 XvTr6/Bem+gQAC9S8THorK/c1/q4V0S+7he9l+iGiDwnyC5W61EWc4UHHoz7q8+4FNDLo
	 YssI1UcYxPFhtzaEBUHw6s6ivdVnKj5elaeN87l5KAIXP7/FyDE5LdJYkaF4J87B3fFXo
	 rB+HGgP9B1tqN8RXhjyjamc5tEc1G+YtuJPtenBs+rM8PLZ4rqSHKlG3qanBFbIBBRPLZ
	 FtANb7hpBXHY6AMGKXrQfFT/O8dAk0ZKx0l/kw/zKilorPfj8Bxi+EtByMhHArC9E8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=USwMvCqH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1701606A325;
	Thu, 19 Nov 2026 03:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=USwMvCqH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1435A1F000C4;
	Thu, 19 Nov 2026 03:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058629;
	bh=CONIcZLoU2YnY+mkUlTYi+79LD39isZfU94SlMcqIdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USwMvCqHO4GJ2zFyFe1I0u+iN6Z6W8nv3KV7Ywsa5FICT0iC/N+pAXh+r0+EDOfM3
	 nQbT0+IdYpPG4S5SH7O4QPVgrtFMGOhlTW4hyFhFNsrGaN1yYoeHdLFNd1gdXtMffV
	 s0FalAPTPJRvIqqEwG/5p6X1TLE2FQn3q6P46jaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0554/1848] net: unix: reject negative max_dgram_qlen values
Date: Wed, 18 Nov 2026 15:43:12 +0100
Message-ID: <20261118145938.112755928@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index fbe902b72fb9e..6ae1b06f9f066 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -2698,5 +2698,6 @@ addr_scope_policy - INTEGER
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



