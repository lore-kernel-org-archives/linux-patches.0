Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29029188018;
	Tue, 30 Jul 2024 16:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358300; cv=none; b=fud9bhs0Dm3QYyihjSHT1KYcJYlXrlKPJxRor6djC1iTdyi6K0yqjBt6SZ7388/36qdQ+AcXb5adaWAF3FepBUXIl9OGh5A6FKHT7vdu/m5fnTeD9KyMcgTGHt2eTInJs2LUFP7e8HH2X0fK10NrIeEWRRZ/OBPAVrNGZOkVzu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358300; c=relaxed/simple;
	bh=+iJOcnB+Zofj1WXR1MNbMVwuCZBHLWnvl3Rg/JHRsro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LF4GZcoKNk0AcExxAmvwWpI93Otzzdn2mYbV4wCnQakgnXIgVC3DWK4w57YVWVCBMNEmcPvotlgkuTXvyrbfzW6DLQ0HUi6SZ/Uwf9kL5SnCpLm9XSA5dUK8xAIIOZUfPZT4UBRaxOvAksYCFmxpDGSx7IeJK0kAKU+DrMZygAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=upDEO7sj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="upDEO7sj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B567C32782;
	Tue, 30 Jul 2024 16:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358300;
	bh=+iJOcnB+Zofj1WXR1MNbMVwuCZBHLWnvl3Rg/JHRsro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=upDEO7sjV4ntGpFrLZjT7iQC5cwZtf/RJnRPRwO4rvXTuUSGRKXexlB/REIcEePaq
	 jiaGVuWdgSLWDazKoBTt4QBZ8zdNnIvrs+t3BXIg2lXkVtwuo8yX7mrlqN2P5f6FIq
	 cdQ+YnACOKObuWOxrDpKuuSZn5yfY2uJvwxszpHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.1 375/440] MIPS: Loongson64: env: Hook up Loongsson-2K
Date: Tue, 30 Jul 2024 17:50:08 +0200
Message-ID: <20240730151630.459871732@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Jiaxun Yang <jiaxun.yang@flygoat.com>

commit 77543269ff23c75bebfb8e6e9a1177b350908ea7 upstream.

Somehow those enablement bits were left over when we were
adding initial Loongson-2K support.

Set up basic information and select proper builtin DTB for
Loongson-2K.

Cc: stable@vger.kernel.org
Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/mach-loongson64/boot_param.h |    2 ++
 arch/mips/loongson64/env.c                         |    8 ++++++++
 2 files changed, 10 insertions(+)

--- a/arch/mips/include/asm/mach-loongson64/boot_param.h
+++ b/arch/mips/include/asm/mach-loongson64/boot_param.h
@@ -42,12 +42,14 @@ enum loongson_cpu_type {
 	Legacy_1B = 0x5,
 	Legacy_2G = 0x6,
 	Legacy_2H = 0x7,
+	Legacy_2K = 0x8,
 	Loongson_1A = 0x100,
 	Loongson_1B = 0x101,
 	Loongson_2E = 0x200,
 	Loongson_2F = 0x201,
 	Loongson_2G = 0x202,
 	Loongson_2H = 0x203,
+	Loongson_2K = 0x204,
 	Loongson_3A = 0x300,
 	Loongson_3B = 0x301
 };
--- a/arch/mips/loongson64/env.c
+++ b/arch/mips/loongson64/env.c
@@ -88,6 +88,12 @@ void __init prom_lefi_init_env(void)
 	cpu_clock_freq = ecpu->cpu_clock_freq;
 	loongson_sysconf.cputype = ecpu->cputype;
 	switch (ecpu->cputype) {
+	case Legacy_2K:
+	case Loongson_2K:
+		smp_group[0] = 0x900000001fe11000;
+		loongson_sysconf.cores_per_node = 2;
+		loongson_sysconf.cores_per_package = 2;
+		break;
 	case Legacy_3A:
 	case Loongson_3A:
 		loongson_sysconf.cores_per_node = 4;
@@ -221,6 +227,8 @@ void __init prom_lefi_init_env(void)
 		default:
 			break;
 		}
+	} else if ((read_c0_prid() & PRID_IMP_MASK) == PRID_IMP_LOONGSON_64R) {
+		loongson_fdt_blob = __dtb_loongson64_2core_2k1000_begin;
 	} else if ((read_c0_prid() & PRID_IMP_MASK) == PRID_IMP_LOONGSON_64G) {
 		if (loongson_sysconf.bridgetype == LS7A)
 			loongson_fdt_blob = __dtb_loongson64g_4core_ls7a_begin;


