Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DEB9392C29;
	Tue, 21 Jul 2026 18:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657368; cv=none; b=kBMYK2RkuN2TEJH4JbKKcJGesOj4YeFGbGOmDeyTF2QfxPPcdKmOGSH2XWiC8GZ/Rbhn/BwLqbG1+Usq1QTRjQp7rBqd7Dyi+T78Urwno0gO4nl6fKIRpqImw8191YSRWr70hvcubrATr+vaUce2z6xi4HBhKywV4T99/aFQsbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657368; c=relaxed/simple;
	bh=hRHsHNKxeh6cYMbuK26rvaLqVuarqUpo1kjeHYpvbSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q2GN3uJZHrJQ+fQO7/tMsfgTrn+dAum2gE3bLM6REqF8nO0CGGZ/sMQHryVplEEQlCiU0iLL0sQiDG3PSwGoVppR6s/C+uaC0rHasaoJtBOms5XiivvsbfBgzDteWdP+s+424pvy8zM9VC6ZT+TDhBPjEKyA6cb7/zJmNOjn2LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxufAAgL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxufAAgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B1731F000E9;
	Tue, 21 Jul 2026 18:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657367;
	bh=c42ArQxm5l6SZDDzzZXBYK8V8eh54DH4Y1vBEcFjqws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KxufAAgLRluLqPn8t8X7y0bBe+WOkliSxBwcR1NwmCTstpCAxJcKCNPW5B7JibraZ
	 SKw6Z0J3i9cyN2vCUaWlaWyDHR3NP4AYToFBZnwbvCDqjJlkdQciLCR0O8oqFtcnxw
	 xoSPTautGh985+nM05tvs1s7VL0+fxaL87eIzC7c=
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
Subject: [PATCH 6.18 0736/1611] security/apparmor/apparmorfs.c: conditionally compile get_loaddata_common_ref()
Date: Tue, 21 Jul 2026 17:14:12 +0200
Message-ID: <20260721152531.934490120@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ff301c7e84d906..5b326d0b170fae 100644
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



