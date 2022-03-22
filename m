Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8066453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08273C340EC;
	Tue, 22 Mar 2022 21:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985554;
	bh=rkVyZCLtKId1gqM4EKvVgPOCeh/3NOaqkpucbTzplJU=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=pR2xMY8NY5adcB2gvwwTAHHq0TKoaWsUe6151vAC62IoBZMrlAfjhkg6UKmE4uufO
	 s3miP1zLFP73kMYmLrUcJb9qaOAsnDjBfYZ1m/thBtzeAW02k1ZyuoZvRP+MzpuIGY
	 kI4So82P/ZAugJuzFNjW2kuW6ZwTw22/FptLHeKo=
Date: Tue, 22 Mar 2022 14:45:53 -0700
To: vbabka@suse.cz,mhocko@suse.com,iamjoonsoo.kim@lge.com,hannes@cmpxchg.org,quic_charante@quicinc.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 145/227] mm: vmscan: fix documentation for page_check_references()
Message-Id: <20220322214554.08273C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Charan Teja Kalla <quic_charante@quicinc.com>
Subject: mm: vmscan: fix documentation for page_check_references()

commit b518154e59aa ("mm/vmscan: protect the workingset on anonymous LRU")
requires to look twice for both mapped anon/file pages are used more than
once to take the decission of reclaim or activation.  Correct the
documentation accordingly.

Link: https://lkml.kernel.org/r/1646925640-21324-1-git-send-email-quic_charante@quicinc.com
Signed-off-by: Charan Teja Kalla <quic_charante@quicinc.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmscan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/vmscan.c~mm-vmscan-fix-documentation-for-page_check_references
+++ a/mm/vmscan.c
@@ -1385,7 +1385,7 @@ static enum page_references page_check_r
 		/*
 		 * All mapped pages start out with page table
 		 * references from the instantiating fault, so we need
-		 * to look twice if a mapped file page is used more
+		 * to look twice if a mapped file/anon page is used more
 		 * than once.
 		 *
 		 * Mark it and spare it for another trip around the
_
