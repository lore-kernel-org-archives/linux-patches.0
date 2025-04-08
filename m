Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E84E42698A0;
	Tue,  8 Apr 2025 10:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109835; cv=none; b=H5WeojWY/gXFEnrsYBpROTgu1vg8yoEsgA8eNW2cDvqlaJHRnLMvL3JXSKGfvFfyH4Fu/YYpr4DZfr3CvCktSckGWmF/AmS4K/Co/1RF0JpMAWyXKgwg7TCltu2qVz20EBIWQv8TgkCp0VTql/ZMoDpibbRAIXGxnkzulP1LCqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109835; c=relaxed/simple;
	bh=ucU16qtlImsc3qRSgC3Q/5SEQmL5oprVmGuDae8M3nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQ7lKNQe+GcaddSPVgVomo2j4iW5NrcGk653YVt7S9SlQUHIEUxJvuIEHr7FfA2tH1+2l+WStvVOnEnkFuyEXz3pJprBsMZ9ujRLHUKAHduNosqj/62JZBqPaovI2K5Nef6iDQMtVA007Ninare2k+wtb7yoOINEr4fsWDE2zNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVv/QJlt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVv/QJlt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70333C4CEEA;
	Tue,  8 Apr 2025 10:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109834;
	bh=ucU16qtlImsc3qRSgC3Q/5SEQmL5oprVmGuDae8M3nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FVv/QJlt+NaswMp/xstPL0Kyo9eea3mBTb1w7LY9yX2On6S8z3VY+81PNsGKaejhe
	 Q9d3CT6LAtDAtV/Zrj/pYVuAUHofO5V/NXPXfkYJ1P6s6g7PJXLW7QuPQzHDiW6NS9
	 CgPKOmTHnJH71YbtW9rYxRyikEygz80P5UkQvwXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 043/227] x86/irq: Define trace events conditionally
Date: Tue,  8 Apr 2025 12:47:01 +0200
Message-ID: <20250408104821.695786883@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ce904c89c6c70..3e01b80864031 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -22,8 +22,10 @@
 #include <asm/desc.h>
 #include <asm/traps.h>
 
+#if defined(CONFIG_X86_LOCAL_APIC) || defined(CONFIG_X86_THERMAL_VECTOR)
 #define CREATE_TRACE_POINTS
 #include <asm/trace/irq_vectors.h>
+#endif
 
 DEFINE_PER_CPU_SHARED_ALIGNED(irq_cpustat_t, irq_stat);
 EXPORT_PER_CPU_SYMBOL(irq_stat);
-- 
2.39.5



