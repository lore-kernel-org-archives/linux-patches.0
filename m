Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3211DA11B;
	Wed, 19 Mar 2025 14:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395090; cv=none; b=PqatQtMb5N7VhH1Rvmr9XZWjTTECa1ydwLHM8wjoHizm49iCy0tVTNFefxI3zNvsulzir5/F+441vPu+DcZcfpNYFtfk36aAHdOhkE9ylEUdnorZN6WYiZ6DHH1OL7lavs898oLeCjmvq0KnT1TZ+83wR4ozd9mNacnuZcSL/iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395090; c=relaxed/simple;
	bh=MfixoiuiFVGGiOaFL/HLFvuVBadmhqe9+cKMqDVGEI4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9sNKlasqnB0y1Gtd5dZr25/B1hWXt9cgOr5X+3SLLimAdFxJejEi8E5Km6w5pXWm7ysbGIGcMXOQWpXfISmsQEEkLJeQOI5Yt3EIBMGfD8hzbvFs8MihrSE+mmyF6rinb3HJNg+9pdl0kcnlumnYHl5qWAJqC5z/PPRLNxGheU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymOVMAzM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymOVMAzM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D71C4CEE4;
	Wed, 19 Mar 2025 14:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395090;
	bh=MfixoiuiFVGGiOaFL/HLFvuVBadmhqe9+cKMqDVGEI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymOVMAzMdf1kT1be6T0qQ1kcVqVPWQWrnLdA4K9bY3+Uke98G/mUthNARdN48IWrv
	 WGfEkpeOwb3sYbrG2dM1j4Px8kbp8ksToPWkTab+SCWORi7FcipDkFUmKYsJV+bYg0
	 w2STD8Eyfl2UzETTQM2cMMYXMKa2Ag3uCOM6TTBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/231] x86/irq: Define trace events conditionally
Date: Wed, 19 Mar 2025 07:30:30 -0700
Message-ID: <20250319143030.222010670@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 9de7695925d5d2d2085681ba935857246eb2817d ]

When both of X86_LOCAL_APIC and X86_THERMAL_VECTOR are disabled,
the irq tracing produces a W=1 build warning for the tracing
definitions:

  In file included from include/trace/trace_events.h:27,
                 from include/trace/define_trace.h:113,
                 from arch/x86/include/asm/trace/irq_vectors.h:383,
                 from arch/x86/kernel/irq.c:29:
  include/trace/stages/init.h:2:23: error: 'str__irq_vectors__trace_system_name' defined but not used [-Werror=unused-const-variable=]

Make the tracepoints conditional on the same symbosl that guard
their usage.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/20250225213236.3141752-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/irq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index 385e3a5fc3045..feca4f20b06aa 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -25,8 +25,10 @@
 #include <asm/posted_intr.h>
 #include <asm/irq_remapping.h>
 
+#if defined(CONFIG_X86_LOCAL_APIC) || defined(CONFIG_X86_THERMAL_VECTOR)
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
+#endif
 
 DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
-- 
2.39.5



