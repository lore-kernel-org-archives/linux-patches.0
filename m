Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590178;
	b=jaAdSjoPsIyJvMfb/CWiZVQpcD//p26jawvFvmcZgmpYHz4+gKjBg8+V+YtI1BriZmfM
	 haMmdC5aZLjsWVSEo0sJzma7KWjVo6AreLqrgYhoVAnGvyGcbCsVOokktu3ppKcP5p5Re
	 5ZOS4ds+LG8Gv0IU9cFGR5DPeDhDCHDf+BOBsr1EweUf77TBZHe02oDWFwYG+wyN4D7yr
	 F089Own5aSBxCojRYZSgRtuaZKi9TRosbcH5pjZ1NG76vjBABSLSH0uECoLJOojxoyvPF
	 SffGZ/n2IIT7cr7Rkjcv7vKqeCBGFsxU4GddxO/GndgVObbt2sL03pQs6dBaLbySEPQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590178;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FlbGYkZv7mxn2kn2a78oeJOGJ4otMceqedHXIxsDuc8=;
	b=Hq2/6WP9jAZY+GdXy0JDw60DrUU7Y4AK2UgU6OVMR68BsjjKW896iPiI4DWNE9snQzWp
	 QkSNV5FMF4QrQg/Mx+/5A23+RodMcgFF/76TNydP8Dd5AligANKCCVT+OrOOnQuoVmiiG
	 N8pMFlWV/nQa18CD5l5vQ06LKzzc5XmrRH5BtbsivCVwjX95rLUI6w8WXeaYiRjeiuKgh
	 nN45yOZwuaU7DpTvsVtRLWaEL9Bxs+c56w7H7dLl9IfM5qhKrS1istoivCKaPWS+xe+tl
	 9fGFl/6iMSAOJTgRAcXRCYBNXUXFz/xLTW8/R7xl1FTy720j2aw+9mEIAJ47F6+JP1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="PK/uJttQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36BF6071434;
	Fri, 13 Nov 2026 17:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PK/uJttQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 803CF1F000C9;
	Fri, 13 Nov 2026 17:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590178;
	bh=FlbGYkZv7mxn2kn2a78oeJOGJ4otMceqedHXIxsDuc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PK/uJttQxNARIo+G2WfU/jmudGjs8IZtl8A2mMHe8Gv/ms+lSPu1nS3HPZdQRH+XR
	 qErRx+3X1klsqfaZ5NMcMqYpMug/qavwqn6377clDLi6YDNiP08EQOI3tBDMYNZR0u
	 8GZ2K/tBtldpz54IVzqd8jtqpaTmqrxiRm3pg+wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bernard Pidoux <bernard.f6bvp@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 144/686] rose: give the sysctl timer limits in milliseconds
Date: Fri, 13 Nov 2026 10:44:37 -0500
Message-ID: <20261113153825.681576370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

Since commit 82e84249f0ee ("[ROSE]: Eleminate HZ from ROSE kernel
interfaces") the ROSE timer sysctls hold milliseconds, converted with
msecs_to_jiffies() where they are used, but their limits were left in
jiffies: 1 * HZ to 300 * HZ for T0 to T3 and the holdback, 60 * HZ to
600 * HZ for the link fail timeout, up to 65535 * HZ for the idle
timeout. They only match with HZ=1000. With HZ=100, the largest T1 that
can be written is 30 s while the default is 200 s, and the default link
fail timeout of 120 s is refused: once changed, a default can no longer
be put back. With HZ=250 the limit on T0 to T3 is 75 s.

Seen on a Raspberry Pi node (HZ=100): writing back 200000 to
call_request_timeout or 120000 to link_fail_timeout fails with EINVAL,
and 30000 is the largest call_request_timeout accepted.

Give the limits in milliseconds. With HZ=1000 nothing changes: on a
QEMU bench the defaults are accepted, and 999/300001 (T0 to T3),
59999/600001 (link fail) and 65535001 (idle) are refused, as before.

Fixes: 82e84249f0ee ("[ROSE]: Eleminate HZ from ROSE kernel interfaces")
Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
Assisted-by: Claude:claude-opus-5-5
(cherry picked from commit adb6f95e07482fb8aade33a20454b8a2a0fc7953)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/sysctl_net_rose.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/net/rose/sysctl_net_rose.c b/net/rose/sysctl_net_rose.c
index d801315b70839..a82735c34871c 100644
--- a/net/rose/sysctl_net_rose.c
+++ b/net/rose/sysctl_net_rose.c
@@ -9,13 +9,14 @@
 #include <net/ax25.h>
 #include <net/rose.h>
 
-static int min_timer[]  = {1 * HZ};
-static int max_timer[]  = {300 * HZ};
-static int min_idle[]   = {0 * HZ};
-static int max_idle[]   = {65535 * HZ};
+/* The timers are given in milliseconds */
+static int min_timer[]  = {1 * MSEC_PER_SEC};
+static int max_timer[]  = {300 * MSEC_PER_SEC};
+static int min_idle[]   = {0 * MSEC_PER_SEC};
+static int max_idle[]   = {65535 * MSEC_PER_SEC};
 static int min_route[1],       max_route[] = {1};
-static int min_ftimer[] = {60 * HZ};
-static int max_ftimer[] = {600 * HZ};
+static int min_ftimer[] = {60 * MSEC_PER_SEC};
+static int max_ftimer[] = {600 * MSEC_PER_SEC};
 static int min_maxvcs[] = {1}, max_maxvcs[] = {254};
 static int min_window[] = {1}, max_window[] = {7};
 
-- 
2.53.0



