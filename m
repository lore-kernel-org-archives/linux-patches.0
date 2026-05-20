Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DB33EDACC;
	Wed, 20 May 2026 16:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295386; cv=none; b=RGFGTbzv6PZD7ablEORsDhSU4qBkPSAiLbt1S36LM6Io2kAkmfmdDvYCiRPJG/E2End/tIw385iWHoxMYwvGHtUToqAurRIoDpFpPuDX0KhHyMgbJEyQ9JdrzeInxVc0eLo69DXb0RQVLkxD3okmY+7c2PjMm4oSol6/D+Gz04U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295386; c=relaxed/simple;
	bh=XzAGIkn1SvUIFHBU1zGqxnzjpY66Ao9O9bCviukkfJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ks4dJKkg1ZsB7zm3oZTZQ46nZUbssmA2JmTlk8ft/j26P4oMrDg84ENLa4zvn75LVW2yRnT5Iy7cetVc/diDFIPNoEq42PnDqJXTqcvodguKy9TiAkPgWpoIKAQQI6Oc5atr8WkRgQtq6UVPfJteKc/twKPof6y8x8mL1zW0F1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gKJzTfiK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gKJzTfiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766A51F000E9;
	Wed, 20 May 2026 16:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295385;
	bh=CzA0wYNShvyOsHIs64oITrH4tvl/+T8cKfjT8b6R7iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKJzTfiKZkkWthR3m2q20fBd6c9r4/axVMEIaJDWtLWgzu2sFH+N+EECsrAx98L40
	 CuHnO84k3/y+7p60BeAfN6ruah7bBGDOg3+H7j1TtnMK9wIa1eU032pPQ34jG78pBB
	 gdWrRwuSZLyB7Q66QGZN8ZCaEfuhzmBkPltQkV7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	wang lian <lianux.mm@gmail.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0400/1146] Docs/admin-guide/mm/damn/lru_sort: fix intervals autotune parameter name
Date: Wed, 20 May 2026 18:10:50 +0200
Message-ID: <20260520162157.253874966@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: SeongJae Park <sj@kernel.org>

[ Upstream commit d7f00084f6863a243b396200c81e83ae302c5a76 ]

The section name should be the same as the parameter name.  Fix it.

Link: https://lkml.kernel.org/r/20260307195356.203753-6-sj@kernel.org
Fixes: ed581147a417 ("Docs/admin-guide/mm/damon/lru_sort: document intervals autotuning")
Signed-off-by: SeongJae Park <sj@kernel.org>
Acked-by: wang lian <lianux.mm@gmail.com>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/mm/damon/lru_sort.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/lru_sort.rst b/Documentation/admin-guide/mm/damon/lru_sort.rst
index 63977a89025e5..5f38910c0ba7e 100644
--- a/Documentation/admin-guide/mm/damon/lru_sort.rst
+++ b/Documentation/admin-guide/mm/damon/lru_sort.rst
@@ -95,8 +95,8 @@ increases and decreases the effective level of the quota aiming the LRU
 
 Disabled by default.
 
-Auto-tune monitoring intervals
-------------------------------
+autotune_monitoring_intervals
+-----------------------------
 
 If this parameter is set as ``Y``, DAMON_LRU_SORT automatically tunes DAMON's
 sampling and aggregation intervals.  The auto-tuning aims to capture meaningful
-- 
2.53.0



