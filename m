Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAC14376A0B;
	Tue, 21 Jul 2026 21:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669434; cv=none; b=srD1fjlquyB7Jtbg/X45cgF4cMEmlIEooOqQJyGEWg00U5X26PoNVfvhFfKDng1yehUTRfxuHyDwPU3WxOdwBr1jTp3q0Jhm3hWNDzpCRYZfD9YugVuAoKM4wZPAJWjKHWXpEHm8wKhocVo5Ot1grHe7jyy5QhNc5deDVhC8N7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669434; c=relaxed/simple;
	bh=+TiaMJ4G4jIijNn1Od5CL+rd/ioGPnSiPY2DoNwMKF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKgViJaWOyLtYvw6lu8o7BhFB8Rw3dR/nOY75Ea/C/hI4BOLUOWnG5/w798ziYq1rAqcUONVXRobdLNvl2cf9g5Mjp9Xh6Sm8uBF6Gq9cb+5RlefLGV4qqQoQmEpAmBfiFzGTq0YKOqEaVF5X47QAF3kj9jHOCr4x3++1RTpiHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qqbm/Ayu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qqbm/Ayu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95881F000E9;
	Tue, 21 Jul 2026 21:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669433;
	bh=C+cdwvD2+/ozjkVRMeaZcuqVDQYXyTK3HL8oKPFhzJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qqbm/AyuIsdcqGEtneb+cM92swMoLmqLtYBfgWOQdv/4jpoZQjmYtJSdXP1yvAVgM
	 w9P7tYtQh41+XqVNyFCeRvX9+o2M1h5lQIhhDhMqzmSka5Vkd6fEuKg2ahIsrZHzuU
	 poz3tJ69kaUxxE0fAdUpNdOjb1aumvuwUFa8dodU=
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
Subject: [PATCH 6.1 0552/1067] security/apparmor/apparmorfs.c: conditionally compile get_loaddata_common_ref()
Date: Tue, 21 Jul 2026 17:19:13 +0200
Message-ID: <20260721152436.957696462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ff84ce10ca67e9..1476517ddef11b 100644
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



