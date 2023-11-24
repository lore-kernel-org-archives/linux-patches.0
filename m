Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D813139FD9;
	Fri, 24 Nov 2023 18:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YK2oSasL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606F2C433C8;
	Fri, 24 Nov 2023 18:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849982;
	bh=2IKiglihdtkb7wuA8k4IopQtSFbDoPazKhSRXuY2WdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YK2oSasLztGO1bHZpYYbH9avIwrRnxf6Cguy+Mj2NrHI69+4N7xG03jrGJ0hmnW5Q
	 70RwNqoTETRYzNl64izjLYDHVStJzuxxC99ZlIpGEq8WFm+aYTpoFS2yXf+RDqoyQb
	 k6aIEwgEtn2Y8eN7HUwjZCDk4AMpEkajvKUxPJh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 398/530] apparmor: Fix kernel-doc warnings in apparmor/policy.c
Date: Fri, 24 Nov 2023 17:49:24 +0000
Message-ID: <20231124172040.137224917@linuxfoundation.org>
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

[ Upstream commit 25ff0ff2d6286928dc516c74b879809c691c2dd8 ]

Fix kernel-doc warnings:

security/apparmor/policy.c:294: warning: Function parameter or
member 'proxy' not described in 'aa_alloc_profile'
security/apparmor/policy.c:785: warning: Function parameter or
member 'label' not described in 'aa_policy_view_capable'
security/apparmor/policy.c:785: warning: Function parameter or
member 'ns' not described in 'aa_policy_view_capable'
security/apparmor/policy.c:847: warning: Function parameter or
member 'ns' not described in 'aa_may_manage_policy'
security/apparmor/policy.c:964: warning: Function parameter or
member 'hname' not described in '__lookup_replace'
security/apparmor/policy.c:964: warning: Function parameter or
member 'info' not described in '__lookup_replace'
security/apparmor/policy.c:964: warning: Function parameter or
member 'noreplace' not described in '__lookup_replace'
security/apparmor/policy.c:964: warning: Function parameter or
member 'ns' not described in '__lookup_replace'
security/apparmor/policy.c:964: warning: Function parameter or
member 'p' not described in '__lookup_replace'

Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 157a3537d6bc ("apparmor: Fix regression in mount mediation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/security/apparmor/policy.c b/security/apparmor/policy.c
index ec695a6caac7d..b9aaaac84d8a2 100644
--- a/security/apparmor/policy.c
+++ b/security/apparmor/policy.c
@@ -286,6 +286,7 @@ void aa_free_profile(struct aa_profile *profile)
 /**
  * aa_alloc_profile - allocate, initialize and return a new profile
  * @hname: name of the profile  (NOT NULL)
+ * @proxy: proxy to use OR null if to allocate a new one
  * @gfp: allocation type
  *
  * Returns: refcount profile or NULL on failure
@@ -775,8 +776,9 @@ static int policy_ns_capable(struct aa_label *label,
 
 /**
  * aa_policy_view_capable - check if viewing policy in at @ns is allowed
- * label: label that is trying to view policy in ns
- * ns: namespace being viewed by @label (may be NULL if @label's ns)
+ * @label: label that is trying to view policy in ns
+ * @ns: namespace being viewed by @label (may be NULL if @label's ns)
+ *
  * Returns: true if viewing policy is allowed
  *
  * If @ns is NULL then the namespace being viewed is assumed to be the
@@ -840,6 +842,7 @@ bool aa_current_policy_admin_capable(struct aa_ns *ns)
 /**
  * aa_may_manage_policy - can the current task manage policy
  * @label: label to check if it can manage policy
+ * @ns: namespace being managed by @label (may be NULL if @label's ns)
  * @mask: contains the policy manipulation operation being done
  *
  * Returns: 0 if the task is allowed to manipulate policy else error
@@ -951,11 +954,11 @@ static void __replace_profile(struct aa_profile *old, struct aa_profile *new)
 
 /**
  * __lookup_replace - lookup replacement information for a profile
- * @ns - namespace the lookup occurs in
- * @hname - name of profile to lookup
- * @noreplace - true if not replacing an existing profile
- * @p - Returns: profile to be replaced
- * @info - Returns: info string on why lookup failed
+ * @ns: namespace the lookup occurs in
+ * @hname: name of profile to lookup
+ * @noreplace: true if not replacing an existing profile
+ * @p: Returns - profile to be replaced
+ * @info: Returns - info string on why lookup failed
  *
  * Returns: profile to replace (no ref) on success else ptr error
  */
-- 
2.42.0



