Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F211922EB;
	Tue, 10 Sep 2024 10:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962678; cv=none; b=lf9gm0knQ+ZZ7hlwVzHetYiNvW13M3r4yNzR+1Xn6EXz2QgpQePZ9IoTbphtM7ZpdCUx+nNskAb+BH42bR8Um30es+X1AwDSw0T+UUDM7YlBlRo6RG2CN3rLHefBKYjpzH9bskBFngXdOrcSj4PoQbHLtuTMnCWb91Tjgyn2Go4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962678; c=relaxed/simple;
	bh=SdOngYKkbqw/ovQLG3CUdqBBX/l3H6napyFZ3D2EtYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H4C1tw5GpwzQjW0PwHV0KgDAIwsfbmyblnnVPmv/64s2OrRULlCitv9/Jbf6dYyQ1r0QOfp+Aqw+ahGVIz7l1f3wFka2mYHrLqgWsm+QoHSZPwmgDT3ElkJm6OmhrU6M1BkCGCqLSyMugB1OXCfoJqD1elsE3fbYyJmVai8i4CI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArZLRenp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArZLRenp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3898C4CECE;
	Tue, 10 Sep 2024 10:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962678;
	bh=SdOngYKkbqw/ovQLG3CUdqBBX/l3H6napyFZ3D2EtYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ArZLRenpPXP1k6dUstitViRuOt1SWuVY8l07X86Z9mS1BONz/lpcEYVSfnPuKNgNz
	 K2kWbF7TvbYkuDVch4keePlZ4Yahc64g5CKavg5U0jVYntjKHDzgriLcmZ8iA9oKe8
	 ng15awLIwKP2tm1yOtTiBio4RsHwkOeb3bPKYq04=
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
Subject: [PATCH 5.4 114/121] arm64: acpi: Move get_cpu_for_acpi_id() to a header
Date: Tue, 10 Sep 2024 11:33:09 +0200
Message-ID: <20240910092551.227293495@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/acpi.h | 11 +++++++++++
 arch/arm64/kernel/acpi_numa.c | 11 -----------
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
index a45366c3909b..f391ea7a5409 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -110,6 +110,17 @@ static inline u32 get_acpi_id_for_cpu(unsigned int cpu)
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
index 048b75cadd2f..c5feac18c238 100644
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



