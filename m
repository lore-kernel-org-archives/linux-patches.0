Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8101DF986;
	Wed,  6 Nov 2024 12:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896388; cv=none; b=An1bV1SMHYpJ821beVPKSQv3w9ZxWkKyBI1L8qY5egGxdcp5jYfHCFILF7vfL4s3ZMjx+cZD8tCGHIeoBtIUValXQ8FtlgH7uzVUEESKu7sbPoOehKvI7xHhf+vzwdsdtiBI3SnEIZnE9YaNJpJS52WLE/cOewJltP3wR9WBlO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896388; c=relaxed/simple;
	bh=HRvfZsiyLt/YhGMsad1UV29z58AvLitfeqmwS2WrH84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZr2lsCvqOT8WrjkigHijlVXws/22XkYYZZSKNap/jI5jIu+FjgxbhoLl8A/mhuaeZ4dtaX8y20Y+iJYJxQA+W2em8H1gMMgzNCaDOO+Kc8Bnhmi4Jx7UpY2X0F3obe8ghX7Ebuf1n1gGx224oLQZlXYLRoqClK4fGa3b8PFvNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X52Ca8i0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X52Ca8i0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AF5C4CECD;
	Wed,  6 Nov 2024 12:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896387;
	bh=HRvfZsiyLt/YhGMsad1UV29z58AvLitfeqmwS2WrH84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X52Ca8i0+rLGWKBghwCwSZXnoJ8ZZqMU5pvFDibFyAZVgYi2ER/36pkyKZ7sYHxKp
	 NzbHTk4Agag06D30RUTvj6RE/36gb58XdnCdk1VTikKLnJ2obDcyg5vevZNreL+hIt
	 Sg2rdQwRJ4Vfdh/vWgubsfQMEsQIWp1uCvxXFBkc=
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
Subject: [PATCH 6.11 158/245] riscv: Use %u to format the output of cpu
Date: Wed,  6 Nov 2024 13:03:31 +0100
Message-ID: <20241106120323.123680283@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 28b58fc5ad199..a1e38ecfc8be2 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -58,7 +58,7 @@ void arch_cpuhp_cleanup_dead_cpu(unsigned int cpu)
 	if (cpu_ops->cpu_is_stopped)
 		ret = cpu_ops->cpu_is_stopped(cpu);
 	if (ret)
-		pr_warn("CPU%d may not have stopped: %d\n", cpu, ret);
+		pr_warn("CPU%u may not have stopped: %d\n", cpu, ret);
 }
 
 /*
-- 
2.43.0



