Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23AD66477
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:48:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF59EC340EE;
	Tue, 22 Mar 2022 21:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985688;
	bh=sltB8cC+Ikzv8M3cSTK2rdMR2TH4AcUo9crEI388ltQ=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=r5hiGhskaMMxJllpAoEFguZwwiqAnukvkjtw2W41EAW3LaWtoyPjNNU95XCPCscen
	 /rc/ZDseKh5YDjywkWyd/Tbp1mgnZDtNF93BPGUk0cTjSMGk6HfrD9vIq2RixSmBYj
	 F4En94IuXTtFWXh7ABBbgWMPusLINkiLPZU9MZ+w=
Date: Tue, 22 Mar 2022 14:48:07 -0700
To: glider@google.com,elver@google.com,dvyukov@google.com,tangmeng@uniontech.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 189/227] mm/kfence: remove unnecessary CONFIG_KFENCE option
Message-Id: <20220322214807.DF59EC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: tangmeng <tangmeng@uniontech.com>
Subject: mm/kfence: remove unnecessary CONFIG_KFENCE option

In mm/Makefile has:
obj-$(CONFIG_KFENCE) += kfence/

So that we don't need 'obj-$(CONFIG_KFENCE) :=' in mm/kfence/Makefile,
delete it from mm/kfence/Makefile.

Link: https://lkml.kernel.org/r/20220221065525.21344-1-tangmeng@uniontech.com
Signed-off-by: tangmeng <tangmeng@uniontech.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kfence/Makefile~mm-kfence-remove-unnecessary-config_kfence-option
+++ a/mm/kfence/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 
-obj-$(CONFIG_KFENCE) := core.o report.o
+obj-y := core.o report.o
 
 CFLAGS_kfence_test.o := -g -fno-omit-frame-pointer -fno-optimize-sibling-calls
 obj-$(CONFIG_KFENCE_KUNIT_TEST) += kfence_test.o
_
