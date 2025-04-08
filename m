Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461BC224AEB;
	Tue,  8 Apr 2025 11:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112383; cv=none; b=jaApVg9r/5l3gBjy/eFBPf5cWce4g8ocGs2MVa9ht0O+8W0rtYYVgu5ShrXm13akQsg0mEahSYYBfh3XeD4ZElY9GnUsGKxyKiVETmbrl0BtPA5PPgOYVA8yurT4wXN+dmTDUGQYylmm8cWxiEfh8NRMiU3Olwf7SnJas9Llqdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112383; c=relaxed/simple;
	bh=tisXp+DnFJ4+0eBiTRLzZW6o7/qUnrrr0KbC0jnzeh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fZRBa+gqJVI+XGIvJCM3ExNzzBhyx5yN/fvWsDDopHWPFm6EvI8KbO6AY4JWV2kn2KNWaZRNT4dTZz+1xv17kJA7GbZC23D50RO4aeg0tBWCNK/U6jSd0XdqAhCRjuW7Q3PS9pW2m215EeJsuMeYz8Ytjba8nLKR6dsrHXaLwxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBxFlUyz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBxFlUyz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2C1C4CEE5;
	Tue,  8 Apr 2025 11:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112383;
	bh=tisXp+DnFJ4+0eBiTRLzZW6o7/qUnrrr0KbC0jnzeh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBxFlUyzxK8YVvtzoPJkHgoTijXzMvkyiglQ+JCD4phoYG+/xgylrN0ZplxKuv5wj
	 X8sQz+0/eQ3PbPf6O48x/j0IjQjgOR4/hHhDMZfG3s/wMp2TLrmwpve2HzIsstHJqP
	 X2zg2Z8iCrq0sRpgbPUYtCNdgpQAk3tpKRBzul6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 049/279] x86/irq: Define trace events conditionally
Date: Tue,  8 Apr 2025 12:47:12 +0200
Message-ID: <20250408104827.694738177@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



