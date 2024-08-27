Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6047C1C6894;
	Tue, 27 Aug 2024 14:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769848; cv=none; b=TyBPluPnCIiP/NsYU2E9OyDtBuBnaG1+9OtKKSc/KYL7tJe4D7Bu5bFsEKJfahRW0tOs/Ifodxw2yC/CN7Wg8Omz/ByVanF/zX9SxbRAFCnoeJMYM4ANyvmY9GQmVok5nlYUOMZgCM2M2tmq5fFj+90dkWramEDWRMJCWp+eQDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769848; c=relaxed/simple;
	bh=fdfEcRa/KPcOXPckQptkErFAXFg08aqFkRXSqTleDrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hxzKPdioGTGqffwUgFc/jWwvWaOOkQb7av7OZnYmp6jBeBEp3aJt/iC3tDDovlBxHJiwSPcWEj2FbNzFpXGCdS5phscG59LLq6V++LLvnkclLbf8JTL5Rs3Pg9vDuk5mu2MWUmoQ9ph6pJjCUeb3rBVaLXZgm8XV9+VQUeK6C4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1RI0sJU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1RI0sJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68783C6106B;
	Tue, 27 Aug 2024 14:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769847;
	bh=fdfEcRa/KPcOXPckQptkErFAXFg08aqFkRXSqTleDrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1RI0sJUqFV3+zJ/HX9ZhA0dSzAN9rYd8THR4einBFT4w0bheGvl6V7GjX0jkj4hy
	 OBnskYDUXPPWOxk6CJomKsrbWL+z4lQAzF9dBcn7xJVKVa7hsuwMT5LjtC3mYdP6jU
	 3GCi5ghScAWFdrmJk9rhTI58MMt7tiOPsBjMJnXc=
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
Subject: [PATCH 6.6 022/341] arm64: ACPI: NUMA: initialize all values of acpi_early_node_map to NUMA_NO_NODE
Date: Tue, 27 Aug 2024 16:34:13 +0200
Message-ID: <20240827143844.251522899@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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


