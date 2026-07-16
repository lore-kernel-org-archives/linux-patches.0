Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 831073D522F;
	Thu, 16 Jul 2026 13:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210060; cv=none; b=WIN7eL5R1rWJ6IkzvxP4FLfZtnGbGuma1uNHf6X4eblTU1FXmIt81Nr59K+RaGmQXXVsVm9gt9a80/bf2249IN49sm6I2zAG3Oc3dMGhnwqZCF/Twgg3H1L6HOuKxXQmEeTBKJbJ1LYKUHMq6ef/wCpAoF+fs+ylNN6Ue3uENXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210060; c=relaxed/simple;
	bh=7ADOZSK+GzyhqYwUUA5/0poyFumC6rne1hu0HJfHnwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OxA0hSEaiG/ZEgLHRJt5sVxwXbHK5mI8j9C3lsDO5jaMRyMw0diEzTOrhTL68UH28C9pywMoh5wMR4JOXfJgSNqJnniYthd1aOo4Q46ZaA0pB8B2nenUtlnxFOSS26x1gX5sw6ZUCz4dVf6EYln0zFnLPP2S/5Zju/1DbTiAMqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=njKRC349; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="njKRC349"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8AB71F00A3D;
	Thu, 16 Jul 2026 13:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210059;
	bh=zwoFWPqM6ln06pg2SuVlWnhsPUPwR5L2HC2yVbjK/rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njKRC349rZUUlqWYTnBjQSFOOaGj2NSz54kdlFnVAc9Te/Iv9S4/rE6JFjXhcfINm
	 r7FmYwxNY5dQoC+UmNmnov3OqAaSNLRHtO70kqd2M6B0YBySs2xKHH/4A2CSk2I5i4
	 UTyd8ea7CiVLEJzaIonnrAKWCKc/rlcUb+OfQuNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Ge <hao.ge@linux.dev>,
	Balbir Singh <balbirs@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 7.1 422/518] lib/test_hmm: use kvfree() to free kvcalloc() allocations
Date: Thu, 16 Jul 2026 15:31:30 +0200
Message-ID: <20260716133057.072527832@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Ge <hao.ge@linux.dev>

commit 59f19bf6f119eecfa16355186b593abba8eb5198 upstream.

Coccinelle scripts/coccinelle/api/kfree_mismatch.cocci reports
the following warnings:

  lib/test_hmm.c:1256:15-16: WARNING kvmalloc is used to allocate this memory at line 1191
  lib/test_hmm.c:1257:15-16: WARNING kvmalloc is used to allocate this memory at line 1196

Fix this by replacing kfree() with kvfree() to correctly handle the
vmalloc() fallback path of kvcalloc().

Link: https://lore.kernel.org/20260513082525.154036-1-hao.ge@linux.dev
Fixes: 775465fd26a3 ("lib/test_hmm: add zone device private THP test infrastructure")
Signed-off-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Balbir Singh <balbirs@nvidia.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/test_hmm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..38996c4baa40 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1253,8 +1253,8 @@ static int dmirror_migrate_to_device(struct dmirror *dmirror,
 	mmap_read_unlock(mm);
 	mmput(mm);
 free_mem:
-	kfree(src_pfns);
-	kfree(dst_pfns);
+	kvfree(src_pfns);
+	kvfree(dst_pfns);
 	return ret;
 }
 
-- 
2.55.0



