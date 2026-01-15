Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0773BC4E4;
	Thu, 15 Jan 2026 16:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496219; cv=none; b=TdqOMKY7XBDLOSObVtYSov4hP4blpWiUVmSAvMGhZDN2T6IMzUJ0lwBHvoE8ylAEpV4uVsT1vwHa+77TO0EE9rDQcbTkn3lPo2HtIDpb3vIRLZfMecc+mjCI/d1gj8dNjTroP0+roBYIa5zKjYzzT1rdCVMS4Cvf5HTYWApsmso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496219; c=relaxed/simple;
	bh=Ij8hvtT36HhzZrbVxUYU3oEAAB6mxO2cLuSkJH9UJWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvKPtYhgWMAsmErNf5q/wSIXa0AWQTmTBD1vHydkJpI0BlFb1oIu8fK3uCzbcYik7ZgdGrxTJa6ig35gzLKtyJzzapdR3C3gKiN+LhkGKKApL50IkzAfehVnFwlC3P4eeTacSHDNhiBpmPt6hTTJ8/5G34EQnxP60gjbL7WGOWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrRqPatb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrRqPatb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C28C116D0;
	Thu, 15 Jan 2026 16:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496219;
	bh=Ij8hvtT36HhzZrbVxUYU3oEAAB6mxO2cLuSkJH9UJWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lrRqPatbHy56M3mpqzguQN/RoGp8txmiEBGhqpKA+G6cYTUYussciL8woWdzRKTJ/
	 9KpvfO6JlawoplKvcnspOqvnz8qiMy83/96hcURAGhj+2oOnCCKFlahjp1uFK+SlBj
	 UxlD2luDvhZ63hVeHBiq6rdLCY3edui49LbcXa/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/181] riscv: pgtable: Cleanup useless VA_USER_XXX definitions
Date: Thu, 15 Jan 2026 17:47:37 +0100
Message-ID: <20260115164206.645190842@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>

[ Upstream commit 5e5be092ffadcab0093464ccd9e30f0c5cce16b9 ]

These marcos are not used after commit b5b4287accd7 ("riscv: mm: Use
hint address in mmap if available"). Cleanup VA_USER_XXX definitions
in asm/pgtable.h.

Fixes: b5b4287accd7 ("riscv: mm: Use hint address in mmap if available")
Signed-off-by: Guo Ren (Alibaba DAMO Academy) <guoren@kernel.org>
Reviewed-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patch.msgid.link/20251201005850.702569-1-guoren@kernel.org
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 5a08eb5fe99fc..30d1ea93dde34 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -124,10 +124,6 @@
 #ifdef CONFIG_64BIT
 #include <asm/pgtable-64.h>
 
-#define VA_USER_SV39 (UL(1) << (VA_BITS_SV39 - 1))
-#define VA_USER_SV48 (UL(1) << (VA_BITS_SV48 - 1))
-#define VA_USER_SV57 (UL(1) << (VA_BITS_SV57 - 1))
-
 #define MMAP_VA_BITS_64 ((VA_BITS >= VA_BITS_SV48) ? VA_BITS_SV48 : VA_BITS)
 #define MMAP_MIN_VA_BITS_64 (VA_BITS_SV39)
 #define MMAP_VA_BITS (is_compat_task() ? VA_BITS_SV32 : MMAP_VA_BITS_64)
-- 
2.51.0



