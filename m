Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B44392C3D;
	Sat, 17 Oct 2026 18:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260337; cv=none; b=ZTH4mpy0iPPY4P4Ak1YKI8YhPRSbL0a2XWl9Fr+A0+gpfDEpES6FRbFoFW94o3zfV8I2hPmu3men3mM3KjmmEx84DPfsa629sAyn7fTCCg4kVPO3zLCNXXF4M1vbIxI77Q67raqFwpOC7V7yWWG3eqUaH1dfI0fI4K3U3+ke2eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260337; c=relaxed/simple;
	bh=3Dyoi8EW7HxITAGMwU68o8efJs1Z/lLq5qLiokfbQbM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s48n3KsmVOmiL5Aww+Q0YnvGOx0KNm9nlBXl/0V4otoTcRUNjhHphC8AXteM/4iHYLTnTaS/yfadu5enGnkK0DjOcZWtiO8cBQJqvwfq3ny7ODQghW+Cr+LJEcJEa5y0TNrzDY3tl8JWtW1NNwkIKbFFq14a0SRo4BiJluZdC3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rvVH1Weg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rvVH1Weg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3071F000C4;
	Sat, 17 Oct 2026 18:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260335;
	bh=roUirZpXmLO7Qn/IkuZbY/hP2CkU36WlFlHF+kX+iBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rvVH1Weg1q58XNL1NBPnPsSrfuEFVcGsoS9CKt6fxq/0B/xEsMHQ8SqdrFkLKFd1z
	 M2xdbuekPZ1iS8TIGS4/jNo+6f8+AKDsv2i6F+/+DVMi4P4ZNm+p0lskP9kcfqHEQk
	 iYDOyGlnXuen5KPHEmlJovO7fPOwmqIyjtcxJD0c=
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
Subject: [PATCH 6.6 1512/1674] powerpc/xive: add error return value to xive_smp_probe()
Date: Sat, 17 Oct 2026 18:03:04 +0200
Message-ID: <20261017160509.935037831@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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



