Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ABF31863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:08:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4E7C433D2;
	Wed, 28 Dec 2022 15:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240121;
	bh=hvEaW+R/g4ESMPE5f6j9wm+HHJ34mDcZ+PHSC8ogkAc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wlMvIyCbSxePrMdB9K8ICUCOpFEYlr7AJv2D4JYdvW2gE25Ja0aCo7A+7cQDuWmFc
	 mkDUyGZZy3jRbnv00hQCGcb61SwicQY+ibKrvB4n9BJAXb+0vajzUwEiWmn56B7bHs
	 d0Do4/3b9EO3HWjik/gQaBpfbc4QIDNk0TN1GVM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YueHaibing <yuehaibing@huawei.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kamalesh Babulal <kamalesh.babulal@oracle.com>,
	David Rientjes <rientjes@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeelb@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	zefan li <lizefan.x@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0120/1073] selftests: cgroup: fix unsigned comparison with less than zero
Date: Wed, 28 Dec 2022 15:28:28 +0100
Message-Id: <20221228144331.297733888@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 333d073dee3a6865171d43e3b0a9ff688bff5891 ]

'size' is unsigned, it never less than zero.

Link: https://lkml.kernel.org/r/20221105110611.28920-1-yuehaibing@huawei.com
Fixes: 6c26df84e1f2 ("selftests: cgroup: return -errno from cg_read()/cg_write() on failure")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Kamalesh Babulal <kamalesh.babulal@oracle.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: zefan li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/cgroup/cgroup_util.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/cgroup/cgroup_util.c b/tools/testing/selftests/cgroup/cgroup_util.c
index 4c52cc6f2f9c..e8bbbdb77e0d 100644
--- a/tools/testing/selftests/cgroup/cgroup_util.c
+++ b/tools/testing/selftests/cgroup/cgroup_util.c
@@ -555,6 +555,7 @@ int proc_mount_contains(const char *option)
 ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t size)
 {
 	char path[PATH_MAX];
+	ssize_t ret;
 
 	if (!pid)
 		snprintf(path, sizeof(path), "/proc/%s/%s",
@@ -562,8 +563,8 @@ ssize_t proc_read_text(int pid, bool thread, const char *item, char *buf, size_t
 	else
 		snprintf(path, sizeof(path), "/proc/%d/%s", pid, item);
 
-	size = read_text(path, buf, size);
-	return size < 0 ? -1 : size;
+	ret = read_text(path, buf, size);
+	return ret < 0 ? -1 : ret;
 }
 
 int proc_read_strstr(int pid, bool thread, const char *item, const char *needle)
-- 
2.35.1



