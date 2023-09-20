Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169842E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:15:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A1F0C433C8;
	Wed, 20 Sep 2023 12:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212111;
	bh=uYNGZEvNke7FCBRg67aJS5xzVN40e1LF4mQm6UynyzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpviIKzOSWBpklMph+W4ajh1qZDAukbKC33buTEiR7mXPmUJIvs6GZOlSQ3VLf/Qn
	 CAfnmzJh6dMwtMRr5TaymkvvXe8vBz7suoeB4TT5fCWLJdbnvqL95RRyGt8+hL1yJ3
	 Sru3ckTeIWZSLQVO8arAWKZuC7Q4xIXi1QhAUNOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Jialin <lujialin4@huawei.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 154/273] cgroup:namespace: Remove unused cgroup_namespaces_init()
Date: Wed, 20 Sep 2023 13:29:54 +0200
Message-ID: <20230920112851.292950663@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Jialin <lujialin4@huawei.com>

[ Upstream commit 82b90b6c5b38e457c7081d50dff11ecbafc1e61a ]

cgroup_namspace_init() just return 0. Therefore, there is no need to
call it during start_kernel. Just remove it.

Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
Signed-off-by: Lu Jialin <lujialin4@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/namespace.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/cgroup/namespace.c b/kernel/cgroup/namespace.c
index b05f1dd58a622..313e66b8c6622 100644
--- a/kernel/cgroup/namespace.c
+++ b/kernel/cgroup/namespace.c
@@ -148,9 +148,3 @@ const struct proc_ns_operations cgroupns_operations = {
 	.install	= cgroupns_install,
 	.owner		= cgroupns_owner,
 };
-
-static __init int cgroup_namespaces_init(void)
-{
-	return 0;
-}
-subsys_initcall(cgroup_namespaces_init);
-- 
2.40.1



