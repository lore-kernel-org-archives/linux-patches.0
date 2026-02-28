Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9134433F38A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301187; cv=none; b=l3cUyvAe447v1ByxXRMHAJr/2kjSiEHjb57O9MllBam4BerSWiRuFe9Mg+ixM655cod4SnTKmO7ztQSYC8v0fCbfdMUYSawKUgxgVQfrHxE4itOzS9oijKiTqn6s3CopLI3mAq58HZFrSuJ+oOcASe09EtZzYdTYP3pcMNvdgck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301187; c=relaxed/simple;
	bh=rVn4T+1vnnJGADQEtIx/kYDPe7oJdBkEqyDhGHEpXTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe+98lo3RLDgHRzzMuOj395G1gr0VZL35iaXwZS2Hut9utMZ0DNiZFuyCDRv8oxMhUntSqQxyd6biSytopoqfJi2Dp0ffwyGmAafpq9/wLqKdL03mlp9ABUwfnPaN7uTWa0JmS4wIdfdNZdKpEzVnmtHG0wVKVCdgbIGT5jNRYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OS8/LqFT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OS8/LqFT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E013AC116D0;
	Sat, 28 Feb 2026 17:53:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301187;
	bh=rVn4T+1vnnJGADQEtIx/kYDPe7oJdBkEqyDhGHEpXTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OS8/LqFTHP2vZOEwHTuWR7ltNAIGvgUyi862lVyZUjrI9PWuE87YtUoLV9wBmYWq0
	 xwOPMd5/VKgtjvy+A9BOJCFBsiJ5zKUDNx6XnJ96+O2DdC+JXQOKO5w9sH+PR7zgIC
	 WsnHcDboyZOggCBq0XPd4L+3yNnlsB3yCkpkpGSJpLNm64aymjehQBTPYptca3Ksa0
	 XdWhwZGXESz8T+twq8h+MkKTSD2+AJtZUsaMr4xPJH+3S+sybSEb48s7WkN/YyzeLh
	 OoWniH9Rxp7M2swo4hCvBVEoUHwHJcxp/hXz8EPk+fOgUrWpt5lZGSibMJ6DnJV8p4
	 s8wIUNJQAFKJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: John Garry <john.g.garry@oracle.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 357/752] MIPS: Loongson: Make cpumask_of_node() robust against NUMA_NO_NODE
Date: Sat, 28 Feb 2026 12:41:08 -0500
Message-ID: <20260228174750.1542406-357-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit d55d3fe2d1470ac5b6e93efe7998b728013c9fc8 ]

The arch definition of cpumask_of_node() cannot handle NUMA_NO_NODE - which
is a valid index - so add a check for this.

Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mach-loongson64/topology.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mach-loongson64/topology.h b/arch/mips/include/asm/mach-loongson64/topology.h
index 3414a1fd17835..89bb4deab98a6 100644
--- a/arch/mips/include/asm/mach-loongson64/topology.h
+++ b/arch/mips/include/asm/mach-loongson64/topology.h
@@ -7,7 +7,7 @@
 #define cpu_to_node(cpu)	(cpu_logical_map(cpu) >> 2)
 
 extern cpumask_t __node_cpumask[];
-#define cpumask_of_node(node)	(&__node_cpumask[node])
+#define cpumask_of_node(node)	  ((node) == NUMA_NO_NODE ? cpu_all_mask : &__node_cpumask[node])
 
 struct pci_bus;
 extern int pcibus_to_node(struct pci_bus *);
-- 
2.51.0

