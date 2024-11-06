Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564461DFE3B;
	Wed,  6 Nov 2024 12:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897153; cv=none; b=aP3oc/C8OuMarFqTLO+xhRLX+RM3FA9hZEIMmOFujWffI7Phlz3RDWjIjp8OLXF3bsy5XXSqMhBndEyEqAfu6DynsEaMpG81AfdWYBSjk8F20kr/l5gK+tPfO3GGb/jYit4v5HeMYufe+PUTdffRwcJOiTcREu5MNrHkSKzJ4qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897153; c=relaxed/simple;
	bh=+pdeKJdhpjJeDNLzzOj2exJrMBoUDTsiiH45BSuKOdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxYrvjr2nokeuAoN7Nih197e2aw1hjKDqo3hbLm9+3hRLIAzY6wZMMaHQwmZdpAW5M0dsMbqdgbH2e1zpOKXLEI++Op7cguR82LrLypgS6AUX4l5bmBVtD1zkHFkQw1Xk+2yvEf+HGkFuwHurFEgpn6JKU2c4aOlW4VBKQaKXOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=coO7Izbx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="coO7Izbx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C83FCC4CECD;
	Wed,  6 Nov 2024 12:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897153;
	bh=+pdeKJdhpjJeDNLzzOj2exJrMBoUDTsiiH45BSuKOdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coO7IzbxQNh1iLp2vv9ghOn2lkVquCPUQaxpEmuS+0qCz6nEjVkEiJikKctq7epiM
	 OPBdDb5SEOZzW3a/KuGIwWxG5Fyzsn88ia8Dyp1ariDkNqhtkiE3cVmyfENlEeOURN
	 ZwpVJlaz/C6gr6FwcLwsZ+q5BmJiy9DrSXYKqNEs=
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
Subject: [PATCH 6.1 085/126] riscv: Use %u to format the output of cpu
Date: Wed,  6 Nov 2024 13:04:46 +0100
Message-ID: <20241106120308.372175406@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f7a832e3a1d1d..462b3631663f9 100644
--- a/arch/riscv/kernel/cpu-hotplug.c
+++ b/arch/riscv/kernel/cpu-hotplug.c
@@ -65,7 +65,7 @@ void __cpu_die(unsigned int cpu)
 	if (cpu_ops[cpu]->cpu_is_stopped)
 		ret = cpu_ops[cpu]->cpu_is_stopped(cpu);
 	if (ret)
-		pr_warn("CPU%d may not have stopped: %d\n", cpu, ret);
+		pr_warn("CPU%u may not have stopped: %d\n", cpu, ret);
 }
 
 /*
-- 
2.43.0



