Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2851E0B62;
	Wed,  6 Nov 2024 12:47:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897226; cv=none; b=OOeUUVbC9O9BxsAZuuT7lUaUrpedcqlxDrHAikKKrj0y5wLhc5BI9o/h2ai9YZYmSo4hKFEbmB+Ha1kBqpNIAv8/Z00GcBenEsJsx3x3wB7QmZDK2hLjILjwlIcrQcyue7PI56cnDtPxjFV3NMvAzFfiMBrhhdAiaxtOQLerwzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897226; c=relaxed/simple;
	bh=RCmOhtKcPihiedxV5ucOjwBY0FjiuDxEcYeWpgtg8EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=js9UFUe91qj2L1HMUD08sIVO9y9ZY3y+b47HdjWbVvE+KpDsJoCBxlI7saTxtO1n7Bl8NavVbgXjs0pHbE8PeAcmmVYgjh+8meJM6hwgrysvjNiQWz/NLlfpI8C/zHD49Ge7VvBTeVF819JPBlk/S5/yAG/ebRdZnCykH/7bUiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1tG9+Zl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1tG9+Zl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FA0C4CECD;
	Wed,  6 Nov 2024 12:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897226;
	bh=RCmOhtKcPihiedxV5ucOjwBY0FjiuDxEcYeWpgtg8EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1tG9+Zl215PH7lzKg2zEiWY+nJFtIlMYegX31kKndjkoaM2EAOqCQjspJVtBXE7c
	 sqv5t6joBtLIeiI+BxQlu/KASwtHzhipFNR1tTSFYnt0bsiGkv7rHLGBG9odbSvJzD
	 rRwwQtRsGzHCe27SE/vmfme5QESoyktn56sJBJf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Li <yang.lee@linux.alibaba.com>,
	Abaci Robot <abaci@linux.alibaba.com>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 108/126] mm/migrate.c: stop using 0 as NULL pointer
Date: Wed,  6 Nov 2024 13:05:09 +0100
Message-ID: <20241106120308.978630198@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Li <yang.lee@linux.alibaba.com>

[ Upstream commit 4c74b65f478dc9353780a6be17fc82f1b06cea80 ]

mm/migrate.c:1198:24: warning: Using plain integer as NULL pointer

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3080
Link: https://lkml.kernel.org/r/20221116012345.84870-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 35e41024c4c2 ("vmscan,migrate: fix page count imbalance on node stats when demoting pages")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 562f819dc6189..81444abf54dba 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1192,7 +1192,7 @@ static int unmap_and_move(new_page_t get_new_page,
 		return -ENOMEM;
 	dst = page_folio(newpage);
 
-	dst->private = 0;
+	dst->private = NULL;
 	rc = __unmap_and_move(src, dst, force, mode);
 	if (rc == MIGRATEPAGE_SUCCESS)
 		set_page_owner_migrate_reason(&dst->page, reason);
-- 
2.43.0



