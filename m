Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C219D2D7D47;
	Thu, 15 Jan 2026 17:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496614; cv=none; b=C+SJIw/p2c+NpK+fLDJi0sDpFIxLQY4Ainj3oP8XKRCbDHhKgJQ3Uoaz8GbGQMSjumzc6BM5CZ797hL4movFAqEpXzrIWXIgCF5qSr93KWTGA+VwDqtdhWlqpJhwQDQYwE5CFbhewdudjwJ3CEeILj6gkzTRU8tT+Sj0fgiD7Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496614; c=relaxed/simple;
	bh=qF6l0ghutMNseiJJxFdkkNRFhG9qDeXOxTeGegx+I+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B0ZuFdkQTr/z3ZP7vDu7eSNZc34s7Ilt8lS6eD0e+4EZkG2bwgMSs2IX5CV2clTwEc+FoCetTx+KXVjOGPIP8HrR3bh9zHBs7Pop9KdpNRL+R7JOq1Acj0IGHsYDXOVvHcu4/8w0iIWlHChtkN0jnj3Yfk+Hp7VIHTK1OLiYa5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/K6QrZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/K6QrZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FB77C116D0;
	Thu, 15 Jan 2026 17:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496614;
	bh=qF6l0ghutMNseiJJxFdkkNRFhG9qDeXOxTeGegx+I+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/K6QrZ7l5sDIO1psbl3Xofj2f8AL10KZLZEult2ujAub+aWBp/dlab9+Psol8GyG
	 5Zb/McAqy0KNEk2pKDAWKRLg9aWng+zDU0H+WMdJDnxzTwKMHyxgxmrL8WLIMZbBik
	 uLg/UF4gwnCQjVsYkA0uHNp3dF9M7fBGpwhYYKWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Guo Ren (Alibaba DAMO Academy)" <guoren@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/119] riscv: pgtable: Cleanup useless VA_USER_XXX definitions
Date: Thu, 15 Jan 2026 17:48:10 +0100
Message-ID: <20260115164154.659501708@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 87c7d94c71f13..aeba8028e9aa8 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -119,10 +119,6 @@
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



