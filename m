Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB391BC58;
	Mon, 11 Nov 2024 14:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731336589; cv=none; b=FM8Hl/o3zunmqeSdGuXnlUzeCynUSoZIJoDKiebw86cS720X0/eogzRRggoLt0V3P5Ag2oog71QhhxqclWHFLqWAGO4Tlaqriboy+Ll3t0FvZ1VDkJ4zVKS/PrmM5GBZL92UrLnJkfJfQ9415c5foOVpo4UxDMC3MVmF1vMURcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731336589; c=relaxed/simple;
	bh=ZZOkQZlepEFjStUosjL2ipFfpBBqpltZJPRQrLteQ7I=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=twVoY3mtiRualZhdxE3w/NAf4cjL4sBbXhRkUVxLJHbhJKKPmUEPjohm3MjBpDgky6lRyksNRV3FxgihjsT6EAi/tvFizhLapNgGWFWPptiB8fNX6zedoKUx5mNYpuYFtJ+07D0Pr0NmLeTubDjhNC0njMUGcLh/eTs9JPfsp50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PAhW4mNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PAhW4mNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717EAC4CECF;
	Mon, 11 Nov 2024 14:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731336588;
	bh=ZZOkQZlepEFjStUosjL2ipFfpBBqpltZJPRQrLteQ7I=;
	h=From:Date:Subject:To:Cc:From;
	b=PAhW4mNon2UieJ6UMXSzGCOSlFpRqJL7VxB7ijV2lpYigshncvzGh8l7fLSwt7ZnH
	 TpOWtEkd9y+i2AIw+dn7RKXxz2Hv2xqCz+1NFfVozy0dFid8nomkk7OvVLs/jNgCSL
	 gw0kwiJJV6KChCtFWUpHsr1Iy1/cTFPeOAosoygEuFtpZPSFYrDymzjOvlEGMkcdJb
	 HrzK7yrddLgqHKRQZ4dDNHXoVooO+x+E0fPzTrfCHvNvFDcg0WHbmklas8B4iDQwZN
	 PpQw/KM8ZuROh4gmEj9BHmXMznqFKtKUVA6CTjVaKshtx1NuVWr4IcwEpoChU82CbY
	 CQwiGKGZHzjBA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 11 Nov 2024 07:49:43 -0700
Subject: [PATCH] apparmor: Add empty statement between label and
 declaration in profile_transition(()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241111-apparmor-fix-label-declaration-warning-v1-1-adb64ab6482b@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIYZMmcC/x2NQQrDMAwEvxJ0riA2hkC+EnpQbSUROLaRSxsI+
 XtF9zaHmb2gswp3mIcLlD/SpRYD9xgg7lQ2RknG4EcfnA2pNdKjKq5yYqYXZ0wcMym9TcUvaZG
 y4RqTD5F9CmECizVlE/5Hy/O+f49tURV4AAAA
X-Change-ID: 20241111-apparmor-fix-label-declaration-warning-fcd24ce2d447
To: John Johansen <john.johansen@canonical.com>
Cc: Ryan Lee <ryan.lee@canonical.com>, apparmor@lists.ubuntu.com, 
 linux-security-module@vger.kernel.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2357; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ZZOkQZlepEFjStUosjL2ipFfpBBqpltZJPRQrLteQ7I=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOlGkj1aedv2/Dkot0DL/lLXycubufgUeW5IXVDedMwn1
 bBdPmtmRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZhI7AtGhj08lleXfD3rsvzp
 nDVNKa8z2C70rWkBGjrp0TIu9RzzKob/2cevRH8zUjWYeXvxvy/WRW+uytZPNtmko6RatXH91me
 vuAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Clang 18 and newer warns (or errors with CONFIG_WERROR=y):

  security/apparmor/domain.c:695:3: error: label followed by a declaration is a C23 extension [-Werror,-Wc23-extensions]
    695 |                 struct aa_profile *new_profile = NULL;
        |                 ^

With Clang 17 and older, this is just an unconditional hard error:

  security/apparmor/domain.c:695:3: error: expected expression
    695 |                 struct aa_profile *new_profile = NULL;
        |                 ^
  security/apparmor/domain.c:697:3: error: use of undeclared identifier 'new_profile'
    697 |                 new_profile = aa_new_learning_profile(profile, false, name,
        |                 ^
  security/apparmor/domain.c:699:8: error: use of undeclared identifier 'new_profile'
    699 |                 if (!new_profile) {
        |                      ^
  security/apparmor/domain.c:704:11: error: use of undeclared identifier 'new_profile'
    704 |                         new = &new_profile->label;
        |                                ^

Add a semicolon directly after the label to create an empty statement,
which keeps the original intent of the code while clearing up the
warning/error on all clang versions.

Fixes: ee650b3820f3 ("apparmor: properly handle cx/px lookup failure for complain")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202411101808.AI8YG6cs-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 security/apparmor/domain.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 602d7a1bb44823a9b81e34d270b03c5f3aff3a34..eb0f222aa29442686b0a6751001c879f5b366c59 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -691,7 +691,7 @@ static struct aa_label *profile_transition(const struct cred *subj_cred,
 			error = -EACCES;
 		}
 	} else if (COMPLAIN_MODE(profile)) {
-create_learning_profile:
+create_learning_profile:;
 		/* no exec permission - learning mode */
 		struct aa_profile *new_profile = NULL;
 

---
base-commit: 8c4f7960ae8a7a03a43f814e4af471b8e6ea3391
change-id: 20241111-apparmor-fix-label-declaration-warning-fcd24ce2d447

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

