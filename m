Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6CF6AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11168C340E8;
	Wed, 23 Mar 2022 23:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076736;
	bh=EWf/JA9q+bf+8thitxZGoc9ImQ460I+csfS/3/cvfmo=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=UpR9VH4x3Xa5I7MS72ar7Ds+QYlpwHiqUOO55H680R5V2SmT0sHO2WQV/Ec42PbEh
	 9S5wZLZxCsvO3OzBZIfAvvvFS1yf8PkfIobho7Kz3F7vuGULDb2lMGPAVe6vM0kq4b
	 e/zVrGNrZwX8J+5bAjp2calItDZriJJcqTM4XCaE=
Date: Wed, 23 Mar 2022 16:05:35 -0700
To: gregkh@linuxfoundation.org,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 06/41] kernel/ksysfs.c: use helper macro __ATTR_RW
Message-Id: <20220323230536.11168C340E8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: kernel/ksysfs.c: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define kobj_attribute to make code more
clear.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220222112034.48298-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ksysfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/kernel/ksysfs.c~kernel-ksysfsc-use-helper-macro-__attr_rw
+++ a/kernel/ksysfs.c
@@ -24,8 +24,7 @@
 static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 
 #define KERNEL_ATTR_RW(_name) \
-static struct kobj_attribute _name##_attr = \
-	__ATTR(_name, 0644, _name##_show, _name##_store)
+static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
 
 /* current uevent sequence number */
 static ssize_t uevent_seqnum_show(struct kobject *kobj,
_
