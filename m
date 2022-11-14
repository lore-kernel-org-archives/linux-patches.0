Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1233D4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 13:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCB6C433D6;
	Mon, 14 Nov 2022 13:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668431253;
	bh=OPh17+63pU4oLwr+vtfQ/uTMTgRb7sCEwkU5bQzsd1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wwTBRL4ghaexVBJFkICFnwfMAAmDLxMcgbZ+qzGlmZzbeb14G5RdQ/dxSZtEFiBcv
	 eBhq8BR8pOPRWAT/5u6/qFdK9iME/l0ZGeREGZFps0NB8B8/aAcwIzEH1HxzNM5Otp
	 eDma7WjKjW5/eMWizOcbndh4ArmT607SWcst7mBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Gorbik <gor@linux.ibm.com>,
	kernel test robot <lkp@intel.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.0 157/190] mm: hugetlb_vmemmap: include missing linux/moduleparam.h
Date: Mon, 14 Nov 2022 13:46:21 +0100
Message-Id: <20221114124505.678809529@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vasily Gorbik <gor@linux.ibm.com>

commit db5e8d84319bcdb51e1d3cfa42b410291d6d1cfa upstream.

The kernel test robot reported build failures with a 'randconfig' on s390:
>> mm/hugetlb_vmemmap.c:421:11: error: a function declaration without a
prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
   core_param(hugetlb_free_vmemmap, vmemmap_optimize_enabled, bool, 0);
             ^

Link: https://lore.kernel.org/linux-mm/202210300751.rG3UDsuc-lkp@intel.com/
Link: https://lkml.kernel.org/r/patch.git-296b83ca939b.your-ad-here.call-01667411912-ext-5073@work.hours
Fixes: 30152245c63b ("mm: hugetlb_vmemmap: replace early_param() with core_param()")
Signed-off-by: Vasily Gorbik <gor@linux.ibm.com>
Reported-by: kernel test robot <lkp@intel.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb_vmemmap.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -11,6 +11,7 @@
 #define pr_fmt(fmt)	"HugeTLB: " fmt
 
 #include <linux/pgtable.h>
+#include <linux/moduleparam.h>
 #include <linux/bootmem_info.h>
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>


