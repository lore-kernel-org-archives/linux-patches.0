Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063407;
	b=NAsEhy+bCaEGsRPQjNgLFeKQcSlkL/+dLgEQQNDWT2ebnjHUEQgqJTzmRfe901K2ybsY
	 TiVTnLrSPRSYWVIZS+1Flvn/17lvIb756RjQDxGzFAS3s5+RGibHqLGQQyFLLHOHel6Ag
	 rB4bMSd4DGfTfmTS58mcpJF0ZYiLSCxoiM5yrwophWdnf+FzlyINt2PTC765naQZdrrcZ
	 ISOnaNx43zsorppAhNqmqqidfrJQFDWol1D0Wj6r75H8C2flthMyloUhDIM1hpGQgSPBe
	 jlGQcNwSmdKiC2ig+Uiu37ley9FJREDKv0sK6nVXKgATyTT2cUVi3lRZTi74bxTLUIA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063407;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UWy500LfoopEJ1nkA9zr6dTnZ+jJjF7FVqbcVur6CSQ=;
	b=mG0ku9VJodPQRlge6UhBwiA2kcP9i3kD9AzXX0NE0PksY2up4j9oTLC1EYP47wo1k7uH
	 9actw0xBugEqSiAPFWAJERWKKN0QfOQKA14257Tw68+MJKwtWdpI3cmPGuFRFKDlAXmSB
	 cAr7bsYlKc7Kj1OTDoQUIzWGqJUS5lHef929SWn11BgodkuNEfNQMYnYwlsVoOWun1UL/
	 GdGgKnhvpKNvrQcCt48PBh17+oIhIXtpn1335QIM/yTNh/KPc97PPy2K26kHkHC8wrxRB
	 pxANq+XdiAu+/bt7XCTn/f+hZ1omxbYLD78HiBAHWazAg17esx7WEEqCqEIAlkfT4hA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ai4jWFIW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05959606A326;
	Sat,  7 Nov 2026 14:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ai4jWFIW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72D31F008A1;
	Sat,  7 Nov 2026 14:56:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063406;
	bh=UWy500LfoopEJ1nkA9zr6dTnZ+jJjF7FVqbcVur6CSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ai4jWFIWECeHTA/Yx7o8HgajqrhJHgfUrDZtgy9Z3ah+D3qN0NjaNGjVnOx48LZDS
	 Gbs0LifoE5azH+1frQkcf/pERRbAvsK1UNIoIxDWBRNz8I3wAuOnwZJBPD3F61zFxQ
	 1RXH+L7c2UnIuPgZB1rSU+Hv2yvw2KdiAxwTYjxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Russell King <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 559/869] ARM: 9521/1: cacheinfo: count external caches in early_cache_level()
Date: Sat,  7 Nov 2026 08:54:01 -0500
Message-ID: <20261107134912.270897376@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 4fd69e8a9ebc42e292637ec2ebfb6bcf2d2f6c0e ]

early_cache_level() counts only caches described by CLIDR. An external
PL310 is absent from CLIDR, and its arm,pl310-cache compatible is not
accepted by init_of_cache_level(), so early allocation falls back to
an incomplete count. init_cache_level() later adds the DT-described
L2, forcing reallocation on the secondary CPU with interrupts disabled.
This defeats early allocation on PREEMPT_RT.

Use init_cache_level() for early sizing too, so the initial allocation
includes external caches described by the device tree.

Assisted-by: LLM

Cc: stable@vger.kernel.org
Tested-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Link: https://lore.kernel.org/r/20260912195552.76673-3-kmehltretter@gmail.com/
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/cacheinfo.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/arch/arm/kernel/cacheinfo.c b/arch/arm/kernel/cacheinfo.c
index 860eeb03cfe5d..31591c9472548 100644
--- a/arch/arm/kernel/cacheinfo.c
+++ b/arch/arm/kernel/cacheinfo.c
@@ -111,13 +111,6 @@ static int detect_cache_level(unsigned int *level_p, unsigned int *leaves_p)
 	return 0;
 }
 
-int early_cache_level(unsigned int cpu)
-{
-	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
-
-	return detect_cache_level(&this_cpu_ci->num_levels, &this_cpu_ci->num_leaves);
-}
-
 int init_cache_level(unsigned int cpu)
 {
 	unsigned int level, leaves;
@@ -146,6 +139,11 @@ int init_cache_level(unsigned int cpu)
 	return 0;
 }
 
+int early_cache_level(unsigned int cpu)
+{
+	return init_cache_level(cpu);
+}
+
 int populate_cache_leaves(unsigned int cpu)
 {
 	unsigned int level, idx;
-- 
2.53.0



