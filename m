Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031085;
	b=NmQ0mh+C/XRaQUge0AZ2X5ZUuw5AN7Uvb+GelGheFdkG8LefOCiKwuA+pQi6rm407YFQ
	 ZGHan+djULqFdhE4Mh2FrzNTF22nf3T31qSbtT8XebstUjaMyuAKS1w1wQ0t/MuvO79MW
	 GxwZcZ4WZ6zY34oss0uRApPQw3SX2BVDUY9dSlzrD4Y6ymq4tsexMPmgi1XAkhXPurf3W
	 YURmITi8lcl189r32zPvkzHHEVd3JjqCrIj/RccswcdAeoZBO+WSuWxDApHDvNUJEHZsl
	 R8sr1GthcmeIQRHro+aD4NzbMxeHDQJEugHqB6AtPAhlqanb+XkHuyBCVhkU21pLd4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031085;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JpHpw3TqogvVuV+C/KWj1vJvLnL1wbtxCousAotK5ZQ=;
	b=QD4RDxuuKlbIBmDCm74qSubpsSPH+eeveIkK+ypiJtVOeVMaYxxh+erf337/WAB+0K1I
	 OU4a4nOcosgQX20XMSSu+odttuP/Y+bl4hF+AttkVvuLmCbS+aspdxrZdYvfaS7/WVL3t
	 ma7JgVnshgWJcCuLGVrW74cxKu5J5ixVnnwjX2yEcC4dmctENJ/Ju3s5YNyizCulIYMdg
	 6C/vK7DeRKHKRBsR6UvjmJWhPYk2so7OWffA0aws3W43bvDY5rA1PpRdzxrJtcdPGErsX
	 ZO/2iu+RCZA2oxD10vEvNxEm/LuvMBv9SgNBFuz2Qhq1Y+jbSFoCZP6Kx1y8AK9uYag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iJoGg/xb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53186606A33A;
	Wed, 18 Nov 2026 19:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iJoGg/xb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 840841F000C6;
	Wed, 18 Nov 2026 19:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031085;
	bh=JpHpw3TqogvVuV+C/KWj1vJvLnL1wbtxCousAotK5ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iJoGg/xbYgDe8FQz/JHNN5R80cxOcp/u9WwpxpWT9YI6X9ECfwLdG2CRgCe2M7/4I
	 i20kcLej8QrNr5O35JW4VrXVUjyZ9Gce+EQ3mDU5z2wxYzqjK+7719QFSskj7806aI
	 LmRpV5SGfNtXTF7VCJkvyiNMU/3mzWhZ4pW1uoSc=
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
Subject: [PATCH 6.12 0934/1756] selftests/cgroup: use runtime page size for zswpin check
Date: Wed, 18 Nov 2026 15:51:01 +0100
Message-ID: <20261118150047.137725959@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ea0d61424de40..e2a4f97e90910 100644
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



