Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B2CB6AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12359C340E8;
	Wed, 23 Mar 2022 23:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076727;
	bh=cN6KBIeR25IM5UIqLOSNinPBe/r9usidocSKboM33EY=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=JSQNmCedpSw3WbTlHg22InEfeGPYrlyt2eElkmvKZVLHKIXPpVrWWQA600uynv4Fx
	 UXyI1JrZ+iN5TWbTAD2P9irTXYi5JK8vxSLXObXgnAn4yD8n3Bd0IcNsf2uO4jq1l9
	 orOWVvaT/3LyPBNYR31WwygwBlh3bdQ4kzZEPgOE=
Date: Wed, 23 Mar 2022 16:05:26 -0700
To: bhe@redhat.com,abaci@linux.alibaba.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 03/41] proc/vmcore: fix vmcore_alloc_buf() kernel-doc comment
Message-Id: <20220323230527.12359C340E8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Yang Li <yang.lee@linux.alibaba.com>
Subject: proc/vmcore: fix vmcore_alloc_buf() kernel-doc comment

Fix a spelling problem to remove warnings found by running
scripts/kernel-doc, which is caused by using 'make W=1'.

fs/proc/vmcore.c:492: warning: Function parameter or member 'size' not
described in 'vmcore_alloc_buf'
fs/proc/vmcore.c:492: warning: Excess function parameter 'sizez'
description in 'vmcore_alloc_buf'

Link: https://lkml.kernel.org/r/20220129011449.105278-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Acked-by: Baoquan He <bhe@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/vmcore.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/vmcore.c~proc-vmcore-fix-vmcore_alloc_buf-kernel-doc-comment
+++ a/fs/proc/vmcore.c
@@ -480,7 +480,7 @@ static const struct vm_operations_struct
 
 /**
  * vmcore_alloc_buf - allocate buffer in vmalloc memory
- * @sizez: size of buffer
+ * @size: size of buffer
  *
  * If CONFIG_MMU is defined, use vmalloc_user() to allow users to mmap
  * the buffer to user-space by means of remap_vmalloc_range().
_
