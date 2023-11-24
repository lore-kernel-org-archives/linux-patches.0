Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E15D3A8C3;
	Fri, 24 Nov 2023 18:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ystB/Ka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C94C433C8;
	Fri, 24 Nov 2023 18:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849980;
	bh=wjCvxCklh+iyi3D7J6ZbplOIN0nl/hsykAyNmeR8cDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ystB/KaiozpN1SREtMJhmfpFNMh+SZ/cx4o9wN/k5Os8UG4mVyYdIjIQB7dVZBrx
	 3UlJEVZN0pDa6e5Te/dBkvqhKrLyk3YMM7pVBqv3P/tpiXNLsx0zrNC5XN7P/qrLhI
	 oDKE9kA14QfalC5AoP0icAbYFnW41S3V8DXSlbhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 397/530] apparmor: Fix kernel-doc warnings in apparmor/resource.c
Date: Fri, 24 Nov 2023 17:49:23 +0000
Message-ID: <20231124172040.107249493@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit 13c1748e217078d437727eef333cb0387d13bc0e ]

Fix kernel-doc warnings:

security/apparmor/resource.c:111: warning: Function parameter or
member 'label' not described in 'aa_task_setrlimit'
security/apparmor/resource.c:111: warning: Function parameter or
member 'new_rlim' not described in 'aa_task_setrlimit'
security/apparmor/resource.c:111: warning: Function parameter or
member 'resource' not described in 'aa_task_setrlimit'
security/apparmor/resource.c:111: warning: Function parameter or
member 'task' not described in 'aa_task_setrlimit'

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 157a3537d6bc ("apparmor: Fix regression in mount mediation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/resource.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/security/apparmor/resource.c b/security/apparmor/resource.c
index e859481648962..2bebc5d9e7411 100644
--- a/security/apparmor/resource.c
+++ b/security/apparmor/resource.c
@@ -97,10 +97,10 @@ static int profile_setrlimit(struct aa_profile *profile, unsigned int resource,
 
 /**
  * aa_task_setrlimit - test permission to set an rlimit
- * @label - label confining the task  (NOT NULL)
- * @task - task the resource is being set on
- * @resource - the resource being set
- * @new_rlim - the new resource limit  (NOT NULL)
+ * @label: label confining the task  (NOT NULL)
+ * @task: task the resource is being set on
+ * @resource: the resource being set
+ * @new_rlim: the new resource limit  (NOT NULL)
  *
  * Control raising the processes hard limit.
  *
-- 
2.42.0



