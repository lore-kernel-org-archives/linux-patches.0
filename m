Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052833;
	b=uFawg8jmxqzqSsPbbCN5KJXYulDT3xVPDZcWZrL/vE1SLQvMRiutKB4+SpF9TPuEv5pJ
	 5Bs04GMQTE6x1hCKRQ53MlLqQE/73NbSC7FYhl4YCorLzh7BVIKIWNClUnXQTNzj9e7xf
	 o9+Gea3ZxA9Ufj244YZjM/kdxiO0riK8maB2ZRDYEdhBJ01h4Puws5eS5Cp7ousBaFzcH
	 zDJEdVTjLqr2VB0HxnYalMbIG2ZPfzLRbkEM+rhocpaqHv11Lsa4GKEwoJE39qfBNXdaO
	 JlDUj4Yh9bO7/zBl3iWhbY7bGkR2qzyEeK/XiY6QIs9Rgr82+PHxlvD+6BioDrfBWbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052833;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WYW+JIZeo/Tje7OG9layEZBe3EDM4D6dvpDEmT2UaUM=;
	b=MHC5hq3Ycamrlej2ohJo/mOvCmNtGhw0O2hxnDie2P6UmKZUISL7BjmQKWFfO6/WCzk7
	 tHS1sn7ZOGRgP517atjCA9uLF1D977bRwvcmEgGeGDJD1BrLLq0Y4JgiWNx32IWWKglG3
	 wD0msQXIyXzmSTi1UEGcNF+DTA48S1ezhkluSEWxa3cUZKBT1IV3pwxP9I99yLsrgk6n9
	 aQMtTI/zkP4LxOq5jxXkqkebFyz1JxH4UVVWi00j0VQGxP8SvgE2pI4h6C9IfC9B03R5f
	 e6Yos5Kdo5JHfzcAFT5sbim/3OYsmcEBVFAaHDTFxhw+CIidsodoXX23HklXZVFnqJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TU95x5UH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC13606A31C;
	Thu, 19 Nov 2026 01:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TU95x5UH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E841F000C4;
	Thu, 19 Nov 2026 01:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052833;
	bh=WYW+JIZeo/Tje7OG9layEZBe3EDM4D6dvpDEmT2UaUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TU95x5UHuxP1pHNAvoBxEVLgRwveHg33ibgw6YN1sPsPW55RFLxKecW6EgKRMu61m
	 fV+NuXbyksXAyuP3ZEVZCaQ8oX2VqRYRTL44UZk6qJk7cgZy2Vr13B/H4RuXjO5zws
	 dyMZSdfNTgatIemVSj7pMSwTxyhaSGuarJbdw+A8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hungyu Lin <dennylin0707@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0704/2214] compat: avoid double rounding in times()
Date: Wed, 18 Nov 2026 15:39:40 +0100
Message-ID: <20261118150039.969561282@linuxfoundation.org>
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
index 0c28a8eff0e35..3aa55bdcb7e41 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1021,6 +1021,9 @@ SYSCALL_DEFINE1(times, struct tms __user *, tbuf)
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



