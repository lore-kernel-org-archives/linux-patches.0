Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0D97279DC9;
	Sat, 30 May 2026 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165661; cv=none; b=ZZzqfLqoMDTq6u5lafWlb2bok4Y65rIncg2FJgLKTR0zPSRwAqvta2ryKspy/mZ5n/bjf+T17dK6Cbbam7xxF5pt6Mwvo3DmNVaYWdqv9AqDHwI4fQbOlzS9am8F0vChMLYx7Cq3CIITcSG1fHFfoLhMJUhmQBe/grOYswoK8HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165661; c=relaxed/simple;
	bh=RGPv6iYghDSxkm4qlfGz/Q3L26u0hVBLKFSnwKc4a94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RqbdCHKlGpf3wfTpbTrCJh9IUltzu77LnMGnJ4hADgNfnD+3ss8TqTmR9HtR2I0nU4yY/vyDYonxAjjC77pwRJ63dtUn/1/56zyrs55/LCTEjXcmLNumJt+FGFLKOFu4yrzhoamv25XVqeE1gC8nNdqD+bEtkeaf74TFPsF1so4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TX+A6Ss9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TX+A6Ss9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D78E51F00893;
	Sat, 30 May 2026 18:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165660;
	bh=YTL7HGiTzjRPslyjM+4AwBDFApsff37vCsciWr4tCZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TX+A6Ss9XgM4Z5B+KsQ3Ah8egT5y+ZSqR/qJpEsXM6dUdAX+jlx9oLFEIhHQmFmKa
	 gIAfKYYKzhUD4V7WvG+bJi4PACfibxtYnfmwgG4/6IHfZS57RvzHu5muBQ9r/rYymO
	 FxhVz71GIL51QzVihOfFiihL+ruQuYg64TqJJx94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 145/589] Revert "riscv: Sparse-Memory/vmemmap out-of-bounds fix"
Date: Sat, 30 May 2026 18:00:26 +0200
Message-ID: <20260530160228.597437731@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
User-Agent: quilt/0.69
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

This reverts commit 8af1c121b0102041809bc137ec600d1865eaeedd.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 982745572945e..a754125ca4b8e 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -44,7 +44,7 @@
  * Define vmemmap for pfn_to_page & page_to_pfn calls. Needed if kernel
  * is configured with CONFIG_SPARSEMEM_VMEMMAP enabled.
  */
-#define vmemmap		((struct page *)VMEMMAP_START - (phys_ram_base >> PAGE_SHIFT))
+#define vmemmap		((struct page *)VMEMMAP_START)
 
 #define PCI_IO_SIZE      SZ_16M
 #define PCI_IO_END       VMEMMAP_START
-- 
2.53.0



