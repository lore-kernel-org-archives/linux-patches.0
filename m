Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85C92A1B8;
	Sun,  1 Sep 2024 16:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209839; cv=none; b=pkJHZmlahgnOI3BYCmnWKAfl7JtEOYF6qxCabZnS2YiOXc/X6bKvGKcA9/pMrYbDbM05KB1KPqddSZ0ilJQIo3Kn90BNciBjsz4DSkqfU1dpI9acvOFCud5af5HMLRwvV3y/IsJnZrmaf8SnhROhY1SUVF9ZAhalwfVkS5qMTzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209839; c=relaxed/simple;
	bh=POXcYf1nU/W0v1f2nsHDAHFLmbwnR7om8gWjHdP/4tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZgRvtd1JhMv4M89De6zF9nhZYSnelCJIOtPYAb7wwo+/vKXOlfMfX6PA4rGW+cVXEOyeaKLy52olD9myPo/Mh8JfCsgbMJto3Z2Elryw4yAs8RWfvd4+GlQQfrW75Ow98x5iX8QwcgE3/159gzvEIL0v/++yLAa8Nahl+RXDOhQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zddYzB1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zddYzB1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1CAC4CEC3;
	Sun,  1 Sep 2024 16:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209839;
	bh=POXcYf1nU/W0v1f2nsHDAHFLmbwnR7om8gWjHdP/4tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zddYzB1DFqj59OY1dRpPoHmiTfpIY4gd33gAVBSlwfOtNhnUcTzd5z0a318lLvRTu
	 zgy8FyxFDpOJj+XKd9yDJf1BnPpFx7Bf28O3FUU34x6iBunvbETSK5G2J6s1RG4A1R
	 PorCpilI5GwKS9vARuub4bPlgJ1tZnD1W+46OEtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Haibo Xu <haibo1.xu@intel.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Sunil V L <sunilvl@ventanamicro.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Hanjun Guo <guohanjun@huawei.com>
Subject: [PATCH 5.15 010/215] arm64: ACPI: NUMA: initialize all values of acpi_early_node_map to NUMA_NO_NODE
Date: Sun,  1 Sep 2024 18:15:22 +0200
Message-ID: <20240901160823.631245293@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

From: Haibo Xu <haibo1.xu@intel.com>

commit a21dcf0ea8566ebbe011c79d6ed08cdfea771de3 upstream.

Currently, only acpi_early_node_map[0] was initialized to NUMA_NO_NODE.
To ensure all the values were properly initialized, switch to initialize
all of them to NUMA_NO_NODE.

Fixes: e18962491696 ("arm64: numa: rework ACPI NUMA initialization")
Cc: <stable@vger.kernel.org> # 4.19.x
Reported-by: Andrew Jones <ajones@ventanamicro.com>
Suggested-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Haibo Xu <haibo1.xu@intel.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Sunil V L <sunilvl@ventanamicro.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Acked-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/853d7f74aa243f6f5999e203246f0d1ae92d2b61.1722828421.git.haibo1.xu@intel.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/acpi_numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kernel/acpi_numa.c
+++ b/arch/arm64/kernel/acpi_numa.c
@@ -27,7 +27,7 @@
 
 #include <asm/numa.h>
 
-static int acpi_early_node_map[NR_CPUS] __initdata = { NUMA_NO_NODE };
+static int acpi_early_node_map[NR_CPUS] __initdata = { [0 ... NR_CPUS - 1] = NUMA_NO_NODE };
 
 int __init acpi_numa_get_nid(unsigned int cpu)
 {


