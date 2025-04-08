Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BC32267F4F;
	Tue,  8 Apr 2025 11:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111879; cv=none; b=fesZnougahh6jKxsYPTZEm1np4Hv6+BwXPAx61veMDuGwACyHV1ISV6rl+jEg9UyHYgQ7Iv9ojMj01FmF/PsI0eEL5rKWyOXASYtbURNAPwk++o96GoRFHBzJKEY2QGqXQwaJHYV3sISEYwmLYVxeosDObGOjsFAhrT2/jIj+Ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111879; c=relaxed/simple;
	bh=tOQDrMJABZnEoYeNCGhPB0HWx76PKhPJX0yltLpgDow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hPqrBSg32knLuc3M7+ku0loDOli0vLKEmpGmXJmmkiBTPyhEiDIk2DXH5P4cfp73PlAoOgeRzr0NrgOQAH/v2aVVVHo2O8rRSfNldWYQ22sip72IgGRHybvwwMN6+LxO4D7A5zBRxLX6rjIDzFl0wtz9V4aO3D6+tQGhTYMPs68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sciEBaMb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sciEBaMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5212EC4CEE5;
	Tue,  8 Apr 2025 11:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111878;
	bh=tOQDrMJABZnEoYeNCGhPB0HWx76PKhPJX0yltLpgDow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sciEBaMbB3wUqzCjozR44vtyap1KQMfwvs+fdS0MukrZoMedR5ITaxZYDasNIP6TL
	 g4ADYVkA188ErzBU9KaJR4t6eavUdlnSgeQ2GHHzZzuq8TZ6W/y6bpRku6cacILTen
	 lwv+SDRqrBDONSfN5L0b3EgmMq07PFicHd6lwnGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 591/731] riscv: Change check_unaligned_access_speed_all_cpus to void
Date: Tue,  8 Apr 2025 12:48:08 +0200
Message-ID: <20250408104928.021306701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit 813d39baee3229d31420af61460b97f4fafdd352 ]

The return value of check_unaligned_access_speed_all_cpus() is always
zero, so make the function void so we don't need to concern ourselves
with it. The change also allows us to tidy up
check_unaligned_access_all_cpus() a bit.

Reviewed-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20250304120014.143628-14-ajones@ventanamicro.com
Signed-off-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Stable-dep-of: 05ee21f0fcb8 ("riscv: Fix set up of cpu hotplug callbacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/unaligned_access_speed.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/riscv/kernel/unaligned_access_speed.c b/arch/riscv/kernel/unaligned_access_speed.c
index 78ab4cb2ab050..bca798153e37d 100644
--- a/arch/riscv/kernel/unaligned_access_speed.c
+++ b/arch/riscv/kernel/unaligned_access_speed.c
@@ -218,7 +218,7 @@ static int riscv_offline_cpu(unsigned int cpu)
 }
 
 /* Measure unaligned access speed on all CPUs present at boot in parallel. */
-static int __init check_unaligned_access_speed_all_cpus(void)
+static void __init check_unaligned_access_speed_all_cpus(void)
 {
 	unsigned int cpu;
 	unsigned int cpu_count = num_possible_cpus();
@@ -226,7 +226,7 @@ static int __init check_unaligned_access_speed_all_cpus(void)
 
 	if (!bufs) {
 		pr_warn("Allocation failure, not measuring misaligned performance\n");
-		return 0;
+		return;
 	}
 
 	/*
@@ -261,12 +261,10 @@ static int __init check_unaligned_access_speed_all_cpus(void)
 	}
 
 	kfree(bufs);
-	return 0;
 }
 #else /* CONFIG_RISCV_PROBE_UNALIGNED_ACCESS */
-static int __init check_unaligned_access_speed_all_cpus(void)
+static void __init check_unaligned_access_speed_all_cpus(void)
 {
-	return 0;
 }
 #endif
 
@@ -406,10 +404,10 @@ static int __init vec_check_unaligned_access_speed_all_cpus(void *unused __alway
 
 static int __init check_unaligned_access_all_cpus(void)
 {
-	bool all_cpus_emulated;
 	int cpu;
 
-	all_cpus_emulated = check_unaligned_access_emulated_all_cpus();
+	if (!check_unaligned_access_emulated_all_cpus())
+		check_unaligned_access_speed_all_cpus();
 
 	if (!has_vector()) {
 		for_each_online_cpu(cpu)
@@ -420,9 +418,6 @@ static int __init check_unaligned_access_all_cpus(void)
 			    NULL, "vec_check_unaligned_access_speed_all_cpus");
 	}
 
-	if (!all_cpus_emulated)
-		return check_unaligned_access_speed_all_cpus();
-
 	return 0;
 }
 
-- 
2.39.5



