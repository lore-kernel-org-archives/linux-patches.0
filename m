Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E3123A6;
	Tue, 10 Sep 2024 10:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965220; cv=none; b=rkFFNlLbmc7ifUIaGnMktQHBcWVyNh3UP3PqSf86KQMaqFtIYH0693q1Sit5tGDx6SHoaiXEFT5Z5bi4e5P5pXznuIWSg8lvR3I157Q7COU6Z54GnL84855IO32xdbJWDDN8i3CTyb9ou/6Pewbrxq6WzRAFQn0UMjdj2Z+QfRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965220; c=relaxed/simple;
	bh=wf0xyXgvTW6U/ecU057nL7U6NXcBlqS60t3GErLDhW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IuFnZgEsRvmHeocypQq8wz2GB2UfJM86PCzvZUm0fQQc/6w3CE4EA8hAIln43oUg+ciWmJ0mxeaPM/3zP7cMaI9iHria0J3MBKUyGsfVh8UAxTCLy3q49nw+42WZiceokVH5UFVNM1Hf5ItL5OaCdlxQmJlnO8N84mRhhsChB1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=04rzUlmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="04rzUlmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560D2C4CEC3;
	Tue, 10 Sep 2024 10:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965219;
	bh=wf0xyXgvTW6U/ecU057nL7U6NXcBlqS60t3GErLDhW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=04rzUlmjPRC2dyk3Fsy/C5HsuViBTA9RoGgNZRZzK7dm2PPmZa8HjtgbHaymMEyBh
	 La5+0o3ZmT6gClXbbrhhj8QBmt5bN/lFZB6tkCgNXwIq+l6dv2bf7dKJ1oby0olcxy
	 TS8vB2hHjyBnhQYTSyDj5GzeYA9aDGLahnbig0BU=
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
Subject: [PATCH 5.10 177/186] arm64: acpi: Move get_cpu_for_acpi_id() to a header
Date: Tue, 10 Sep 2024 11:34:32 +0200
Message-ID: <20240910092601.915443704@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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
index bd68e1b7f29f..0d1da93a5bad 100644
--- a/arch/arm64/include/asm/acpi.h
+++ b/arch/arm64/include/asm/acpi.h
@@ -97,6 +97,17 @@ static inline u32 get_acpi_id_for_cpu(unsigned int cpu)
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



