Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56161474AF;
	Fri,  6 Dec 2024 15:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497461; cv=none; b=ReumsyquErP+Xp7mQNofPxJoybxsLzwjtDAUdsixip+2ISdsfQ5q89qebAqcYkUZEXC6aSaBqH/Q5x4R4MPFAZA7oL8+Y8vz9B6uxJxEoi+VTPbFF/JPkNZ6xLKaT/dzSwcEDhLy14swQoNgsuK6dA+7ooBw/U1Tyg7DRatJ19w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497461; c=relaxed/simple;
	bh=BV0By347kB+amPq9h3ww1aLVrrMVegAEkeVgl6KP7aA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z1gZEJi4+ZmyGQ3UdPeBRTXIJvHjI8QbIuWQLaMupplPAsuCvKqNkHqudwOunDxVQ3XdyHDokXz31/vmOAwie74EC0GTLNbaKPQAGJTj5SyBZUF2ru5iHoJC1aEFF/id3NR0UAlZ2FPmG6LmYTohoNzKLm701o7xiWBqb2Q/gTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s+QLGMIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s+QLGMIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED15CC4CED1;
	Fri,  6 Dec 2024 15:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497459;
	bh=BV0By347kB+amPq9h3ww1aLVrrMVegAEkeVgl6KP7aA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s+QLGMIbrCSW/Ruv7ayq3/6ul3Cm4JVcjjMAt4miMwo/Pr7tycGhXBfW6Sb5g0c/7
	 FfE7C+e4uawQVmRGh5CbJXundTstmkH1ZgB0V8Yj8Hw62KPb+WslodeJ2HgHbeZmOT
	 Cyx5q11qOVCCt1otg51kb01VLr9wedA/SLISH9jU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@gmail.com>,
	Andy Whitcroft <apw@canonical.com>,
	Dwaipayan Ray <dwaipayanray1@gmail.com>,
	Joe Perches <joe@perches.com>,
	Louis Peens <louis.peens@corigine.com>,
	Lukas Bulwahn <lukas.bulwahn@gmail.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Philippe Schenker <philippe.schenker@toradex.com>,
	Simon Horman <horms@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 298/676] checkpatch: always parse orig_commit in fixes tag
Date: Fri,  6 Dec 2024 15:31:57 +0100
Message-ID: <20241206143704.980937177@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@gmail.com>

[ Upstream commit 2f07b652384969f5d0b317e1daa5f2eb967bc73d ]

Do not require the presence of `$balanced_parens` to get the commit SHA;
this allows a `Fixes: deadbeef` tag to get a correct suggestion rather
than a suggestion containing a reference to HEAD.

Given this patch:

: From: Tamir Duberstein <tamird@gmail.com>
: Subject: Test patch
: Date: Fri, 25 Oct 2024 19:30:51 -0400
:
: This is a test patch.
:
: Fixes: bd17e036b495
: Signed-off-by: Tamir Duberstein <tamird@gmail.com>
: --- /dev/null
: +++ b/new-file
: @@ -0,0 +1 @@
: +Test.

Before:

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: c10a7d25e68f ("Test patch")'

After:

WARNING: Please use correct Fixes: style 'Fixes: <12 chars of sha1> ("<title line>")' - ie: 'Fixes: bd17e036b495 ("checkpatch: warn for non-standard fixes tag style")'

The prior behavior incorrectly suggested the patch's own SHA and title
line rather than the referenced commit's.  This fixes that.

Ironically this:

Fixes: bd17e036b495 ("checkpatch: warn for non-standard fixes tag style")
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Louis Peens <louis.peens@corigine.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Cc: Philippe Schenker <philippe.schenker@toradex.com>
Cc: Simon Horman <horms@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/checkpatch.pl | 37 ++++++++++++++++---------------------
 1 file changed, 16 insertions(+), 21 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 6b598f0858392..6744b58c35083 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -3208,36 +3208,31 @@ sub process {
 
 # Check Fixes: styles is correct
 		if (!$in_header_lines &&
-		    $line =~ /^\s*fixes:?\s*(?:commit\s*)?[0-9a-f]{5,}\b/i) {
-			my $orig_commit = "";
-			my $id = "0123456789ab";
-			my $title = "commit title";
-			my $tag_case = 1;
-			my $tag_space = 1;
-			my $id_length = 1;
-			my $id_case = 1;
+		    $line =~ /^\s*(fixes:?)\s*(?:commit\s*)?([0-9a-f]{5,40})(?:\s*($balanced_parens))?/i) {
+			my $tag = $1;
+			my $orig_commit = $2;
+			my $title;
 			my $title_has_quotes = 0;
 			$fixes_tag = 1;
-
-			if ($line =~ /(\s*fixes:?)\s+([0-9a-f]{5,})\s+($balanced_parens)/i) {
-				my $tag = $1;
-				$orig_commit = $2;
-				$title = $3;
-
-				$tag_case = 0 if $tag eq "Fixes:";
-				$tag_space = 0 if ($line =~ /^fixes:? [0-9a-f]{5,} ($balanced_parens)/i);
-
-				$id_length = 0 if ($orig_commit =~ /^[0-9a-f]{12}$/i);
-				$id_case = 0 if ($orig_commit !~ /[A-F]/);
-
+			if (defined $3) {
 				# Always strip leading/trailing parens then double quotes if existing
-				$title = substr($title, 1, -1);
+				$title = substr($3, 1, -1);
 				if ($title =~ /^".*"$/) {
 					$title = substr($title, 1, -1);
 					$title_has_quotes = 1;
 				}
+			} else {
+				$title = "commit title"
 			}
 
+
+			my $tag_case = not ($tag eq "Fixes:");
+			my $tag_space = not ($line =~ /^fixes:? [0-9a-f]{5,40} ($balanced_parens)/i);
+
+			my $id_length = not ($orig_commit =~ /^[0-9a-f]{12}$/i);
+			my $id_case = not ($orig_commit !~ /[A-F]/);
+
+			my $id = "0123456789ab";
 			my ($cid, $ctitle) = git_commit_info($orig_commit, $id,
 							     $title);
 
-- 
2.43.0



