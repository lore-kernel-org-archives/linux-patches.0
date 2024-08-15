Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF4363D5;
	Thu, 15 Aug 2024 14:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732441; cv=none; b=EF8TUnekRjwFOtN5ZgmwulqL7Yu1CqyyGl+jK29DU9jxscoJq5nDr3CSE1460GJ0OatKz0GnBtu0wKazkpx0JIzO3ObG489yQjtFWFb6k2t2EhR59xpTSoyzdtB8y9filH5ZHKEmoNYD6+Bh+LpaRz8VOTbMwI9WNbWKL+86EmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732441; c=relaxed/simple;
	bh=gWYicl5PWw0fOU+jVEMLiPIZLMnNpLK1ptjWpQUt7gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZ7coy/z7fcnphOYwPkTM+/or1fsZa0EnYRcKJPKg6du4eiFjzmKQBH9y7hCi6DyIRAGTV4zX2VQMYZcPZO4I3Lu7g+hIZ2ohqjklJRpqI8B4KZ9nvpCcxenxptsuw27+pBnyPLu53R8e1x+OZf8bG658tJTfIzvW/tLagjMnKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuesH6dF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuesH6dF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D18C4AF0D;
	Thu, 15 Aug 2024 14:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732441;
	bh=gWYicl5PWw0fOU+jVEMLiPIZLMnNpLK1ptjWpQUt7gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuesH6dFc98k+BAzIJlfwkqlORdIlmQxNGlt3RYEJ3lT2lPDKz4I1/95PjC0lsPnZ
	 gyEupPK9QfPlReqW1KrpiekvrP/6x0g7EZZN9mmXu244m4ui7OdfOq9tt8aAcQ0Smn
	 DJfNlLy4EGtJgJcTzGSxtOW7ENIbq/dX2/CWt7JI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 5.10 179/352] MIPS: Loongson64: env: Hook up Loongsson-2K
Date: Thu, 15 Aug 2024 15:24:05 +0200
Message-ID: <20240815131926.195961283@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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
@@ -38,12 +38,14 @@ enum loongson_cpu_type {
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
@@ -65,6 +65,12 @@ void __init prom_init_env(void)
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
@@ -213,6 +219,8 @@ void __init prom_init_env(void)
 		default:
 			break;
 		}
+	} else if ((read_c0_prid() & PRID_IMP_MASK) == PRID_IMP_LOONGSON_64R) {
+		loongson_fdt_blob = __dtb_loongson64_2core_2k1000_begin;
 	} else if ((read_c0_prid() & PRID_IMP_MASK) == PRID_IMP_LOONGSON_64G) {
 		if (loongson_sysconf.bridgetype == LS7A)
 			loongson_fdt_blob = __dtb_loongson64g_4core_ls7a_begin;


