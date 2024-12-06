Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FB910E0;
	Fri,  6 Dec 2024 14:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496526; cv=none; b=Xw4XkRFKkeww5h/FwTzTwdw+gAYfdIahl4gKkTZKC/9ntjaS8X0H7DcOTlM/AENoDHO2b5mFp3AJ0wh3SLKzd+9oxmU3YHGaSULRrFE7apN1QWcxZCG5AvBaR1BFSTJbEXSxjto3pXsHeu8Z3kpfVcnAxhK9BP/rVAE1TskJxBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496526; c=relaxed/simple;
	bh=K6BsT2O59tS/3XYliLx2tcXoFYfPbi2Phxmpc25SqBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U5Q93D64Mfmlc5hEdSmBGawBHkgXMrF1NCV0W9mBEUsp9Vhgw4YfxUAV9GO6tAuz6CcM6G4YciVa4BU8GwuGtptS5tkAt/Fu90j4UhEQz83YznfGmY49AQIDFJwy5HAatqNYxVU0ug0jBf8XQmov9vCFLpf1i71Hol78cl+wBEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fxbbPeg0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fxbbPeg0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6618C4CED1;
	Fri,  6 Dec 2024 14:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496526;
	bh=K6BsT2O59tS/3XYliLx2tcXoFYfPbi2Phxmpc25SqBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fxbbPeg0PkrXt9/ZjXVpviJnMX+t5OsfeG0uEHEpnykpgqZeHkAadrOjjCymngRcG
	 axUQmY4/MxlVQ3p0hKFX1GalFO98x34cYSE9zF1Y/re8hgityeE1j4pYEERGYpdPIN
	 G4G9yoOpkuD2IOGa4WUEg/EH1kIi1V/w2yenumZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/676] LoongArch: Define a default value for VM_DATA_DEFAULT_FLAGS
Date: Fri,  6 Dec 2024 15:27:29 +0100
Message-ID: <20241206143654.532590210@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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
index 63f137ce82a41..f49c2782c5c4d 100644
--- a/arch/loongarch/include/asm/page.h
+++ b/arch/loongarch/include/asm/page.h
@@ -94,10 +94,7 @@ typedef struct { unsigned long pgprot; } pgprot_t;
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



