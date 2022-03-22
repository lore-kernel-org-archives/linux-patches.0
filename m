Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE6B6465
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:46:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9103FC340EC;
	Tue, 22 Mar 2022 21:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985596;
	bh=2ar7RtaI2P01CapefEmmSPNXxQF5PPXBY9ag+WtVuNo=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=tj0T7Qgt7Yo1td1FvuFpRQwoEj2rCVgKNzdfd2FjrAqD35S1Y6NOnI2EDk5wo5c4j
	 5zKTWg8/HAftsKaciY9PfPx4WuUhMRo4T7mHG5qeTzBLApTvATOzHSJzQMfH+mVV1T
	 Z4cMgWDuj2lFvUCWi8939WO6FGI563s2gJli35u0=
Date: Tue, 22 Mar 2022 14:46:35 -0700
To: linmiaohe@huawei.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 159/227] mm/ksm: use helper macro __ATTR_RW
Message-Id: <20220322214636.9103FC340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/ksm: use helper macro __ATTR_RW

Use helper macro __ATTR_RW to define KSM_ATTR to make code more clear. 
Minor readability improvement.

Link: https://lkml.kernel.org/r/20220221115809.26381-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/ksm.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/ksm.c~mm-ksm-use-helper-macro-__attr_rw
+++ a/mm/ksm.c
@@ -2829,8 +2829,7 @@ static void wait_while_offlining(void)
 #define KSM_ATTR_RO(_name) \
 	static struct kobj_attribute _name##_attr = __ATTR_RO(_name)
 #define KSM_ATTR(_name) \
-	static struct kobj_attribute _name##_attr = \
-		__ATTR(_name, 0644, _name##_show, _name##_store)
+	static struct kobj_attribute _name##_attr = __ATTR_RW(_name)
 
 static ssize_t sleep_millisecs_show(struct kobject *kobj,
 				    struct kobj_attribute *attr, char *buf)
_
