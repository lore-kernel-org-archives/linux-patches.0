Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025703;
	b=QacRHAGhcdvH0a7tDOsU3ARq3AiZTcT2cVFmlOmWdepblMemrpO62qQoKZpIOCt5LReb
	 hKXQC2YWictF12xrl9R8My4PZmi7+jPNSs2AdzarKfNTAad++cd0UDJUUsiAj9uvvoc9h
	 mvpS9Zuu6xmAKriBozAOwTI3C6oF6zhXngG1kQXOIpniAtNiHAeeQS5mOt4BxW00e/M+Z
	 ezdOODD5Jf6JZ8UiloY7u/jXely7tu7AHN4sVR9vj7M5A1heZBZTjTBss1iJVjjakdM7T
	 NbiClItv559dfaDunp0fWpXma7d9lczb9oyMBpBG+WI4+I8DaGERK477aVlo8wF2ZvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=EcQ5+/fJaPaj6r2kxgB86TL8nulapx7j/eyaW2Ld2sY=;
	b=XZURpIdpN8g3P+68lP5AiH2Ey04BP0DGcIdPdqZcx8cLi92uFRhU6RHVS8QQzJCof5tS
	 dbacuQN6F5q1bB9ugoXvVtsq1PUU0hmpvjB9IMbvmw1gxOScjJf21eQCGKBXGJcYEQcwp
	 JO7nY5KU29YOEd63e81W35nqtgf3kxtkRduMYICwTPOetDG5wEN7ciY1tMfinaGGa9wZk
	 s79GbPWTAjwXVSOlDieVFl8lRE1uwBvTK9f2VqIlnHWJ2mrQMcciul1A8n7gVD1kzrsZR
	 NBwL1xdpzDObaIqLhrqlOjaYCesQwfH1TC3xczwSJ698HEJDcZAaKr07n9JISjUFN1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYyR54V2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A63606A320;
	Wed, 18 Nov 2026 18:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LYyR54V2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FAD31F000C4;
	Wed, 18 Nov 2026 18:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025703;
	bh=EcQ5+/fJaPaj6r2kxgB86TL8nulapx7j/eyaW2Ld2sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LYyR54V21DxKU+dPlSjsTmh0RkpWr6FJQwSjs74Z5ifGWnjHVycob86n66k6+Wlx3
	 mEmHSQA5TYzXWT3NqjY/5JfSs0be+WoO2RkzQFI7WLFZv0i4XkOLfekDO0vbimvOWR
	 +Y2hlyJ6JdiZntaZtnqps95Z5+pYkatlO2/rg9F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Wang <li.wang@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Tejun Heo <tj@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Waiman Long <longman@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1173/2151] selftests/cgroup: use runtime page size for zswpin check
Date: Wed, 18 Nov 2026 15:48:28 +0100
Message-ID: <20261118150204.855984547@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Wang <li.wang@linux.dev>

[ Upstream commit b19ee588e159c71f0d314246a944dcfc3e2a6009 ]

test_zswapin compares memory.stat:zswpin (counted in pages) against a byte
threshold converted with PAGE_SIZE.  In cgroup selftests, PAGE_SIZE is
hardcoded to 4096, which makes the conversion wrong on systems with non-4K
base pages (e.g.  64K).

As a result, the test requires too many pages to pass and fails spuriously
even when zswap is working.

Use sysconf(_SC_PAGESIZE) for the zswpin threshold conversion so the check
matches the actual system page size.

Link: https://lore.kernel.org/20260424040059.12940-4-li.wang@linux.dev
Signed-off-by: Li Wang <li.wang@linux.dev>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Chengming Zhou <chengming.zhou@linux.dev>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 0567c7eaefd7 ("selftests/cgroup: test_zswap: fix implicit unsigned promotion bug in test_no_kmem_bypass")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 53d1553e09619..c7d45aa9c77ea 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -245,7 +245,7 @@ static int test_zswapin(const char *root)
 		goto out;
 	}
 
-	if (zswpin < MB(24) / PAGE_SIZE) {
+	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
-- 
2.53.0



