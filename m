Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590128;
	b=twCJKFV5FXwd+XK5loyWNmAH8HmT7DIZZcpkohfy1AQeJZNuK0zQ4ewySTN0ET/hro3Q
	 DQaa+8i8sydfAx+MznqFmJWOLoXY+cTc6Uk5vO/TcSQ7AJwLraAWH+7kdb+mwKoyAbbws
	 UjUhr9s388N9xHG0k04LxHME2RNtvUh3kqwKI9GBSBJXxaS+coU90MtLZstVVP9iTu3Qi
	 HND+p42VbyyErD1Pn7+jLBeKYrqIj9+zBVFujlgu8SQeF6Fm4aMu1IqlrvUATHQnSCQ6b
	 PtxPGna0iNc0K6tFIW7hB//A2ISBbrsxKgLnVEa0WIsU8KpXTvG5L7xZTBGhhQjDWwQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5rC0fjgp/nGnBEw6SVBqnUEm6hnjVuTL1YKuGyI3eH0=;
	b=4pGkB8oOsVN7gFnT/tYlLaWU3+hFm03dOxtGzEgtyF67uJxa2FExejcB8AXOMdeqjvT0
	 oHdTjrdIrDv/trnzGq8fZQScPmtUVVeMWX9it2a5vac/y/OezoSQB3xVKBC8C9H+UKUqr
	 VRHFaVM18T8EWz2ZsNJzT9l/TUpuNiRPHxRPRD97gi5RZwGxu6jFmC1/ZZPzYWlstP/2E
	 eefLRCeg+v20z1CGXCNd6FLN/04+3sn7MwP7qHiv9o2C5gzIS8BPk7I+q7xlj7FFxFSyp
	 BqgaxESbfevebFZlIfe4aeBDbA3PWCHXNElhgio1JeNlTvoHqSLiPUXxYuvr0grN/YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=at5NbLDW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C108606B23B;
	Fri, 13 Nov 2026 17:15:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=at5NbLDW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38171F000C9;
	Fri, 13 Nov 2026 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590127;
	bh=5rC0fjgp/nGnBEw6SVBqnUEm6hnjVuTL1YKuGyI3eH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=at5NbLDWCRzaGl10QHLN2n2WAxKgZWTTWCvhXJIj+Q4JReqqsGOdx07UTj/EqaXpA
	 1hg2RDxcBxtEyjNvLl5OsYWTwWPctspL43v00CJqI26taoUsI2cd7EJN/SdR9PmPLh
	 0QlLqaPAnzUVqQTt67jOtdWM9grTsKFri9tzPYtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	Usama Arif <usamaarif642@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 148/686] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Fri, 13 Nov 2026 10:44:41 -0500
Message-ID: <20261113153825.817525013@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SJ Park <sj@kernel.org>

[ Upstream commit af19aff38d6faea35b10f26cca32d0e54f8aea5e ]

DAMON sysfs interface reads the user-provided size range arguments for
hugepage_size type DAMOS filter twice.  Once for validation, and once
again for assignments to the variable that will be passed to the core
layer.  If the user updates the arguments in parallel, an invalid size
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid size range is not really invalid.  It just works
as having a weird size range.  No critical issues such as a crash or a
leak could happen.  And sane users ain't do such parallel arguments update
anyway.  If they do, such racy behavior is arguably somewhat expected and
deserved.  That said, there is no reason to keep such races.

Link: https://lore.kernel.org/20260914142327.92510-3-sj@kernel.org
Fixes: ea1f204ba29a ("mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: Usama Arif <usamaarif642@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index e95cddca0a10d..952e12fd6dbf7 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2493,12 +2493,11 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->sz_range.min >
-					sysfs_filter->sz_range.max) {
+			filter->sz_range = sysfs_filter->sz_range;
+			if (filter->sz_range.min > filter->sz_range.max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range = sysfs_filter->sz_range;
 		}
 
 		damos_add_filter(scheme, filter);
-- 
2.53.0



