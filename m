Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6902215853A;
	Wed, 20 Nov 2024 12:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107537; cv=none; b=bvBmguT+XbRMgAVjz07QCxtn+50XJx8EmGYvmkjFO+JzXQMmNELFqfATJvmcM0jrqbdrOJPgEW/hLNCpLyzlQ7w83+PyFIxvZDqKB0f4H+F0sVc+o6kEzPzzmzgo5lwf6xeq7ap44wKNAZFkesQUrU7oCEhjGEKGdAfiljlcnvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107537; c=relaxed/simple;
	bh=zkdN+ocJiN49mDq5b1STFR0WAX4/F0ssPwD3ZBlhR/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e60a24H82mfWDw+kFqWjyg8LpySbdwfp9zqClprAClkQKIscoLVkExM+5CENGv66t2cBreRY4dfoSspVTknuAHFuGhleO8Ro16Q3DvAev0k47rcLS63n1AjchImHBHq4uLi/AQ5CDf+ofAETddezXjeCshvU87pjHORwevyR+Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpQqBDuY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpQqBDuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DD1C4CECD;
	Wed, 20 Nov 2024 12:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107536;
	bh=zkdN+ocJiN49mDq5b1STFR0WAX4/F0ssPwD3ZBlhR/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UpQqBDuYfJE8hio0HiGiXawdAQbT1Raxu6EUF2hCx8zg2b3Jbb5LCfwDbSgZ5vBlS
	 wwmtLLTbfFChN/xHpGcUiQ5huAyY8S35TTs2Nl0PGh7RU1qu8Xsa2LarTdeGmXo52C
	 S/s5wErClkkTAj8g+2RX6PHgXKSM0HYp/4Iru9WQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.11 070/107] LoongArch: Fix early_numa_add_cpu() usage for FDT systems
Date: Wed, 20 Nov 2024 13:56:45 +0100
Message-ID: <20241120125631.260409786@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 30cec747d6bf2c3e915c075d76d9712e54cde0a6 upstream.

early_numa_add_cpu() applies on physical CPU id rather than logical CPU
id, so use cpuid instead of cpu.

Cc: stable@vger.kernel.org
Fixes: 3de9c42d02a79a5 ("LoongArch: Add all CPUs enabled by fdt to NUMA node 0")
Reported-by: Bibo Mao <maobibo@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/smp.c
+++ b/arch/loongarch/kernel/smp.c
@@ -296,7 +296,7 @@ static void __init fdt_smp_setup(void)
 		__cpu_number_map[cpuid] = cpu;
 		__cpu_logical_map[cpu] = cpuid;
 
-		early_numa_add_cpu(cpu, 0);
+		early_numa_add_cpu(cpuid, 0);
 		set_cpuid_to_node(cpuid, 0);
 	}
 


