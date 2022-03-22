Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0D56453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69587C340EC;
	Tue, 22 Mar 2022 21:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985368;
	bh=65vsjaCa7K823HTWNhYf+T6ODYlPVC1bXOGpsV6LcrY=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=CGwX50YZDJZgYNuN7CkQRueu6llexKonykLskDYIsgrceEVohXlGUyUJPxf/VqPgF
	 Jw1rQbTaxJkwTstxb66Zn4bQ11ABYjorb314NO9Q2hcZttG4UyXnZvmBnxcGiqAnJK
	 FMHXw45dCB60G7ilTkwU/2Z4xizaYrPW85hUsAzU=
Date: Tue, 22 Mar 2022 14:42:47 -0700
To: urezki@gmail.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 084/227] mm/vmalloc: remove unneeded function forward declaration
Message-Id: <20220322214248.69587C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/vmalloc: remove unneeded function forward declaration

The forward declaration for lazy_max_pages() is unnecessary.  Remove it.

Link: https://lkml.kernel.org/r/20220124133752.60663-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Uladzislau Rezki <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/vmalloc.c~mm-vmalloc-remove-unneeded-function-forward-declaration
+++ a/mm/vmalloc.c
@@ -791,7 +791,6 @@ RB_DECLARE_CALLBACKS_MAX(static, free_vm
 
 static void purge_vmap_area_lazy(void);
 static BLOCKING_NOTIFIER_HEAD(vmap_notify_list);
-static unsigned long lazy_max_pages(void);
 
 static atomic_long_t nr_vmalloc_pages;
 
_
