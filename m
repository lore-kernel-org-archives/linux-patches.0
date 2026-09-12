Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B16436728D;
	Sat, 12 Sep 2026 09:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205118; cv=none; b=UXGqWJTPRDbJywUrLWDLXge8QlR3dwAEO0C6Xa1rdiXHytlNTUEJI7EVvIEXCtndP1FhdqKJwl+nh9u3g3SWgSJDKVZpKCaKr78Sr2MvA49lwPRMgMEQL3JuYZU2wo9WYluTFYdh2/35QbX2DXlggPdGc+bUEShZxetcIdDHsq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205118; c=relaxed/simple;
	bh=WLFFtna0QtPgdWS0nZ0v6rGy7pGC1Lo1QkfycD51Bao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8zhMzYBPfOss0XnuEicv4n6Yaidzl6t72jwusU3bIrsHm7S3VdvRpqTcOM4y/RLOHtf65Klb/irenTWfWPc+N/iEZf7N0Urfa1dXyyaT+u/9NyD3uWRkQvIE8pgGUvOhyX5RB3AegKmr2MK/pa2Nt7z0GbW7P0MGEVucnbFU4U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztlfOZlL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztlfOZlL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 064181F00893;
	Sat, 12 Sep 2026 09:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205117;
	bh=Iti/Lwk23mrJqjOAEvdEmBNFwkSzjduR0Zot9PRqJDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztlfOZlLsIqKttUddP8rU3NdNGmsY/VDlFe5Widk/eYDtrwASS8MAwsEAAb1GNy5/
	 Yvpbd1i6mlyMuCpmqulfRXKrI6xqWdKVmChb4PcE8csVkiC91y1euEow9g54nBq5GQ
	 5GerVTBfUNJKJinfCU+XTVoxNfRJA32ZklGJXwV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Liam R. Howlett (Oracle)" <liam@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Breno Leitao <leitao@debian.org>,
	Chris Mason <clm@meta.com>,
	Chuck Lever <cel@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joe Perches <joe@perches.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Rik van Riel <riel@surriel.com>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1753/1815] maple_tree: fix argument name in header
Date: Sat, 12 Sep 2026 08:58:23 +0200
Message-ID: <20260912065730.139811679@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liam R. Howlett (Oracle) <liam@infradead.org>

[ Upstream commit 00f67814a14e614b749ebe54076ef1e3e6454f2b ]

The mas_prev_range() function takes a min and not a max.

Link: https://lore.kernel.org/20260821192627.4085470-18-liam@infradead.org
Fixes: 6b9e93e01020 ("maple_tree: add mas_prev_range() and mas_find_range_rev interface")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/maple_tree.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 4a5631906affb..0d712e7be6ddc 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -572,7 +572,7 @@ void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
-void *mas_prev_range(struct ma_state *mas, unsigned long max);
+void *mas_prev_range(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
-- 
2.53.0



