Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 500694685;
	Tue,  4 Oct 2022 23:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7461CC433B5;
	Tue,  4 Oct 2022 23:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664925860;
	bh=FLSPg+BDw6WCtKWX2GlQGeBJ1gmzbxSrtkABWZcLRH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fUDvX9vReXInB+JLUJaiAcizXIl5NvllyNUiwgYkizxc/pzF/nBLhLmBifcR3w/fa
	 mB5HtLuPWqBeP4ceQ7scSbVOGW+iT+nWR5Jj72TktaOAqIXHaS1jVG5eJy95bN87Ja
	 Z3tGTp1GNVW4NxgvqOGoeonAw5tNMeLwLirUhyEXBk3Y1FSJWPQnEkRy1hK0b0futr
	 exWB2JCYHnz1CtodYeLLhkmHkgLEyj1ClO+JR4MZcC0a+cheXBZ2I/spYycL9/eYPt
	 U+yENm4eVHBnpI/cDw8Ry5UdmFEeXEky3lH9m5tnxslqWf4/UMgJro3OPY4j9NQAy7
	 ztGCeF+eFkE9w==
From: Nathan Chancellor <nathan@kernel.org>
To: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	ntfs3@lists.linux.dev,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH -next v2 2/2] fs/ntfs3: Eliminate unnecessary ternary operator in ntfs_d_compare()
Date: Tue,  4 Oct 2022 16:23:59 -0700
Message-Id: <20221004232359.285685-2-nathan@kernel.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221004232359.285685-1-nathan@kernel.org>
References: <20221004232359.285685-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

'a == b ? 0 : 1' is logically equivalent to 'a != b'.

Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---

v2: New patch.

 fs/ntfs3/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/namei.c b/fs/ntfs3/namei.c
index 5d3a6ce3f05f..6b0d2c01d6ff 100644
--- a/fs/ntfs3/namei.c
+++ b/fs/ntfs3/namei.c
@@ -432,7 +432,7 @@ static int ntfs_d_compare(const struct dentry *dentry, unsigned int len1,
 	/* First try fast implementation. */
 	for (;;) {
 		if (!lm--)
-			return len1 == len2 ? 0 : 1;
+			return len1 != len2;
 
 		if ((c1 = *n1++) == (c2 = *n2++))
 			continue;
-- 
2.37.3

