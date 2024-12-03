Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26E11F7071;
	Tue,  3 Dec 2024 14:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237793; cv=none; b=A5hcbwsxpemc7WO6JCKUmh8BiXcqBMbdgsSh7WSH2jhw1hp8dOvPxeqe0Tv3yyebVlqXQEG9ddG0Whf/fYxNTkHcKOpLC+/R9InK14VI1Sb7z2osB5mvDpi3hwLQHpXzPe1oqLgS8qB6lYRl9eEvBalc59sP0smQATpDlGuiIOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237793; c=relaxed/simple;
	bh=vvlkjCmb7hepwNBxhEFuLFSs67CCqGuxBs9WZoE2On0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bm3D8eEfuDAFj4P573EOjKtBD/2Th0L6N1e3PgOghrosR2cili2/KHsvTHaBzdOq6X8L7IqmY2m/i2fhoezGjvA4ttWgaHRQFRsi+Im1WdEDX1gwfCcxpERk9pKfJ2HPKxcgfecLR0nmqhB3Yf3C2OghwRDEsOiwBDjHUkfDtRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H/KKbCXa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/KKbCXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61161C4CECF;
	Tue,  3 Dec 2024 14:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237792;
	bh=vvlkjCmb7hepwNBxhEFuLFSs67CCqGuxBs9WZoE2On0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/KKbCXaT3L2Ez/5Ny5QI/aVH8izcifmJcDvZI07deOsLwGGigqw3xbrPGPKF7iCc
	 yHLwiPv1797e/fSuUPCbx3u8QCtmlg/UUzU6uQMEHRLNJRuJpz7tGD1Qu4u7pKc2Tf
	 R1mobnaRCxXJkWYM0Xxhv3ZuLYtT6fiRep1hLymU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 040/817] LoongArch: Define a default value for VM_DATA_DEFAULT_FLAGS
Date: Tue,  3 Dec 2024 15:33:32 +0100
Message-ID: <20241203143957.224077045@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuli Wang <wangyuli@uniontech.com>

[ Upstream commit c859900a841b0a6cd9a73d16426465e44cdde29c ]

This is a trivial cleanup, commit c62da0c35d58518d ("mm/vma: define a
default value for VM_DATA_DEFAULT_FLAGS") has unified default values of
VM_DATA_DEFAULT_FLAGS across different platforms.

Apply the same consistency to LoongArch.

Suggested-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Yuli Wang <wangyuli@uniontech.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/include/asm/page.h | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/loongarch/include/asm/page.h b/arch/loongarch/include/asm/page.h
index e85df33f11c77..8f21567a3188b 100644
--- a/arch/loongarch/include/asm/page.h
+++ b/arch/loongarch/include/asm/page.h
@@ -113,10 +113,7 @@ struct page *tlb_virt_to_page(unsigned long kaddr);
 extern int __virt_addr_valid(volatile void *kaddr);
 #define virt_addr_valid(kaddr)	__virt_addr_valid((volatile void *)(kaddr))
 
-#define VM_DATA_DEFAULT_FLAGS \
-	(VM_READ | VM_WRITE | \
-	 ((current->personality & READ_IMPLIES_EXEC) ? VM_EXEC : 0) | \
-	 VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC)
+#define VM_DATA_DEFAULT_FLAGS	VM_DATA_FLAGS_TSK_EXEC
 
 #include <asm-generic/memory_model.h>
 #include <asm-generic/getorder.h>
-- 
2.43.0



