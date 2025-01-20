Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43D71DED4B;
	Mon, 20 Jan 2025 13:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737379293; cv=none; b=gEaqIGApiZVahF8/nS3IM2vhb7UztdHmNK5cQiFyCjnBTsewtriKQpt+/A3o1c6BbXmuECMi1r1XaO0XU/s/29rN9W+j/mDI0jPXhVB/kYa6M0FMqF7iXsILdWWg2O2tdJRR/4NqMujMTUfhqfiPnbMwIcn++mW5C+FoA/YTW/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737379293; c=relaxed/simple;
	bh=gC579WahATfW87vCukQ9zNWcta2vXe56nrlKbwqFpRs=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=QbM+pjK/8wEdKlVGNmXW3f/QXO0EEErbjHXc2bfyp6ZCU5zmfBDA3dAjWqy0PxjiHBGr7PHxeznrbbnkZN04XMNvQtNxSFNqncIjm1bjMv+8R8N2D73qyyknOFj0qZUdbTtDjAvb/pOoZKxE+elVPHx5JJPo/b4cl/0fZuhlaLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cFXLS8MX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cFXLS8MX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EADE1C4CEE3;
	Mon, 20 Jan 2025 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737379293;
	bh=gC579WahATfW87vCukQ9zNWcta2vXe56nrlKbwqFpRs=;
	h=From:Date:Subject:To:Cc:From;
	b=cFXLS8MXbTJnyamRQM5Q9/pC1nGmdK3aG1XFh26BqzUb1xdbt8dBq76nJzui8QRCL
	 a3ZfKdfry6AzHIE3563IMrZp9GdCpbA46SjNRhAghmWOoWtn+kFnqIYNWzoDubVdZG
	 Ucl63ZrqXNu27D4JjQbNZRKCwHJQ+Hwyfo6AqFizQiux57NRqckAB5HVKlx1UVnDz/
	 Yd8tWFmh6htp1Ftu9Ixwol2bsgK66KiCPVo2j5qg3uM8ZKcjSaINQ2/WHR5hzBzIvh
	 mlJrfW0uAS7W9iur1rYRskU0ZB6eg+TCYozyWSD33Rswzn7WEX/1wNt7ifdUbdy/bv
	 SJL+V+4P5djPA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 20 Jan 2025 06:21:14 -0700
Subject: [PATCH] apparmor: Remove unused variable 'sock' in
 __file_sock_perm()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250120-apparmor-fix-unused-sock-__file_sock_perm-v1-1-8d17bd672c6a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAMlNjmcC/x2N0QrCMBAEf6XcswdpqBb8FZGQphs9tEm4UBFK/
 73Rt5mH2d2oQgWVrt1Gio9UyalJf+ooPH16gGVuTtbYs+mtYV+K1yUrR/nymtaKmWsOL3Yuyhv
 ux65AFzYYLnacAuI0Utsritb8v273fT8AS3kMWXsAAAA=
X-Change-ID: 20250120-apparmor-fix-unused-sock-__file_sock_perm-0e4627bcefb7
To: John Johansen <john.johansen@canonical.com>
Cc: apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 patches@lists.linux.dev, kernel test robot <lkp@intel.com>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1657; i=nathan@kernel.org;
 h=from:subject:message-id; bh=gC579WahATfW87vCukQ9zNWcta2vXe56nrlKbwqFpRs=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOl9vrenr5XmPNRl71GfsOh6LPvTEIbyPScX8D6b1C8U4
 mDs6dPQUcrCIMbFICumyFL9WPW4oeGcs4w3Tk2CmcPKBDKEgYtTACZSUM7wz559x0x+7wVdrTMS
 5BzSCqb4P1uW++dJ0HvThFmZha4vmRj+V/nYx062XfWEcynT8xz7QK04vrmewV2OoWY/DJZMry1
 gBAA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When CONFIG_SECURITY_APPARMOR_DEBUG_ASSERTS is disabled, there is a
warning that sock is unused:

  security/apparmor/file.c: In function '__file_sock_perm':
  security/apparmor/file.c:544:24: warning: unused variable 'sock' [-Wunused-variable]
    544 |         struct socket *sock = (struct socket *) file->private_data;
        |                        ^~~~

sock was moved into aa_sock_file_perm(), where the same check is
present, so remove sock and the assertion from __file_sock_perm() to fix
the warning.

Fixes: c05e705812d1 ("apparmor: add fine grained af_unix mediation")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501190757.myuLxLyL-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 security/apparmor/file.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/security/apparmor/file.c b/security/apparmor/file.c
index 85f89814af1e..e3a858649942 100644
--- a/security/apparmor/file.c
+++ b/security/apparmor/file.c
@@ -541,11 +541,8 @@ static int __file_sock_perm(const char *op, const struct cred *subj_cred,
 			    struct aa_label *flabel, struct file *file,
 			    u32 request, u32 denied)
 {
-	struct socket *sock = (struct socket *) file->private_data;
 	int error;
 
-	AA_BUG(!sock);
-
 	/* revalidation due to label out of date. No revocation at this time */
 	if (!denied && aa_label_is_subset(flabel, label))
 		return 0;

---
base-commit: e6b087676954e36a7b1ed51249362bb499f8c1c2
change-id: 20250120-apparmor-fix-unused-sock-__file_sock_perm-0e4627bcefb7

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

