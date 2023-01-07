Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA6FEA1
	for <patches@lists.linux.dev>; Sat,  7 Jan 2023 14:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10682C433EF;
	Sat,  7 Jan 2023 14:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1673102288;
	bh=+AcQ9WJVPan1G0rYOTucA63bgMfL6ndtCecaiiPwGU8=;
	h=From:To:Cc:Subject:Date:From;
	b=WnUbZ1JQ+9BIe/fAr06jMYtSbfOig2tcyMdMKe4zZ0R27tWtJUUWP/tQfwOe7bOGm
	 QVVGSdrvLKwX0SfMz44PycAY1bwwM/ggYSCbqV73oG4ipDOuX+JHoXdHKpv8Bns9Z2
	 0mHaM3GhllUdFwdGU2fwElTLLX6nVZc6jG2/5hcKKE6gzqi/CE0GKaVZO9jPbMNe1c
	 1w2hUw4rXJx55itSrDyTHLvdXYqAaPD0vv6aK5RYD4anubeZtlPnS9N73ffbYJ6OYA
	 XQv9iNvE6YXOmxCB86HqdscMt9AHKF9cVCa9PtpxO8GPdeNc4BA+7ZTUstluvWPWEO
	 XawH9Xlz44jlA==
From: ojeda@kernel.org
To: Masahiro Yamada <masahiroy@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	linux-kbuild@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nicolas Schier <nicolas@fjasle.eu>
Subject: [PATCH] docs: kbuild: remove mention to dropped $(objtree) feature
Date: Sat,  7 Jan 2023 15:37:47 +0100
Message-Id: <20230107143747.64802-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Miguel Ojeda <ojeda@kernel.org>

Commit 8d613a1d048c ("kbuild: drop $(objtree)/ prefix support
for clean-files") dropped support for prefixing with $(objtree).

Thus update the documentation to match that change.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/kbuild/makefiles.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/kbuild/makefiles.rst b/Documentation/kbuild/makefiles.rst
index 6b7368d1f516..38bc74eaa547 100644
--- a/Documentation/kbuild/makefiles.rst
+++ b/Documentation/kbuild/makefiles.rst
@@ -1042,7 +1042,7 @@ $(clean-files).
 
 When executing "make clean", the file "crc32table.h" will be deleted.
 Kbuild will assume files to be in the same relative directory as the
-Makefile, except if prefixed with $(objtree).
+Makefile.
 
 To exclude certain files or directories from make clean, use the
 $(no-clean-files) variable.

base-commit: 88603b6dc419445847923fcb7fe5080067a30f98
-- 
2.39.0

