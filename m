Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB7A187FE8;
	Fri, 15 Nov 2024 06:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652845; cv=none; b=DEsd4ZVZ6hUwrcAjv9kIO7jGg0/hlf5oUeQqYHrO8uNstLbhTmjpeh60/FD6HYVrlaN8FqUcU48eY5pWx/lAObujB/+E39wuKWLHV+jwShFsRt/4cFJBfM1nVAIH4QRl5kmngK6UbvZ0HqY0UR7zGRz5WaeoxhxkFHAiE19RZBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652845; c=relaxed/simple;
	bh=SAFYGPtrnWTNg/d4tl+Y0Wzo6Pvz6yV4HvWOY8zYVP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiOGPmN2VXWy6XrHmt5CAdVtTgzAZu8W8CsqB1bTXAgMYw2ctPcCJIbWIJovZX/DpgqF9BiWoC+C2gjyDPN6IZ1j+9PtB70BMJsu4+PF5FyvX3IIxbSGyjakovKvhhRuDxVou+susrT9B7b/Aj/AZZymdZDeoGsRxW8udUfqs2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPRLrM4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPRLrM4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82F70C4CECF;
	Fri, 15 Nov 2024 06:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652845;
	bh=SAFYGPtrnWTNg/d4tl+Y0Wzo6Pvz6yV4HvWOY8zYVP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPRLrM4EpB7droFahfUSiN2MdnnZhAU658Jts1sVgzWy0lWCvGCxbJQm8127P6eEd
	 9l3dGBqChHrcZWnGbiqc3a6JHFkh5j+ZOETCW6xCQ/ujtIzF+zlDzydnVT0BjqtZJJ
	 dR/xxBW4PgKjcHxLDJIXYls3Y/tiWzEq250BC3OU=
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
Subject: [PATCH 4.19 30/52] fs/proc: fix compile warning about variable vmcore_mmap_ops
Date: Fri, 15 Nov 2024 07:37:43 +0100
Message-ID: <20241115063723.946739262@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -431,10 +431,6 @@ static vm_fault_t mmap_vmcore_fault(stru
 #endif
 }
 
-static const struct vm_operations_struct vmcore_mmap_ops = {
-	.fault = mmap_vmcore_fault,
-};
-
 /**
  * vmcore_alloc_buf - allocate buffer in vmalloc memory
  * @sizez: size of buffer
@@ -462,6 +458,11 @@ static inline char *vmcore_alloc_buf(siz
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


