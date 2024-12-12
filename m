Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C4613792B;
	Thu, 12 Dec 2024 15:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018762; cv=none; b=c9i63JOBJOuyu3HowFHUDWFNKKxM6GiAq+IgCsQiDn6IX2p7vNsBJWghj7PijqtOMPnSSPE9VY7NeOp3aOv7uVxDjZrgF7lPkFIKMSq+LywnETAd4uAAUoMlawttHsNZIL3V/NsmBJhMEm/lj6VOX+mi9Q6pP6YIQXHRp1rmwr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018762; c=relaxed/simple;
	bh=x6wlQNfv4wXinj6FQbAjpGgBlt6fZBvpWPeCxyKpJ5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o9y/frtf3YpixKpyHvGlzkuMrTLk6kR3CYRXSLpOLhrS+5hFqMdupvqy6cVhnadBMlvNFwLlWQHL1fItjF5IvAPxNnIaZj8Mwd91fLVc+hWxRyPRYSIA6BGXv1zKdy9qXp92qVEizUGbL/HyR9PDmz7o+bNqn/SIMltI/o6byCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MFJRorTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFJRorTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E25C4CECE;
	Thu, 12 Dec 2024 15:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018761;
	bh=x6wlQNfv4wXinj6FQbAjpGgBlt6fZBvpWPeCxyKpJ5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFJRorTH1MJrZZtLQCi5m4g0S19tmRKmXgLGY5jVTPmFbdROfUKzsdcReqDOkpyre
	 PjqxMGwBEDx1iJSkPveaEgWxt7zHZ68cSUQNXlfKgRnUxd4etR1FBjLP0tju1fzATY
	 blQWX9eUZhEcJzVsp7UfhfWADV9jShsWlq3H6NxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Yuli Wang <wangyuli@uniontech.com>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 025/772] LoongArch: Define a default value for VM_DATA_DEFAULT_FLAGS
Date: Thu, 12 Dec 2024 15:49:30 +0100
Message-ID: <20241212144350.988211050@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bbac81dd73788..9919253804e61 100644
--- a/arch/loongarch/include/asm/page.h
+++ b/arch/loongarch/include/asm/page.h
@@ -102,10 +102,7 @@ static inline int pfn_valid(unsigned long pfn)
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



