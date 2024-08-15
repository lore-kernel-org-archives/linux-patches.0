Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994551A01CC;
	Thu, 15 Aug 2024 13:51:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729916; cv=none; b=emvIrY/WGaQIovefHwkPow7kP+Sqo3rC1HyhVl67mJy7mNcxj52yzm3CqtLZG+zkFAYCImb3T1C2NCzvSF7smdhvRVjHgQbXY0rpfJjKsBQrO1TV50/24htB8bTlslh7O63vfSgBXjfh2cvPkHxnSRssc0ekpo6u3KY1erfjA+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729916; c=relaxed/simple;
	bh=5sFX3aRX4NYWd5Uu2G8H5HIM6bFo1BEdw0BT2tyvt+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAqE7ort2AMtLUQgII0Cwz+aeTlBq5r8gipQmcgNeeIO6cgt4OYAoi5vKAIkii3u4BNDZKrW+BlsyfLlQSgGPfrdiPC44UFHcf+iCWkrzR+Y0tfmhfRDFpLykDgr3BysaWaaZG1FOrebUuvD7yfrpQmtRyU4EqsmTg5OPoH9Ro4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0OC41o6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0OC41o6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199BAC4AF0A;
	Thu, 15 Aug 2024 13:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729916;
	bh=5sFX3aRX4NYWd5Uu2G8H5HIM6bFo1BEdw0BT2tyvt+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0OC41o6ITRffTJHzSMhLEGROKDIyU8sqNiVLYilxZTZZKIfWotR2gOXI+acfV5WJ
	 DOjeVnwYKDfaVpBOjWCcX8Gn2JsfKNi9W23WfAKkcdKiCO2kPc+cmChXfulF/cN+zl
	 vrc+1YuzlXdSWnrUWf7wtmUmjTZEsxHc5as3jk68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.15 248/484] MIPS: Loongson64: env: Hook up Loongsson-2K
Date: Thu, 15 Aug 2024 15:21:46 +0200
Message-ID: <20240815131950.978545812@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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


