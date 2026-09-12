Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BE63B3BF5;
	Sat, 12 Sep 2026 08:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201381; cv=none; b=HdhB2ADKH11m3T+Bxvh3mPpOohqc310XceKTwBRFq+DtQQRM6RRuQ/edZIuyZ+JSYlhduKZOCaXBQbGRFzu4tYOmhdl5mWuW1QX4qQvXSzmm25FkaGyCf+1KUhOYy2YRW6VOcoNYH9aO7Ht425sAP2qLO7zKmmQB5AvfDiM10qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201381; c=relaxed/simple;
	bh=9VpMh3j6ITSsuwugYZU0DCjaudaI8e+tEFPUSxiqyCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DwDUGG0xg2l8IVebnuhoKhRkMQosbQ3SjNnzhxBHj/UxkAhHX1okd6Sbf8BxKvVN7Qdolb/3wdwpPSYRf2lRG6nBiDnqotgSYCKglI7djea30fIoIHW2Bsd3JrP/fwBmqcJ9eDcGdqdm85DiGpvtPo9hRlTjO7DQTn65CTDFFKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AuQqWent; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AuQqWent"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC511F000FF;
	Sat, 12 Sep 2026 08:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201373;
	bh=lGbHGitFJaCNVvbGGeC0ON0u9ko/jsjHyH9t9tbIeig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AuQqWentb7Vlj2jbikk5sHKrZsXejjv0mEkzMMKvnEWlSmnWpUBMlav4Q8BOcyAFl
	 e/NiucRehsNH6qIjfXZCilsvibYJwbbYHjkTTF21lUPgQEVK9LJBikFyhQY+VqhMmF
	 CBedgSNRM62yNGGt0XWcE2GN3uVG3l5P/ea/mGUQ=
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
Subject: [PATCH 7.2 0983/1815] powerpc/xive: add error return value to xive_smp_probe()
Date: Sat, 12 Sep 2026 08:45:33 +0200
Message-ID: <20260912065712.069443719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index efb0f5effcc69..4e3e3358993c0 100644
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
@@ -153,7 +153,7 @@ static inline bool xive_enabled(void) { return false; }
 
 static inline bool xive_spapr_init(void) { return false; }
 static inline bool xive_native_init(void) { return false; }
-static inline void xive_smp_probe(void) { }
+static inline int xive_smp_probe(void) { return -EINVAL; }
 static inline int  xive_smp_prepare_cpu(unsigned int cpu) { return -EINVAL; }
 static inline void xive_smp_setup_cpu(void) { }
 static inline void xive_smp_disable_cpu(void) { }
diff --git a/arch/powerpc/sysdev/xive/common.c b/arch/powerpc/sysdev/xive/common.c
index 86c78af1f68ea..9f80c16be23ff 100644
--- a/arch/powerpc/sysdev/xive/common.c
+++ b/arch/powerpc/sysdev/xive/common.c
@@ -1265,7 +1265,7 @@ noinstr static void xive_cleanup_cpu_ipi(unsigned int cpu, struct xive_cpu *xc)
 	xive_ops->put_ipi(cpu, xc);
 }
 
-void __init xive_smp_probe(void)
+int __init xive_smp_probe(void)
 {
 	smp_ops->cause_ipi = xive_cause_ipi;
 
@@ -1274,6 +1274,8 @@ void __init xive_smp_probe(void)
 
 	/* Allocate and setup IPI for the boot CPU */
 	xive_setup_cpu_ipi(smp_processor_id());
+
+	return 0;
 }
 
 #endif /* CONFIG_SMP */
-- 
2.53.0



