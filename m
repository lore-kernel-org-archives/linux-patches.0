Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83FB5367F
	for <patches@lists.linux.dev>; Sat, 26 Feb 2022 03:11:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50752C340F1;
	Sat, 26 Feb 2022 03:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1645845081;
	bh=TpqGmpDe388CnUnPRivcHgWWsh5Jjhc4XanNCmHWYso=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=jg/7R5ZdNnfP52BcrIsBfcUm0xNAj+AW06YF4qV/x/m69qmEfwJHuagJJ6sXMi901
	 pS5k0etZfGqz1ug7iBO6ttYIgnA3dWsOlHBNEo7T3aMFExHkynRPf+lCqyDkqhWBHH
	 zhhgKm8LcOEcpVPdiepE/VmH9ljXxX10ZT5DDRJI=
Date: Fri, 25 Feb 2022 19:11:20 -0800
To: roman.gushchin@linux.dev,rientjes@google.com,penberg@kernel.org,iamjoonsoo.kim@lge.com,cl@linux.com,vbabka@suse.cz,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220225191021.f71538a3f43dc448110e88b6@linux-foundation.org>
Subject: [patch 10/12] MAINTAINERS, SLAB: add Roman as reviewer, git tree
Message-Id: <20220226031121.50752C340F1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Vlastimil Babka <vbabka@suse.cz>
Subject: MAINTAINERS, SLAB: add Roman as reviewer, git tree

The slab code has an overlap with kmem accounting, where Roman has done a
lot of work recently and it would be useful to make sure he's CC'd on
patches that potentially affect it.  Thus add him as a reviewer for the
SLAB subsystem.

Also while at it, add the link to slab git tree.

Link: https://lkml.kernel.org/r/20220222103104.13241-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-slab-add-roman-as-reviewer-git-tree
+++ a/MAINTAINERS
@@ -17762,8 +17762,10 @@ M:	David Rientjes <rientjes@google.com>
 M:	Joonsoo Kim <iamjoonsoo.kim@lge.com>
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	Vlastimil Babka <vbabka@suse.cz>
+R:	Roman Gushchin <roman.gushchin@linux.dev>
 L:	linux-mm@kvack.org
 S:	Maintained
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git
 F:	include/linux/sl?b*.h
 F:	mm/sl?b*
 
_
