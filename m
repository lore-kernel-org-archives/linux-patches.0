Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2F051A0BD6;
	Wed, 20 Nov 2024 13:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107626; cv=none; b=S/eTEuMW/xV/PK48ZrAmWcJqDv7/htouwaYjr975yuOkw3VaQK+4JQJsOGY82vLTWLeAcHqOiNNJ7u3tiVHFGklp4lEeU/aTpe/htQ7EMEO7LHldJg6Z6IPT6RkcSZ7vOFXBeReagVQMPgT//wbob4hMHFo0G8qoDpLvZIwE5jw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107626; c=relaxed/simple;
	bh=rlZAMggTKzsSr453WyHbXg9e/k5Qo1qD2M4fVZQoI3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttQO/+QPomTd9D+kDHl+FNUKk10Ul8BMI5TWLhG+oiuJREopUbdcYsKndokTNhsrnVk4u0eYmJbfj5qNhvxfQSNdKcu6dIhEI75R055AvRbfK12/syg8RnhTTSY153Do9esFLIFK4Itb03N7hPqtgm5ujtY2xkU1xXjt+UZScms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uj7lpPg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uj7lpPg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916DDC4CED2;
	Wed, 20 Nov 2024 13:00:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107626;
	bh=rlZAMggTKzsSr453WyHbXg9e/k5Qo1qD2M4fVZQoI3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uj7lpPg3kmB0vkMTIVCelAi2rhF9sO2CbWvzWHiuMJoimGjX2HBrHZ5TPKEEnXkKi
	 Z3ncT6xQaKaDS8r2wHrkuF6grgSFUlqlo66V8iNJPV3y748Cf64104qOcvtixzl1KA
	 oduI3KoQkiWTzL7OGqf1QNdlGHSAgrJScIowrBwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bibo Mao <maobibo@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 45/82] LoongArch: Fix early_numa_add_cpu() usage for FDT systems
Date: Wed, 20 Nov 2024 13:56:55 +0100
Message-ID: <20241120125630.623939479@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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
@@ -272,7 +272,7 @@ static void __init fdt_smp_setup(void)
 		__cpu_number_map[cpuid] = cpu;
 		__cpu_logical_map[cpu] = cpuid;
 
-		early_numa_add_cpu(cpu, 0);
+		early_numa_add_cpu(cpuid, 0);
 		set_cpuid_to_node(cpuid, 0);
 	}
 


