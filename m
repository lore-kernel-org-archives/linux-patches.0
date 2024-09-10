Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F050B18C03D;
	Tue, 10 Sep 2024 09:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962170; cv=none; b=T/8wyw2Ptq/y9HmC82NJGz0f40J7o4OSOVm53n+SSIgW28xlcahmjHjBhyoqvizpvfZktIqC8tYyhRlYbL5egF0oMm4hN+AB8sf/JbOu7PMtytJEHT6iwDWBJRi0nnaCYOp3Y0/2sAnHn+7iKGvbDPh/EOTWy3WhRSVWkaB2Bso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962170; c=relaxed/simple;
	bh=37UF3WiLWi6TitBydMjue6tD02Ym2dtzIsbfqajNw5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=skLQqknDN48aiqwuKCql4ynZ2J7tOQGPD2ueGymf4ZVpAZvk+sAkPnous7GBpDDR4eLeqL+Iu+9V8sAxzp9vBveKQqdlHH6EI07Dg4tYihWJPjb78Fq5iWidRpGdff9JDq9ukL4GgIrwgVezvFwe7/Db1xBFoNucHhQD0+5BDSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zSMz/9eU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zSMz/9eU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49266C4CEC3;
	Tue, 10 Sep 2024 09:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962169;
	bh=37UF3WiLWi6TitBydMjue6tD02Ym2dtzIsbfqajNw5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zSMz/9eUxqBbkpd0J/klNQExzzKNyDfuhsr55+7vyRZKcG1Q0osRRthINl18qlqs4
	 e9o5VEI2WQhN5vWIrAMMZQqijuzS+c761axLbMytJZeqsfglf3Jnydri1OrTY2gHU0
	 ZVTN0bxzbQbD0+nBECPWMy6SZUeT4jmPFGOY0a9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Gavin Shan <gshan@redhat.com>,
	Miguel Luis <miguel.luis@oracle.com>,
	Vishnu Pajjuri <vishnu@os.amperecomputing.com>,
	Jianyong Wu <jianyong.wu@arm.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Hanjun Guo <guohanjun@huawei.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 319/375] arm64: acpi: Move get_cpu_for_acpi_id() to a header
Date: Tue, 10 Sep 2024 11:31:56 +0200
Message-ID: <20240910092633.285056285@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Morse <james.morse@arm.com>

[ Upstream commit 8d34b6f17b9ac93faa2791eb037dcb08bdf755de ]

ACPI identifies CPUs by UID. get_cpu_for_acpi_id() maps the ACPI UID
to the Linux CPU number.

The helper to retrieve this mapping is only available in arm64's NUMA
code.

Move it to live next to get_acpi_id_for_cpu().

Signed-off-by: James Morse <james.morse@arm.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Miguel Luis <miguel.luis@oracle.com>
Tested-by: Vishnu Pajjuri <vishnu@os.amperecomputing.com>
Tested-by: Jianyong Wu <jianyong.wu@arm.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Acked-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Link: https://lore.kernel.org/r/20240529133446.28446-12-Jonathan.Cameron@huawei.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Stable-dep-of: 2488444274c7 ("arm64: acpi: Harden get_cpu_for_acpi_id() against missing CPU entry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/acpi.h | 11 +++++++++++
 arch/arm64/kernel/acpi_numa.c | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index 6792a1f83f2a..bc9a6656fc0c 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -119,6 +119,17 @@ static inline u32 get_acpi_id_for_cpu(unsigned int cpu)
 	return	acpi_cpu_get_madt_gicc(cpu)->uid;
 }
 
+static inline int get_cpu_for_acpi_id(u32 uid)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
+		if (uid == get_acpi_id_for_cpu(cpu))
+			return cpu;
+
+	return -EINVAL;
+}
+
 static inline void arch_fix_phys_package_id(int num, u32 slot) { }
 void __init acpi_init_cpus(void);
 int apei_claim_sea(struct pt_regs *regs);
diff --git a/arch/arm64/kernel/acpi_numa.c b/arch/arm64/kernel/acpi_numa.c
index ccbff21ce1fa..2465f291c7e1 100644
--- a/arch/arm64/kernel/acpi_numa.c
+++ b/arch/arm64/kernel/acpi_numa.c
@@ -34,17 +34,6 @@ int __init acpi_numa_get_nid(unsigned int cpu)
 	return acpi_early_node_map[cpu];
 }
 
-static inline int get_cpu_for_acpi_id(u32 uid)
-{
-	int cpu;
-
-	for (cpu = 0; cpu < nr_cpu_ids; cpu++)
-		if (uid == get_acpi_id_for_cpu(cpu))
-			return cpu;
-
-	return -EINVAL;
-}
-
 static int __init acpi_parse_gicc_pxm(union acpi_subtable_headers *header,
 				      const unsigned long end)
 {
-- 
2.43.0



