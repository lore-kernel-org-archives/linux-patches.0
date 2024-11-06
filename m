Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C702B1FC7DE;
	Wed,  6 Nov 2024 12:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897738; cv=none; b=TDcMNBEUDVjkiDPQBmkOa5icBDYeYVBXbtbS4sMxzubj1xjQxHUBTk+vtbliUM4o7YIcGogTIOzYE2GlbAo/vAM0HSkv8bAaN3S1cHKG/JNqR8QsaRXvDLxBpYVE0WXS3hIOwkNAaWZZljhncRlpk1xJOCcMbZLeejc0L2gGSL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897738; c=relaxed/simple;
	bh=iFR+s+ptb+lniXqm+VMj4ifwHDHd9R409uhZfmyujvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tw2F9VQcJQAzwoWrnnPlcCAEmmhudIfpfX80C7oSiNknXf3XPiIRnPAuBi/So/qyo4O5Eo6pEIkUM+gy3V8z3GFxuWynjDh+mPgvE6uqw52uEAE6jA6NtRaWqvqiIaLxPKOuVSWFeT5EQVTKkeGlKja4g+dIH1VYW3XTWMqtAXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUCnK481; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUCnK481"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03121C4CECD;
	Wed,  6 Nov 2024 12:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897738;
	bh=iFR+s+ptb+lniXqm+VMj4ifwHDHd9R409uhZfmyujvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUCnK481RAw2OSHOJsLaYuTcL5VcmH4uVWRVvGK7GMqaX6ai5gxLPfV549FaoMm2I
	 EKUfsSpObiBhLF5fg9CUGZTHXVkULKJotmIqLvBqmpxT+U2Maqoqx3go0H5Qjjjchi
	 IZ1Q4PhKm/Kvl4senoONZvQbOLTCTAnzZTpnyEU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	"Maciej W. Rozycki" <macro@orcam.me.uk>,
	WangYuli <wangyuli@uniontech.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/151] riscv: Use %u to format the output of cpu
Date: Wed,  6 Nov 2024 13:05:05 +0100
Message-ID: <20241106120312.084998915@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: WangYuli <wangyuli@uniontech.com>

[ Upstream commit e0872ab72630dada3ae055bfa410bf463ff1d1e0 ]

'cpu' is an unsigned integer, so its conversion specifier should
be %u, not %d.

Suggested-by: Wentao Guan <guanwentao@uniontech.com>
Suggested-by: Maciej W. Rozycki <macro@orcam.me.uk>
Link: https://lore.kernel.org/all/alpine.DEB.2.21.2409122309090.40372@angie.orcam.me.uk/
Signed-off-by: WangYuli <wangyuli@uniontech.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Fixes: f1e58583b9c7 ("RISC-V: Support cpu hotplug")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/4C127DEECDA287C8+20241017032010.96772-1-wangyuli@uniontech.com
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/cpu-hotplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/cpu-hotplug.c b/arch/riscv/kernel/cpu-hotplug.c
index 457a18efcb114..6b710ef9d9aef 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -65,7 +65,7 @@ void arch_cpuhp_cleanup_dead_cpu(unsigned int cpu)
 	if (cpu_ops[cpu]->cpu_is_stopped)
 		ret = cpu_ops[cpu]->cpu_is_stopped(cpu);
 	if (ret)
-		pr_warn("CPU%d may not have stopped: %d\n", cpu, ret);
+		pr_warn("CPU%u may not have stopped: %d\n", cpu, ret);
 }
 
 /*
-- 
2.43.0



