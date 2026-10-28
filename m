Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216831;
	b=LF+BErOic7YQ4liSf5Xu6Zgnt0TE6twyJlzMFyHMZ6OfFVR8PuzUcTydB2NC/QwUxA1t
	 Jk2eEJtdryTIq/i/25puNhw3hJ+ZZWsJtMa9cFVDV8s0q2FklBfE2q1a3SSKJ/NxJxkgZ
	 0RpRGTkboLsdoz+r8ENQ2xDKcdynIb63cK0CD7L+8JczL4cQ3fux2y/y17giHY5XqDlwG
	 51TX7+L3fNTQqsZLhKJHr8cG5LEzUWcEBCr0Ntev9K7TUfCvOiBgnAiVZOVS1GESxudj3
	 eljV+dvjnuxhA3t9iK86BIpGOWPc/+kq5bABw1+hmIZoh8JR0Eo6tSJD0F2I3hDBTig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=V5jG1yGnZu28Sd7ZaMY7BISs0eNz9x2sDsD7T6ejSgs=;
	b=l2CZynzxMLBexVIhKFN1R3i5Rt1H/bkHZbaaPch+17wJ4aHNYV0r+vxfdsioWmIK9ZE2
	 aVPSjF663RguU5wFiYfvtQF6itMRHSWGjY6yf4e6CoMD6SMy4fRjSadC9ayuBJT8h+uuC
	 u/61BGGDFF+03NM33nsBizgzkFBgP1QENDGTJLxgP21Tmv2/LKy1rWXb5pyizPTxEch2+
	 yQhISwRj5I8B7VYyGh8phq62YPffUpXzmtER9HrnlMCUX3WxDbRj2pUEexZZa91Exsqkb
	 raoDUX6ewnS9OtzfjRty8qaIT4F2/qUTZpwS07njwkMxt8LzKhVdom9fuYowjr/ZBkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbBerjoX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E68606A31A;
	Wed, 28 Oct 2026 19:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SbBerjoX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D9A1F01828;
	Wed, 28 Oct 2026 19:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216831;
	bh=V5jG1yGnZu28Sd7ZaMY7BISs0eNz9x2sDsD7T6ejSgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SbBerjoXoTLKf9in46sCQKZ3qe0RKslq7m1BkPZJwAs2LzGbG/B6AUOHqNuMbQN9W
	 cXMwjiCoQjVarS34W6AvtVWKvLAiOZlfbO08lIkQKDu9JSn/VbMDmQcKMI87yclH6m
	 V/HsvHauKmVVtYycM8V0x6aucuJICgRAD4/WYf6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gou Hao <gouhao@uniontech.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	jiazhenyuan <jiazhenyuan@uniontech.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1650/1887] powerpc/xive: add error return value to xive_smp_probe()
Date: Wed, 28 Oct 2026 18:02:26 +0100
Message-ID: <20261028170537.011333112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gou Hao <gouhao@uniontech.com>

[ Upstream commit ab5ae5dceb86614f6c9e7488f91b652000edfdc5 ]

xive_smp_probe() calls xive_init_ipis() which can fail, but its
return value is currently ignored.  Change xive_smp_probe() to
return int so that errors can be propagated to callers.

This is a preparatory patch for the next one.

No functional change yet; the return value is always 0 at this point.

Signed-off-by: Gou Hao <gouhao@uniontech.com>
Reviewed-by: Wentao Guan <guanwentao@uniontech.com>
Reviewed-by: jiazhenyuan <jiazhenyuan@uniontech.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260727104215.184786-3-gouhao@uniontech.com
Stable-dep-of: 411a3c016e7a ("powerpc/xive: propagate IPI init errors to prevent use-after-free")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/xive.h   | 4 ++--
 arch/powerpc/sysdev/xive/common.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/include/asm/xive.h b/arch/powerpc/include/asm/xive.h
index 92930b0b5d0e1..8ac7c1d3564fc 100644
--- a/arch/powerpc/include/asm/xive.h
+++ b/arch/powerpc/include/asm/xive.h
@@ -91,7 +91,7 @@ static inline bool xive_enabled(void) { return __xive_enabled; }
 
 bool xive_spapr_init(void);
 bool xive_native_init(void);
-void xive_smp_probe(void);
+int xive_smp_probe(void);
 int  xive_smp_prepare_cpu(unsigned int cpu);
 void xive_smp_setup_cpu(void);
 void xive_smp_disable_cpu(void);
@@ -154,7 +154,7 @@ static inline bool xive_enabled(void) { return false; }
 
 static inline bool xive_spapr_init(void) { return false; }
 static inline bool xive_native_init(void) { return false; }
-static inline void xive_smp_probe(void) { }
+static inline int xive_smp_probe(void) { return -EINVAL; }
 static inline int  xive_smp_prepare_cpu(unsigned int cpu) { return -EINVAL; }
 static inline void xive_smp_setup_cpu(void) { }
 static inline void xive_smp_disable_cpu(void) { }
diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index a289cb97c1d7b..5f6a05380e955 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1270,7 +1270,7 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
 	xive_ops->put_ipi(cpu, xc);
 }
 
-void __init xive_smp_probe(void)
+int __init xive_smp_probe(void)
 {
 	smp_ops->cause_ipi = xive_cause_ipi;
 
@@ -1279,6 +1279,8 @@ void __init xive_smp_probe(void)
 
 	/* Allocate and setup IPI for the boot CPU */
 	xive_setup_cpu_ipi(smp_processor_id());
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
-- 
2.53.0



