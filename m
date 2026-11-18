Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058681;
	b=dXMOtb9wL2pHs4GKHYznXedPlD5gnjSq5ooLG6E5bDRBIEkIYZfx58z45x1MUqmeocKy
	 uYOS2McPTfVEI/XtbDe8E6XM+il9engxU988RCPU2M69mvLkl8BvLqDzikt+aoJVRJeMZ
	 sjC0ZSrQgFx+2FoLzDpYrm+G0qnHZAYaqJtT/Ks4RO0oyIaOsNceOfTycHk2E4QeZvbfU
	 Mqq7VP+RPNPIvUGdV3H8O6f8IpzdYElztAJXc+hpmVIF/Jh9kTvgjK4RzOb6BnfoxmRqM
	 z3jjo2UtiRRWxD8xJnLFIs2h7lZT1Zt60AvWZ6xSJpfJ5hgjbfALszRQYWenxw7Mrmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058681;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qjbozt3EOMJNU0oPWvZQBzmPy7WKRBTvhC69Ca2z6ek=;
	b=Ldvzg/07WYcIJ/FQT0ycRoqYi/nsjxVH366I3I2BAiYS0FLxo6Y51KsvqTlqkPVYq3ia
	 CJbMxlO57HN7cfxKq33tdo1D8vvNsqK7CFZEPFPYdWPs+ucA67kr2KP9B20RhA9S/f0Z2
	 3c+bSQD0j+dDoHw7kMPhhef5/s99RviEsvW0UevlG+PY+CzEo0WrZSAXKndEhRTBJPbFG
	 gB1dFNt3GFlQxx9vugi8LBUy2Q3dwOD180KUgL4PGDijifHuGq11lSghZKuubSXoNkRQe
	 lYVDZAItfcEiRVzK1nq0KuAi5rOrA7OP/ZuFmrI4JzFKhZbMH7fEEj/b0P9dBYSwQ3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYSglI84;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22AA5606A32C;
	Thu, 19 Nov 2026 03:24:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bYSglI84
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6331F000C9;
	Thu, 19 Nov 2026 03:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058681;
	bh=qjbozt3EOMJNU0oPWvZQBzmPy7WKRBTvhC69Ca2z6ek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bYSglI84rtqwA6wLXlxMuvTV0jc90TYfXjWMv98UXXSnuglMMdCNjua7lL+sbn6yv
	 k3omJ2WPpbb0ti/SD6hONS+EowFr0JbKQBIde1pxKKklBD+rLFe8wuKfn1ORdYh8VC
	 j+ubg/qDTBO+wqWN6w96X8g0Aule38BHeDoW9z2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0570/1848] compat: avoid double rounding in times()
Date: Wed, 18 Nov 2026 15:43:28 +0100
Message-ID: <20261118145938.917734336@linuxfoundation.org>
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

From: Hungyu Lin <dennylin0707@gmail.com>

[ Upstream commit 6b30c39a5e333cfb1475acf0f73de6ef954eea8a ]

do_sys_times() already converts CPU time to USER_HZ ticks.  The compat
path converts each value back to jiffies before converting it to
COMPAT_USER_HZ.  This round trip can lose precision even when the two
userspace rates match.

With HZ=250 and USER_HZ=COMPAT_USER_HZ=100, one user tick becomes two
jiffies and then zero compat ticks.  Every odd tick count loses one tick,
so any of the four tms fields can underreport CPU time by an additional 10
ms.

Return the value directly when the native and compat units match.  Keep
the existing conversion for differing rates.

Link: https://lore.kernel.org/20261020210157.52057-1-dennylin0707@gmail.com
Fixes: f06febc96ba8 ("timers: fix itimer/many thread hang")
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sys.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/sys.c b/kernel/sys.c
index 811f6df1caed0..51391c646781d 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -994,6 +994,9 @@ SYSCALL_DEFINE1(times, struct tms __user *, tbuf)
 #ifdef CONFIG_COMPAT
 static compat_clock_t clock_t_to_compat_clock_t(clock_t x)
 {
+	if (USER_HZ == COMPAT_USER_HZ)
+		return x;
+
 	return compat_jiffies_to_clock_t(clock_t_to_jiffies(x));
 }
 
-- 
2.53.0



