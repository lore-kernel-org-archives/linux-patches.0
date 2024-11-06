Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E503E1E22EF;
	Wed,  6 Nov 2024 12:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896875; cv=none; b=Du8IABN+XaRqqCtYnLafpDPAb0UGP8fPeFkoQ6PxBEc5O4jUwo3/z0scmf4sTpQSzkBCcoNQiVPaHVrLLMrEbfNP/XG2G8N4eguyiFTDXpy3678fDdI+6P99OQDHPmqqSpfgBpx2/QkuU+vGCHsFROBCOFfdMc++JzvAxka+ksE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896875; c=relaxed/simple;
	bh=wNH35qae8wN9xnrj+GBg3mEoPs1VM/YBInMUnV/ZRa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSgSKnMD7e9K2dHGaAMcAUtsGKZRcP9ERRY1rJIQ8GN0fUDFObr6TaniKFjI7F+BsLVX5X+EM1dMy7f3r4rMfbUX7tL2tusWfNgN9tOsuwgnuWtTcfheAl+5jmJMMPBSKbfNji3t8d5dW8jLb9A+s15YFUTauJ4aXLzwKrNz1KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=irXIAXOH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="irXIAXOH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241B6C4CECD;
	Wed,  6 Nov 2024 12:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896874;
	bh=wNH35qae8wN9xnrj+GBg3mEoPs1VM/YBInMUnV/ZRa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=irXIAXOHjuTrQJ5xJi073ajqJygBvUicFfrns09V7Df/V/T+28EwXHFJkF+fRDBJs
	 w4C6OFOU98zPwpF6i0hjH19uyMtst4PhM70Eijn0AS6//c/1y+hKk+BRkrGm9DWrJc
	 ETMwhnAELE5ctzvT4T9z6f4OBWkh+89G3NatnYMs=
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
Subject: [PATCH 5.10 100/110] riscv: Use %u to format the output of cpu
Date: Wed,  6 Nov 2024 13:05:06 +0100
Message-ID: <20241106120305.938698143@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index df84e0c13db18..0e948e87bd813 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -69,7 +69,7 @@ void __cpu_die(unsigned int cpu)
 	if (cpu_ops[cpu]->cpu_is_stopped)
 		ret = cpu_ops[cpu]->cpu_is_stopped(cpu);
 	if (ret)
-		pr_warn("CPU%d may not have stopped: %d\n", cpu, ret);
+		pr_warn("CPU%u may not have stopped: %d\n", cpu, ret);
 }
 
 /*
-- 
2.43.0



