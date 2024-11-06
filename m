Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE10A646;
	Wed,  6 Nov 2024 13:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899265; cv=none; b=SY5Ib33ZqNy6cis7vsrjv4Gh5NUiPrO0ykgBzIGUiuTdBrz4XwvcvQ8kV/dzGfGHQHvrwmPRRgCnKz7iY3hk/8P1bQIHEX3L9+MxFa6d0hX+hJyNXcQMHNDXvd6lEUayMerPdKFtKZG5iN2/G1/cKigZ6QWBpomVM0vWBL2a0AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899265; c=relaxed/simple;
	bh=jIZ/s2glONX63Bcb718lxDKz9CBsgJ3aCctyk2lReKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hwu9P6NXXNb28bcuIl2ggLaZRj6LUCyQpOrH1IgGaI+ogbgLP0l5SFm/9w+SUSiH1hdB/z9gls2saW29gD7y7Kq0g7NudqQqRgmAJY5gzNG13PljtRl7NAcBbqTIZ89tvlSOkxnbawSOR5mLPyh84/pBcJJUZTyJw2fogv1TTHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6tHV61W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6tHV61W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AAEC4CECD;
	Wed,  6 Nov 2024 13:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899265;
	bh=jIZ/s2glONX63Bcb718lxDKz9CBsgJ3aCctyk2lReKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6tHV61WfHlWz3sCoe0KpOkec7zXkEPXhZdl65BTAR6Hsyfq8ZDggPMAOrgNtg8py
	 NLdcNX/oB174QZ9maxMJj11RWE0KvhUxNdiO5oE0PQ8gQkfV3amX5SPyx4RYj/USzB
	 6SIvdpJvSyopYfSVoLemUqnM5ytl19l7h/FXEV2Q=
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
Subject: [PATCH 5.15 53/73] riscv: Use %u to format the output of cpu
Date: Wed,  6 Nov 2024 13:05:57 +0100
Message-ID: <20241106120301.549270487@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 66ddfba1cfbef..28a3fa6e67d79 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -71,7 +71,7 @@ void __cpu_die(unsigned int cpu)
 	if (cpu_ops[cpu]->cpu_is_stopped)
 		ret = cpu_ops[cpu]->cpu_is_stopped(cpu);
 	if (ret)
-		pr_warn("CPU%d may not have stopped: %d\n", cpu, ret);
+		pr_warn("CPU%u may not have stopped: %d\n", cpu, ret);
 }
 
 /*
-- 
2.43.0



