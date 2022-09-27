Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE19580C
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 13:17:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44256C433D6;
	Tue, 27 Sep 2022 13:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1664284627;
	bh=hX3CkUKsKLDVWEC17HcIKLgPdwRhk2yS/LDQoYcnPnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRILjhA3TPvzVf33OI9eCns81BmwnAc9vVP28r9Ppt+pneIV0AkyAmKLmNnJsY53R
	 dMnJQ3HvpXI/jD6zgvoiiixn338BCTX++V0nS/2ew+y1Bnapu+kgDSJwkQ5WWGzPC8
	 NtEswBzBALZNCri1un+KHB4f2PgTch5A20MqOrqPrR9x1Gtw6jCxOQ9yWsrHwC+kuJ
	 s/KG1QnC+1ftR+f6uXGaMCICOZX276trI+WL38RsDgaGeS2ZO2uwYiO7uHft4MnYzN
	 s++ovNTnSbc7box+ZQUVV+LYalqR+b6WE5XPde1ZBnv8XFE84fhuzxY/xNsfbKAFS8
	 uvWdsDFcuw0PQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	Andy Whitcroft <apw@canonical.com>,
	Joe Perches <joe@perches.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH v10 16/27] scripts: checkpatch: enable language-independent checks for Rust
Date: Tue, 27 Sep 2022 15:14:47 +0200
Message-Id: <20220927131518.30000-17-ojeda@kernel.org>
In-Reply-To: <20220927131518.30000-1-ojeda@kernel.org>
References: <20220927131518.30000-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Include Rust in the "source code files" category, so that
the language-independent tests are checked for Rust too,
and teach `checkpatch` about the comment style for Rust files.

This enables the malformed SPDX check, the misplaced SPDX license
tag check, the long line checks, the lines without a newline check
and the embedded filename check.

Reviewed-by: Kees Cook <keescook@chromium.org>
Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 74a769310adf..b5ed31d631fa 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3616,7 +3616,7 @@ sub process {
 				my $comment = "";
 				if ($realfile =~ /\.(h|s|S)$/) {
 					$comment = '/*';
-				} elsif ($realfile =~ /\.(c|dts|dtsi)$/) {
+				} elsif ($realfile =~ /\.(c|rs|dts|dtsi)$/) {
 					$comment = '//';
 				} elsif (($checklicenseline == 2) || $realfile =~ /\.(sh|pl|py|awk|tc|yaml)$/) {
 					$comment = '#';
@@ -3664,7 +3664,7 @@ sub process {
 		}
 
 # check we are in a valid source file if not then ignore this hunk
-		next if ($realfile !~ /\.(h|c|s|S|sh|dtsi|dts)$/);
+		next if ($realfile !~ /\.(h|c|rs|s|S|sh|dtsi|dts)$/);
 
 # check for using SPDX-License-Identifier on the wrong line number
 		if ($realline != $checklicenseline &&
-- 
2.37.3

