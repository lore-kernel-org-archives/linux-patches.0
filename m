Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B7F470117;
	Tue, 21 Jul 2026 19:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660597; cv=none; b=pkReRFFAY8hcsyuuT/XxMB/4ncfdvuNci6XFRMoPLPo3wTNrCSxPTqIVoiVeqRmAMhnKfLmH5DQxfIDntrQijhMGi17lpaxdEHwTOXHFCSqW8KBW+n7tUt7NLWaWJuf9XgDrgS40VztgwpTvwEPyNfHdVyGg/7Zq8NGt3DAhsUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660597; c=relaxed/simple;
	bh=HNq+1Jwgj/lbse3JRbJfZ8X/UzB8Y/mP0wdOOABbD6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7S8e28GkZL35jXcTNfUsEWbnq77VW5Csjzl0h15Q200qn4EwWhVHktdT0PLSO5RnfbchpCbL8cWqHUatpGYKsbvJoj8F2m17WvjqgZl4Wp/Cv8x5VKd/B2eOjOJKyijUqFjvnQV8StyM+vI8TNxVq6a3kHXruHvcGXtk4Tyyj0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bndttl5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bndttl5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90A481F00A3E;
	Tue, 21 Jul 2026 19:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660595;
	bh=uM/fjVV06aE85+7CrMJwfuQhMPK9LsS6tbP7AF6r/c0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bndttl5Rfn/BYkyy8rQkrR48bbZ4Q2+odutW2xs3WvQ+H12hSFchO9OrcZFBaWYEq
	 6QHUabuGa3Hgq00ID9yYXYrnAUdVsSLUiDp/hlga8OJ7S3pNi5O3ygF5MuJuTHZe4N
	 y+vG7FqxPH0M20NxXDm5+PU8Nx3aA8v6i649IXck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1039/2077] security/apparmor/apparmorfs.c: conditionally compile get_loaddata_common_ref()
Date: Tue, 21 Jul 2026 17:11:52 +0200
Message-ID: <20260721152617.318438865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Andrew Morton <akpm@linux-foundation.org>

[ Upstream commit d62d9bfe050f44f772d05a32079dba3e3523ab2a ]

Some config did this:

security/apparmor/apparmorfs.c:177:28: warning: 'get_loaddata_common_ref' defined but not used [-Wunused-function]
  177 | static struct aa_loaddata *get_loaddata_common_ref(struct aa_common_ref *ref)

get_loaddata_common_ref() is only used if
CONFIG_SECURITY_APPARMOR_EXPORT_BINARY=y.

(Or of course move the function into that block if maintainers perfer)

Fixes: 8e135b8aee5a0 ("apparmor: fix race between freeing data and fs accessing it")
Cc: John Johansen <john.johansen@canonical.com>
Cc: Paul Moore <paul@paul-moore.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/apparmorfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index ededaf46f3caa7..aeff3d2d863bc5 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -174,6 +174,7 @@ static struct aa_proxy *get_proxy_common_ref(struct aa_common_ref *ref)
 	return NULL;
 }
 
+#ifdef CONFIG_SECURITY_APPARMOR_EXPORT_BINARY
 static struct aa_loaddata *get_loaddata_common_ref(struct aa_common_ref *ref)
 {
 	if (ref)
@@ -181,6 +182,7 @@ static struct aa_loaddata *get_loaddata_common_ref(struct aa_common_ref *ref)
 						      count));
 	return NULL;
 }
+#endif
 
 static void aa_put_common_ref(struct aa_common_ref *ref)
 {
-- 
2.53.0



