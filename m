Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC23B1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 890B5C340EC;
	Fri, 25 Mar 2022 01:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170539;
	bh=yw1DW+lj7FnHU3XwYB8liAvrrWoB3RD4bYCIH3LCLY0=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=RbZjq2dtPNRrWHjd0wu78flXBZp9TMgJ9k2S17itPhiXj/AhPlSws7/x4nKZPV901
	 /ii7LVkm82n2htOUmXA85ZmJHPeVD8YRLBucDTjZpoTYJJ3aDqOExWOiWWIUbpRe+D
	 RzDdyuNlHiP+drG50eDaRFeEqSD7l5IzetGiL8kI=
Date: Thu, 24 Mar 2022 18:08:59 -0700
To: corbet@lwn.net,skhan@linuxfoundation.org,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 008/114] Documentation/vm/page_owner.rst: fix unexpected indentation warns
Message-Id: <20220325010859.890B5C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Shuah Khan <skhan@linuxfoundation.org>
Subject: Documentation/vm/page_owner.rst: fix unexpected indentation warns

Fix Unexpected indentation warns in page_owner:

Documentation/vm/page_owner.rst:92: WARNING: Unexpected indentation.
Documentation/vm/page_owner.rst:96: WARNING: Unexpected indentation.
Documentation/vm/page_owner.rst:107: WARNING: Unexpected indentation.

Link: https://lkml.kernel.org/r/20211215001929.47866-1-skhan@linuxfoundation.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/vm/page_owner.rst~docs-vm-fix-unexpected-indentation-warns-in-page_owner
+++ a/Documentation/vm/page_owner.rst
@@ -89,11 +89,11 @@ Usage
 
 	Page allocated via order XXX, ...
 	PFN XXX ...
-	 // Detailed stack
+	// Detailed stack
 
 	Page allocated via order XXX, ...
 	PFN XXX ...
-	 // Detailed stack
+	// Detailed stack
 
    The ``page_owner_sort`` tool ignores ``PFN`` rows, puts the remaining rows
    in buf, uses regexp to extract the page order value, counts the times
@@ -104,7 +104,7 @@ Usage
 
 	XXX times, XXX pages:
 	Page allocated via order XXX, ...
-	 // Detailed stack
+	// Detailed stack
 
    By default, ``page_owner_sort`` is sorted according to the times of buf.
    If you want to sort by the page nums of buf, use the ``-m`` parameter.
_
