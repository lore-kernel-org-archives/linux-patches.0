Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A176453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B83CC340EC;
	Tue, 22 Mar 2022 21:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985205;
	bh=KKk2x1Qh9+LAcEVgwchDKX9W0sw8zLTq+JS0aVNeOxg=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=r4KU2W6OIDfP8YxqZqSkQ8QSLurC76UrkRQKj7L8F88PlEG8ANvcjMsbZQ8Oolvpv
	 KgS7YIJnQ4wAvsy7FoEESCMmmqQaVCeIvx6Ac9Z5IweQp4xld0l0KhvqdJCMdkB7QF
	 vrsMq4f6msQrXimeMG3r347fUNumRxlfnZZR7dQ8=
Date: Tue, 22 Mar 2022 14:40:04 -0700
To: hughd@google.com,linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 031/227] mm: shmem: use helper macro __ATTR_RW
Message-Id: <20220322214005.7B83CC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: shmem: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define shmem_enabled_attr to make code more
clear.  Minor readability improvement.

Link: https://lkml.kernel.org/r/20220312082252.55586-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-use-helper-macro-__attr_rw
+++ a/mm/shmem.c
@@ -3965,8 +3965,7 @@ static ssize_t shmem_enabled_store(struc
 	return count;
 }
 
-struct kobj_attribute shmem_enabled_attr =
-	__ATTR(shmem_enabled, 0644, shmem_enabled_show, shmem_enabled_store);
+struct kobj_attribute shmem_enabled_attr = __ATTR_RW(shmem_enabled);
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE && CONFIG_SYSFS */
 
 #else /* !CONFIG_SHMEM */
_
