Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623919;
	b=IuuztC/EHtofEPVXwbpFrlqD1JckvKL1bDfWB17cjsZw4s3JCULmCgzf4Q5yTh9/Rnq4
	 xdq8sIAPIVAwSPSQkJipet84b4osdT1OXexR7WtB2yodaruTanEWFEYGdcHHEaX78Qrww
	 qsDGdCrbe8ja7Me13lq2Cr2TU5jEap7R9PoA3i65c0BVX09FSU8kRWRQ8PYOGTy9rE/Mm
	 8uCIw4/dK31TC2kSBAMYYXAtx83RSqxmNM71aM4MJ/LKAb/5l6IQCnz+XSXIqiTwmW1M7
	 /viLzawVdIS1t6hHSvGY6GYm8r6Y4NEf9eOpJqQgfR69+FWLq2N9iKuch8UNcE1jN8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623919;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xm6kkHxstscDbD2AliLGIxiQvXtOaPl9LQwR7GQW3mU=;
	b=bLWaVbwhAiUxcL1C6akHmHnaFhc7R+BTEkmy8J3M9gR5zXHCv2RDqEu5tzi5zqpthOqE
	 7+HSLNReejgS37AoFASv5lXKRW5p9Y2kPlqcGehv2KElUXcGEAO29nF+U5nrUNEcEwzTv
	 HUA7poHuVD9U4iyje0YUNtHtszNkt302zK8L+jwXDuADOJBcy7ScxS+hM1pb+iGgreCls
	 swhVgybafqBbGOy5Ud1T2LP+yoNHy6eIC8z2ejBdbcNDiQtevVaA/pzdKxl+QQIROLC6T
	 b0dwYncp3LvJYGmYPY7TDwwCRguWzRjmQ9SocvbquOQiNF6a0rrB3VRYrHl4PpPs03w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDlvLsg6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730B4606A327;
	Wed, 25 Nov 2026 16:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hDlvLsg6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C29A41F000C6;
	Wed, 25 Nov 2026 16:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623919;
	bh=xm6kkHxstscDbD2AliLGIxiQvXtOaPl9LQwR7GQW3mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDlvLsg6ANv2PgVaxXYOOnmT4kZEAiBcdaOiWqgliCk+Kf3xf+bCrN0a2Mz4dr3am
	 SFo3El+xyWYiYa5oLld8/OpxyE/fN2bTElgz9JZfTKZ9QM2t2iqykL9gNGaGrt2s9F
	 VS9mNLt2rqqd2fO4AVGFzzBCGnGprYtDiFc1n1Z4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/816] netrom: give the sysctl timer limits in milliseconds
Date: Wed, 25 Nov 2026 15:26:15 +0100
Message-ID: <20261125143849.844932158@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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



