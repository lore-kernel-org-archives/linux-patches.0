Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C4239FD4;
	Fri, 24 Nov 2023 18:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QxRoEQFj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F120C433C9;
	Fri, 24 Nov 2023 18:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849698;
	bh=/n4xJStHCp7ILc2lxBA5tOXrrk5JoIfCbnrWUU616XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QxRoEQFju6llGEkGWSIeuyyfOzadhNl/+wvzTDqedDb2/9g72v4dKADuqftv9M/qQ
	 PoD9cmjZVJZCglsoZ+a3ARYZcfImt8dnyvGCKJA3VhD/NHJ5bPoSLSV/i9XgMyInko
	 8FV0mmQq1tv5zyK8UDLhEon3GJRJb/NdpKnIJDrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyeongtak Ji <hyeongtak.ji@sk.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 285/530] mm/damon/core.c: avoid unintentional filtering out of schemes
Date: Fri, 24 Nov 2023 17:47:31 +0000
Message-ID: <20231124172036.719482256@linuxfoundation.org>
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

From: Hyeongtak Ji <hyeongtak.ji@sk.com>

commit 13b2a4b22e98ff80b888a160a2acd92d81b05925 upstream.

The function '__damos_filter_out()' causes DAMON to always filter out
schemes whose filter type is anon or memcg if its matching value is set
to false.

This commit addresses the issue by ensuring that '__damos_filter_out()'
no longer applies to filters whose type is 'anon' or 'memcg'.

Link: https://lkml.kernel.org/r/1699594629-3816-1-git-send-email-hyeongtak.ji@gmail.com
Fixes: ab9bda001b681 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: Hyeongtak Ji <hyeongtak.ji@sk.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -914,7 +914,7 @@ static bool __damos_filter_out(struct da
 		matched = true;
 		break;
 	default:
-		break;
+		return false;
 	}
 
 	return matched == filter->matching;


