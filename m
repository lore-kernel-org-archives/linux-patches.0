Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151DD356A12;
	Tue, 21 Jul 2026 20:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666587; cv=none; b=c12QazlmWyy88gRxdXhoXfaj5wWTrKmqMaG+LSYWSmUrpBwMwUcdMUQNlFUQXaDwwrQqIBGveZxS/lvJsk83JW1C0ogMKDH2dNtLULVq0nx7U6hds/WSyEgJcOiVEVBH/hb3mvIrDQp/u4UD3Ff/wrm34o4JtM4ujwoQzIvzKSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666587; c=relaxed/simple;
	bh=m3Ttw9CX35Y2/vkY4QE+1u3qJ73au6rKDmgSDv0ysxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aE1M/1csKQh+efn/87KtsAiC1ETFOtZ2/6uQMCdh11ocoQ7GVvE+jw2It7jIkNIhj0m0KR/gAe4sw8nDybddw7OF8QGEAmr0HZeMvbn7S94XVY6t0kz/y2lTYPqxh456ObOlMVS3aFxzGn4Vn4hPrv5Z0lHlL/xydUo/iuccMxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ktoOD1Je; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ktoOD1Je"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8151C1F000E9;
	Tue, 21 Jul 2026 20:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666586;
	bh=bd4FvYY4yq2RyLFjg9JebkQaw2eHxVIUEngeS3HMh/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktoOD1JenYbLZZF6RQNOPB9gnrq87lETPSXWhdKynnmeVlHYDZ+cunGXtkqURV/gl
	 6+4QweGo5EEcKTv5/TO7ScEQ2IhLlm6LKqc+fz7Ee7uPP6TRGECgJLIfO5gx1YXGlA
	 +QsxcVpAHCkLTFsQIQSfodWh8OK6EwALrav36h+M=
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
Subject: [PATCH 6.6 0696/1266] security/apparmor/apparmorfs.c: conditionally compile get_loaddata_common_ref()
Date: Tue, 21 Jul 2026 17:18:53 +0200
Message-ID: <20260721152457.433300856@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 157ebdb100c00b..3fdb084db3a917 100644
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



