Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A831D25A2B7;
	Tue, 25 Mar 2025 12:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905615; cv=none; b=Emz1OukAyJprvXnWw6inevyUXjbkOE7ZVLZ/BZAgnYgN+8GZ5R3T3bZZyJsX/6vOGTnE/qZKm5eGXPTP2R3GhC7r/BfBgyO8O8dwS3Xf9jqZv7GODj1NS9JK25KG+N2RBusW5o5Dd/BuR6wkl4xlJPEcmbiPx9Esa8pHdUL6scw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905615; c=relaxed/simple;
	bh=2dHeBR38d2qUhafVcLfAiprXlU62wgcpTUdViy8tFlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HYyYqOEOcdH3hoerGdaCmtjW3IQe680nqjwHGHL3En2md3GILIzCfpIYKkwG1CRBOyOCDVhCBBMdTGyDHlgG9Nq3CZtN0ZLRvhg3XFEyKcILV98HTYw2VVbD8tLgf7CUTeLuEpJicpL8Fvu8UDHOB7qKIwxhIjadC6QnnW4Dh1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hWdQhgP0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hWdQhgP0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F366EC4CEE4;
	Tue, 25 Mar 2025 12:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905614;
	bh=2dHeBR38d2qUhafVcLfAiprXlU62wgcpTUdViy8tFlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hWdQhgP0GhDH/eA4OVjpRQWbTLtyKJVKXn0DFqFkmZkyJM7fGVNKIV1CpXzEBA4mc
	 mGANyUft/x4mrIRM8CFZW659jZh9e/i2eAeYALrFpYANwGlxWehzh7U4KSazQnsrDU
	 XRyPBHBSDywYMC2TZFuzERtgnU3WCfC2t37ZGiHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/198] x86/irq: Define trace events conditionally
Date: Tue, 25 Mar 2025 08:20:30 -0400
Message-ID: <20250325122158.428839561@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 766ffe3ba3137..439fdb3f5fdf1 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -23,8 +23,10 @@
 #include <asm/traps.h>
 #include <asm/thermal.h>
 
+#if defined(CONFIG_X86_LOCAL_APIC) || defined(CONFIG_X86_THERMAL_VECTOR)
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
+#endif
 
 DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
-- 
2.39.5



