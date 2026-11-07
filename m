Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063558;
	b=TUO/+fTsrbkqDVfkV0MzGz1wMX4BLhUMrZ4ONPbSYeqKAL9jNjB1sTw1ZRwxUEq7JKmV
	 S5dR94wuCwIT8NCJfJndMKF8fQtK3x6OKaoqbEw+182ZGK+vh8oUW9MP1B+rItq8bAvv1
	 jJ3n5Zyu0UVgFowSKHs74vVlR4/AX0eCEtSzvyR2IkEQLFmqivPmj8a5UAY6ld/iFLsmF
	 S1RKpviVvzTLhamWXSXpIGm/xQElSF+9Zgu1/KLS+3Z0jQ8yRqYY5tFFd4vcxxJQcWdY+
	 m7x/nOyQpY4G3Prs99Uz89ekOO5KsH+ZPNm7scyEJRmahR2mOHXARfQt0BBHrXG3hVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=waNpwk8NJ4K09cZzYRyPiStw4A3KAaU75lC2TY8vlys=;
	b=EplX0knai5H+DiLBjbgockJIZVA/4XSZ87+FmbGlsn/FeQiN1v70p4DJgEVo5P8nIfd/
	 DQAOeINZ2PVZtKEgaMseQXGIaMeptblllHG80FZv1FRFeWv4xC9er2mHy/Hez3aPCuqa2
	 l7SU+8ptMMb1oc7ehAnouNkjEPLf/Sw7fWGBrvzZl7C4R30yVxa4lJWp7x7/8cNBqMe8h
	 e+067Ob/exMTs2tK6Htmth1gEYyDWcs+Bj5z8incFhdCwlS/n8bu1e6HVXsDTDcAqgDnH
	 38enSTh/iVDCGA4XidLE9A+1YIej3Dd0ZXdldcwd93BerhLB0EvPqpJiNE3o5lZ4QSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="q/whuvkL";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04BF26082BCF;
	Sat,  7 Nov 2026 14:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q/whuvkL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A85A81F008A3;
	Sat,  7 Nov 2026 14:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063557;
	bh=waNpwk8NJ4K09cZzYRyPiStw4A3KAaU75lC2TY8vlys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/whuvkL+NAAlhT0VJt4EfYsLmM8oUXIwS6YNCycn2yBF1TlU81eIi501gpQR2jrO
	 yn92e6bScc1TTHwfsRirrLD925R9j9Ve7BfVirAEVu7p7iB1MdwiQW6odfKoY0cx8L
	 vDHxR1HQvouOtzFsxnRrnjATXvj27xu7UzCfTm84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 692/869] net: unix: reject negative max_dgram_qlen values
Date: Sat,  7 Nov 2026 08:56:14 -0500
Message-ID: <20261107134916.465890067@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 27a861053b2f5..c2ca933f7bdbc 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3729,5 +3729,6 @@ l3mdev_accept - BOOLEAN
 max_dgram_qlen - INTEGER
 	The maximum length of dgram socket receive queue
 
-	Default: 10
+	Possible values: 0 - INT_MAX
 
+	Default: 10
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index e02ed6e3955c0..bb93cf3aa6fee 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -19,7 +19,9 @@ static struct ctl_table unix_table[] = {
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



