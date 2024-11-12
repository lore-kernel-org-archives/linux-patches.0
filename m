Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD9CE212D04;
	Tue, 12 Nov 2024 10:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407187; cv=none; b=h6iFpeDAuDqD7GD/DnZRbcXp2TDC3Vxa2XWCumb+uHKAL6Le47b8qLedsYewl2yIWd/hqypRao72LLoeO/cFB7bSjZZod0OBpNsbeGKUW/hyfukecs2YGJyuByAmvZ3Tps4g7rs3ug8ZcIdEVax60NRKEiXFrEv8zZIanplTEfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407187; c=relaxed/simple;
	bh=XbOnRAgCeO5QHDxunoiayV9VrTI9U/MQXvqWd58Ukts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bYNPBjWNYA9BMI0Srb+porpgVQvy1RvkBSYiONJdAw9wCORuY18QJXwJafyNcQuTwZU484kgouXTlDoNPqfote8CBqhvRRJ4Fl2YfUIg+6HJ8/SZbaWE51Gu2WNQUl0eViSftV/NEi5IbE6MJQ3+EdnvfLDmAionrQZRTZIrYP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B971AbZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B971AbZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B97EC4CECD;
	Tue, 12 Nov 2024 10:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407187;
	bh=XbOnRAgCeO5QHDxunoiayV9VrTI9U/MQXvqWd58Ukts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B971AbZVY6TmqvZbGh6OI+3+U4WxCOhtcXuLypbccqmIc1pw9QjM5YkL6SbgDm49Y
	 RRoqlqhZ63Jb6RUSQuzJHUKkFVfJeWP95v/5evvNqbNXArL1xXhJ0Se/nYZQ8YY0Pc
	 bEdmhcFsvqQgZKVf92ah+q4HvJhvzal3Y2C8Le6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Xi <xiqi2@huawei.com>,
	kernel test robot <lkp@intel.com>,
	Baoquan He <bhe@redhat.com>,
	Dave Young <dyoung@redhat.com>,
	Michael Holzheu <holzheu@linux.vnet.ibm.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 60/76] fs/proc: fix compile warning about variable vmcore_mmap_ops
Date: Tue, 12 Nov 2024 11:21:25 +0100
Message-ID: <20241112101842.065332238@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

From: Qi Xi <xiqi2@huawei.com>

commit b8ee299855f08539e04d6c1a6acb3dc9e5423c00 upstream.

When build with !CONFIG_MMU, the variable 'vmcore_mmap_ops'
is defined but not used:

>> fs/proc/vmcore.c:458:42: warning: unused variable 'vmcore_mmap_ops'
     458 | static const struct vm_operations_struct vmcore_mmap_ops = {

Fix this by only defining it when CONFIG_MMU is enabled.

Link: https://lkml.kernel.org/r/20241101034803.9298-1-xiqi2@huawei.com
Fixes: 9cb218131de1 ("vmcore: introduce remap_oldmem_pfn_range()")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/lkml/202410301936.GcE8yUos-lkp@intel.com/
Cc: Baoquan He <bhe@redhat.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Wang ShaoBo <bobo.shaobowang@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/proc/vmcore.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -446,10 +446,6 @@ static vm_fault_t mmap_vmcore_fault(stru
 #endif
 }
 
-static const struct vm_operations_struct vmcore_mmap_ops = {
-	.fault = mmap_vmcore_fault,
-};
-
 /**
  * vmcore_alloc_buf - allocate buffer in vmalloc memory
  * @sizez: size of buffer
@@ -477,6 +473,11 @@ static inline char *vmcore_alloc_buf(siz
  * virtually contiguous user-space in ELF layout.
  */
 #ifdef CONFIG_MMU
+
+static const struct vm_operations_struct vmcore_mmap_ops = {
+	.fault = mmap_vmcore_fault,
+};
+
 /*
  * remap_oldmem_pfn_checked - do remap_oldmem_pfn_range replacing all pages
  * reported as not being ram with the zero page.


