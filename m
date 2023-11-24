Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBB339FC3;
	Fri, 24 Nov 2023 18:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wCwVnGOq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3CBC433C7;
	Fri, 24 Nov 2023 18:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849696;
	bh=ylzRVHGDCoH3+0vht5bjvfxp1i5C38PPhd+ZMwOapR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCwVnGOqygwpAmrsSBtQgyAnXXkld35Dsq0kurKyyJeUnDmk1c8nCE02AidVbrU+L
	 NEisvMDyvfRnvKCGVVrJ8BwixPMW5SOwkG/7uKSnQ6j2hD4EZHtf8TjhoI1ZVPaMzK
	 F2SZd4iKrJLG9kbA9ItZbDuzcj4rXwNfoWEXTWcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 284/530] mm/damon/sysfs-schemes: handle tried regions sysfs directory allocation failure
Date: Fri, 24 Nov 2023 17:47:30 +0000
Message-ID: <20231124172036.687043776@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

commit 84055688b6bc075c92a88e2d6c3ad26ab93919f9 upstream.

DAMOS tried regions sysfs directory allocation function
(damon_sysfs_scheme_regions_alloc()) is not handling the memory allocation
failure.  In the case, the code will dereference NULL pointer.  Handle the
failure to avoid such invalid access.

Link: https://lkml.kernel.org/r/20231106233408.51159-3-sj@kernel.org
Fixes: 9277d0367ba1 ("mm/damon/sysfs-schemes: implement scheme region directory")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.2+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/sysfs-schemes.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -126,6 +126,9 @@ damon_sysfs_scheme_regions_alloc(void)
 	struct damon_sysfs_scheme_regions *regions = kmalloc(sizeof(*regions),
 			GFP_KERNEL);
 
+	if (!regions)
+		return NULL;
+
 	regions->kobj = (struct kobject){};
 	INIT_LIST_HEAD(&regions->regions_list);
 	regions->nr_regions = 0;


