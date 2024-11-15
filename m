Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E24429A9;
	Fri, 15 Nov 2024 06:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653132; cv=none; b=ZytWFQFr3CGK2I6gO+L3YBSfjJ8yvmO+XNrm6LaiW3QP38nbsNWNSY+er4GlA8F7vWJgOaXPQm/mEOZ25IYQA6Vb4tRo/TPAmTr2Z6vMNkohd2w4kls1ip32PlNTr6g/3RvLLcDPmWrYwDk+ghNTtzWJaHf21Lye3/AHGwpxybg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653132; c=relaxed/simple;
	bh=gLVB+4VXcIqclV/Km/6GhJLCrqgPtZalv5iRW9a760w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rR2qw1zr6wZJzmPBewbJjuaeNdSy8dcttHGAYSTPEM8e0sHOyBnvAlV0C8d7L0TzmWQHSob/zTavG68wIFS4e5fSmIa4ZCcy4jGzroiHgWWTeQ7BtcV0FvNucSVlrJjXNUFPsCUiwkAFetkl+hVy7RBdSwG9yfOykarj1+5egYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpG0NA62; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpG0NA62"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5366DC4CECF;
	Fri, 15 Nov 2024 06:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653130;
	bh=gLVB+4VXcIqclV/Km/6GhJLCrqgPtZalv5iRW9a760w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GpG0NA62dsel4V7PxUALP/+G8L7uDNBvQ7onmICpC88AA20KZJs5aSQaA4lELIbYD
	 xja4A4kgvS0FppNDdeOD/BCQLfKt9HQ1gOVobev4eWr79eWjZcTBayScdp2CWrzhSa
	 CklwZWt+UOO80Q/zNpX5K6a0pLCbAA1+CoRrkBnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chenqiwu <chenqiwu@xiaomi.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Subject: [PATCH 5.4 63/66] mm: fix ambiguous comments for better code readability
Date: Fri, 15 Nov 2024 07:38:12 +0100
Message-ID: <20241115063725.114883568@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: chenqiwu <chenqiwu@xiaomi.com>

commit 552657b7b3343851916fde7e4fd6bfb6516d2bcb upstream.

The parameter of remap_pfn_range() @pfn passed from the caller is actually
a page-frame number converted by corresponding physical address of kernel
memory, the original comment is ambiguous that may mislead the users.

Meanwhile, there is an ambiguous typo "VMM" in the comment of
vm_area_struct.  So fixing them will make the code more readable.

Signed-off-by: chenqiwu <chenqiwu@xiaomi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Link: http://lkml.kernel.org/r/1583026921-15279-1-git-send-email-qiwuchen55@gmail.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mm_types.h |    4 ++--
 mm/memory.c              |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -284,8 +284,8 @@ struct vm_userfaultfd_ctx {};
 #endif /* CONFIG_USERFAULTFD */
 
 /*
- * This struct defines a memory VMM memory area. There is one of these
- * per VM-area/task.  A VM area is any part of the process virtual memory
+ * This struct describes a virtual memory area. There is one of these
+ * per VM-area/task. A VM area is any part of the process virtual memory
  * space that has a special rule for the page-fault handlers (ie a shared
  * library, the executable area etc).
  */
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1922,7 +1922,7 @@ static inline int remap_p4d_range(struct
  * @vma: user vma to map to
  * @addr: target user address to start at
  * @pfn: page frame number of kernel physical memory address
- * @size: size of map area
+ * @size: size of mapping area
  * @prot: page protection flags for this mapping
  *
  * Note: this is only safe if the mm semaphore is held when called.


