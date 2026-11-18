Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018868;
	b=DLJ14cqv19Jc9qif62JyYBpTMxB0Xcbuyr/iEE63GtQDlXSoUh8zpnXsXv3bxd4K+dOz
	 Awy38WtjW/VZjUxSSt56P7rIteHNNzwCnAZ4xHnt1BHRzYjZ9zg2QYR+Pkzb+pC6946yL
	 tEeAbQ3j1JMZ9pt1OSLSfJBEQa/zVWOVwHnQhDwqe3tK7i+t3jVrjq5KFCQH5Wd7xTGL2
	 1xg/+1O8RwXS93XYbHzdx31PrHNiA5VQs0yY8ZORcvKZk7vjIUePoFcRJ1mhDdMr2bfVD
	 WwWVCl6ol36ArDIkIGpt5jDG8fJ4ghGgE0kpueGuRBp+EjHMlQbPJBs1Iuaddzo1rtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018868;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gQowqzhQWo66oi6XbOVaAUwmumK5A4dIH7b1HxjXzB8=;
	b=H6lT7Nq8NjfR9Lk57SnIbDJ7web0bXoKzcq2iFheqzwJte1cXW4IjCYPNSlKNF/WrXuf
	 CSEfol6V6BAHLFyH9LASFMcN7G2NYv73G4fsfp0wpVUbErPNo0Z6V7vGem0Azyg+vmi3R
	 TJXFjlTmdrmCefYiPW6QuUVK/84IRbShO6RpZEw0WwrJ4K+JrEp/glIlQ+fQKCCgD3rjD
	 1okHeN2C5IsaGl8uidj/1CSdnTwauG/MGezpErdm9OjgRLF3e/e6YllFawzGkATJw8JvN
	 ObOP3Zgz5ITeTyspISsbUJmPHa0blXNvJsspHUV+vV5iKBLd5vyDqbC3rZzchO4cRWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9gkJu25;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56451606A325;
	Wed, 18 Nov 2026 16:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t9gkJu25
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCFF1F000C4;
	Wed, 18 Nov 2026 16:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018868;
	bh=gQowqzhQWo66oi6XbOVaAUwmumK5A4dIH7b1HxjXzB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t9gkJu25xdA9UTFnWjUWPVx+vJAHB/SHkFsVYjp8mkEN78ge+3cfgIT1Ye0PcR4pa
	 Dmk3fkw5kfXnlLi+k30RBWmMSOIF0iOph0TOu+3hXgKhdeP36gfbAmztbh+EIXL8Ny
	 IxcwIVn8GcKnPjHS1egK1eI2//0Ic7uYy3f53epQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wilson Felipe Pereira <wfelipe@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1391/2651] selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass
Date: Wed, 18 Nov 2026 15:43:51 +0100
Message-ID: <20261118150338.095902389@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wilson Felipe Pereira <wfelipe@google.com>

[ Upstream commit 0567c7eaefd7ea1b26d76c46964f9a1d92120d7d ]

In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
checked against stored_pages * page_size / 4 to verify that the pages
pushed to zswap belong to the test memory cgroup.

Due to slight stat update timing differences, delta can evaluate to a
small negative number (e.g.  -5MB out of 1GB).  Because delta is declared
as a signed int and stored_pages is an unsigned size_t, C's usual
arithmetic conversions implicitly promote a negative delta to a large
unsigned 64-bit integer, causing `delta < stored_pages * page_size / 4` to
falsely evaluate to 0 and fail the test.

Fix this by declaring zswapped and delta as signed long long and comparing
against a signed threshold, ensuring negative deltas correctly evaluate to
true.

Link: https://lore.kernel.org/20260828033741.2184560-3-wfelipe@google.com
Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem bypass test")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Koutný <mkoutny@suse.com>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 8df54b59513a8..4e943e3d90adf 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -652,11 +652,14 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			int zswapped = cg_read_key_long(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * page_size - zswapped;
-			int result_ok = delta < stored_pages * page_size / 4;
-
-			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
+			long zswapped = cg_read_key_long(
+				test_group, "memory.stat", "zswapped ");
+			long long delta =
+				(long long)stored_pages * page_size - zswapped;
+			long long max_delta =
+				(long long)stored_pages * page_size / 4;
+
+			ret = (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;
 			break;
 		}
 	}
-- 
2.53.0



