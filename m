Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA74230C365;
	Mon, 13 Oct 2025 15:20:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368840; cv=none; b=bX9G4Jj9ROyhaCaxX6z6Qr8rHu8gwf9qeHAtZQjLW5R6+uKY7kwDVXIaHTL1UOgFr7ps1gKjaO2hyY2Uz0oeIJWtNZswtIsR2jWJZXhaqfiNsIpwSc+rhplF2QYapP7ZkxP6hojNKhEtcIw58WkDtOtV5zlZ7aJFEBgXBx3JvR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368840; c=relaxed/simple;
	bh=m+wnRGZsN87rK7yo9c0I1zc16PLcDtwIehZoHXbACC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oMkSKkYGddW8Rj9yErIXFycsz94QKJ/OM3xB57YtFfT1kemUjAQ/7HWV741tODZTo8RqiY/yEF3k81H9Q1zl6pMtLKE0c+HxcMuwYBCtUmZrz+9DZqpzvapNkdL00dbJSvcSSunbM5fN1bknoZTGnmBa3V9x1pN6etNqHs/9jfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5HhqORE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5HhqORE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AB5C4CEE7;
	Mon, 13 Oct 2025 15:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368840;
	bh=m+wnRGZsN87rK7yo9c0I1zc16PLcDtwIehZoHXbACC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5HhqORE9HHwyIRB89EfJXqtJoJvmbVh/wt2eck6MDo8UjOiN+XGfzLvNdagqlJKh
	 F2sC7hDRrgdt711c965OWQivy7RB8gPyYD/Y+VyedgxHylVJj4m0NeDoo++5HNuQH5
	 fImFEe2yMRpvVzxdOcW1YzJAAOyTrwImp+2e9J5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Paul Moore <paul@paul-moore.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 037/563] lsm: CONFIG_LSM can depend on CONFIG_SECURITY
Date: Mon, 13 Oct 2025 16:38:18 +0200
Message-ID: <20251013144412.634329787@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 54d94c422fed9575b74167333c1757847a4e6899 ]

When CONFIG_SECURITY is not set, CONFIG_LSM (builtin_lsm_order) does
not need to be visible and settable since builtin_lsm_order is defined in
security.o, which is only built when CONFIG_SECURITY=y.

So make CONFIG_LSM depend on CONFIG_SECURITY.

Fixes: 13e735c0e953 ("LSM: Introduce CONFIG_LSM")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
[PM: subj tweak]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/security/Kconfig b/security/Kconfig
index 4816fc74f81eb..285f284dfcac4 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -269,6 +269,7 @@ endchoice
 
 config LSM
 	string "Ordered list of enabled LSMs"
+	depends on SECURITY
 	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,apparmor,ipe,bpf" if DEFAULT_SECURITY_SMACK
 	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smack,tomoyo,ipe,bpf" if DEFAULT_SECURITY_APPARMOR
 	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,ipe,bpf" if DEFAULT_SECURITY_TOMOYO
-- 
2.51.0



