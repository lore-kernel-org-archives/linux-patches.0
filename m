Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620839;
	b=ESVWC4wo+0rbye72D4V/KhreFcQ5UfJETrRhSt93wiHtbEecn8JSE+ultPVSA8xVwcdX
	 B7al/CdsjBaVx5YHi9OebrDfQjWsHM+T9OAvlzpQTwRw75gnAmWRlaWNYpKzqEK+KB2qR
	 t4N5MihbOHUnjXKYmzd0p1+KLVh+ytgs/bulDAM4TMUzvR8wA3bmhku+pVH3qNQPfBkRn
	 77vJEDYkb0/DL35wp1AaqslkyAgr1Le9FO1xfe59URcSDZ66VZdqfsuuKfGFpWtCcnZ9N
	 tFF/CTzCdlvSVIU4HvTAzn5C8rI4vpBygJrfo3X8FJ/FIKRZxDoZVTdiIKfHqyuhCEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620839;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zni4NA52Hant3rK4sdQwiqXhsINS6/+NUYgasJwA86c=;
	b=R9Ut0mKu/y2mtl/m6Tq4CxQq93qH/5okvqIp7jzs1r5hoOFcvsqIp89/R4TuYcMxZJp4
	 IC8kkew78R6rp2rorFIQJuOBKMghe7OUmmJuTjpJg93JlHKufSanPVHdtcnfujq9rtsSc
	 7JjCIIPiRgRNkceU4vE04cXNwr1sOvKJTBmUo3YYo7yV05qpZHGKJ2EARLhKGHXxvgOKf
	 lUo4KBYflKX2ZsnHryP+GvjIRb3Ioe59HtDxdBBltdVzR2SOqxij7J/vFWRmmfy9WIFTq
	 I/Powk1CyMi+joyZzzDGHSQhW9HpkSvLs8XHNaekxt7tz1IsuWbcivxHooxv9y6+pDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5cY9NP0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66C8606A323;
	Wed, 25 Nov 2026 15:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A5cY9NP0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F14181F008B2;
	Wed, 25 Nov 2026 15:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620839;
	bh=zni4NA52Hant3rK4sdQwiqXhsINS6/+NUYgasJwA86c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A5cY9NP0WmBj7H7yWi0RFqxR20/Jk0Pq5FfaQ9BpCrJK8ZeQsK72zI8bOvg1/gqHX
	 LdJT2toUCnr9Hj9CsEZ506DQvVsa7X7a5cAPBql5yZgjLdWt4QV96/0IcZV4tbb2eb
	 yFS2do85AaA/9/Ex1UwZ1ajfBD7cWIVsSRRLJ5xA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/990] netrom: give the sysctl timer limits in milliseconds
Date: Wed, 25 Nov 2026 15:23:26 +0100
Message-ID: <20261125143823.004651282@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Bernard Pidoux <bernard.f6bvp@gmail.com>

Since commit 4d8937d0b113 ("[NETROM]: Eleminate HZ from NET/ROM kernel
interfaces") the NET/ROM timer sysctls hold milliseconds, converted
with msecs_to_jiffies() where they are used, but their limits were left
in jiffies: 5 * HZ to 600 * HZ for the transport timeout, 1 * HZ to
60 * HZ for the acknowledge delay, 1 * HZ to 1000 * HZ for the busy
delay, up to 65535 * HZ for the no activity timeout. They only match
with HZ=1000.

With HZ=100 the largest transport timeout that can be written is 60 s
while the default is 120 s, and the largest busy delay is 100 s while
the default is 180 s: once changed, a default can no longer be put
back. The smallest transport timeout accepted is 0.5 s instead of 5 s.
With HZ=250 the acknowledge delay is limited to 15 s instead of 60 s.

Seen on a Raspberry Pi node (HZ=100): writing back the current values
120000 to transport_timeout and 180000 to transport_busy_delay fails
with EINVAL, and 60000 is accepted.

Give the limits in milliseconds, as was done for ROSE. With HZ=1000
nothing changes.

Fixes: 4d8937d0b113 ("[NETROM]: Eleminate HZ from NET/ROM kernel interfaces")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit e59d8b990552be401ace7750a4617ffa07c86637)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/sysctl_net_netrom.c | 17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

diff --git a/net/netrom/sysctl_net_netrom.c b/net/netrom/sysctl_net_netrom.c
index 7dc0fa628f2e7..bccc165a4a2ec 100644
--- a/net/netrom/sysctl_net_netrom.c
+++ b/net/netrom/sysctl_net_netrom.c
@@ -15,16 +15,17 @@
 static int min_quality[] = {0}, max_quality[] = {255};
 static int min_obs[]     = {0}, max_obs[]     = {255};
 static int min_ttl[]     = {0}, max_ttl[]     = {255};
-static int min_t1[]      = {5 * HZ};
-static int max_t1[]      = {600 * HZ};
+/* The timers are given in milliseconds */
+static int min_t1[]      = {5 * MSEC_PER_SEC};
+static int max_t1[]      = {600 * MSEC_PER_SEC};
 static int min_n2[]      = {2}, max_n2[]      = {127};
-static int min_t2[]      = {1 * HZ};
-static int max_t2[]      = {60 * HZ};
-static int min_t4[]      = {1 * HZ};
-static int max_t4[]      = {1000 * HZ};
+static int min_t2[]      = {1 * MSEC_PER_SEC};
+static int max_t2[]      = {60 * MSEC_PER_SEC};
+static int min_t4[]      = {1 * MSEC_PER_SEC};
+static int max_t4[]      = {1000 * MSEC_PER_SEC};
 static int min_window[]  = {1}, max_window[]  = {127};
-static int min_idle[]    = {0 * HZ};
-static int max_idle[]    = {65535 * HZ};
+static int min_idle[]    = {0 * MSEC_PER_SEC};
+static int max_idle[]    = {65535 * MSEC_PER_SEC};
 static int min_route[]   = {0}, max_route[]   = {1};
 static int min_fails[]   = {1}, max_fails[]   = {10};
 static int min_reset[]   = {0}, max_reset[]   = {1};
-- 
2.53.0



