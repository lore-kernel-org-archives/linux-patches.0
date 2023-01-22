Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEC22590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:22:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 128B6C433D2;
	Sun, 22 Jan 2023 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400920;
	bh=XeeT7DKUxI/5tvd117BzTyiPFaMY0St/VNU0XigYg4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SV4xwHbxXfxv4ABLNTiBIwneYTWqDIFVeC/HA1oze0+hmpCj0JqBbrspWu3UFMDCz
	 0FoFT85cI9YpzuXOlBiQcLP1pUVH6JKEDh9Ge770ipKfL8Fa0Qp5tIIqlpQXE6yCpE
	 hUx5np43Pv6GhqDiJi0F3TTk/WVvE1exJdhV3M1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yinyu Cai <caiyinyu@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 042/193] LoongArch: Add HWCAP_LOONGARCH_CPUCFG to elf_hwcap
Date: Sun, 22 Jan 2023 16:02:51 +0100
Message-Id: <20230122150248.317978996@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Huacai Chen <chenhuacai@loongson.cn>

commit d52fec86a465355b379e839fa372ead0334d62e6 upstream.

HWCAP_LOONGARCH_CPUCFG is missing in elf_hwcap, so add it for glibc's
later use.

Cc: stable@vger.kernel.org
Reported-by: Yinyu Cai <caiyinyu@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/kernel/cpu-probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/loongarch/kernel/cpu-probe.c
+++ b/arch/loongarch/kernel/cpu-probe.c
@@ -94,7 +94,7 @@ static void cpu_probe_common(struct cpui
 	c->options = LOONGARCH_CPU_CPUCFG | LOONGARCH_CPU_CSR |
 		     LOONGARCH_CPU_TLB | LOONGARCH_CPU_VINT | LOONGARCH_CPU_WATCH;
 
-	elf_hwcap |= HWCAP_LOONGARCH_CRC32;
+	elf_hwcap = HWCAP_LOONGARCH_CPUCFG | HWCAP_LOONGARCH_CRC32;
 
 	config = read_cpucfg(LOONGARCH_CPUCFG1);
 	if (config & CPUCFG1_UAL) {


