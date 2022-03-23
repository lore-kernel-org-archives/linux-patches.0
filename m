Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FBEA6AB9
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 23:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B31C340E9;
	Wed, 23 Mar 2022 23:06:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648076763;
	bh=LpUvGqO6zTZezH5GVCSw/IQF4F8xd0thXDv9IcXhyMg=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=lpIm9UDMExd6lxgBAxCqgbup2pPH+mpGGz0YwvpB66wz5zjrQ06Nseg/8D+SH/bRG
	 g1bs2xjrGVkduqKaLZDaoB+52vQrRKhh99nu9bj3M5rd2g0eyYZ75TihbIr6SR+2/I
	 C2HKX9JzY0JYt5aeDFtD7DHe6EQi/VfbUwOIXeEE=
Date: Wed, 23 Mar 2022 16:06:02 -0700
To: lukas.bulwahn@gmail.com,dwaipayanray1@gmail.com,joe@perches.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 15/41] checkpatch: add early_param exception to blank line after struct/function test
Message-Id: <20220323230603.47B31C340E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Joe Perches <joe@perches.com>
Subject: checkpatch: add early_param exception to blank line after struct/function test

Add early_param as another exception to the blank line preferred after
function/struct/union declaration or definition test.

Link: https://lkml.kernel.org/r/3bd6ada59f411a7685d7e64eeb670540d4bfdcde.camel@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/checkpatch.pl~checkpatch-add-early_param-exception-to-blank-line-after-struct-function-test
+++ a/scripts/checkpatch.pl
@@ -3926,7 +3926,7 @@ sub process {
 		if ($prevline =~ /^[\+ ]};?\s*$/ &&
 		    $line =~ /^\+/ &&
 		    !($line =~ /^\+\s*$/ ||
-		      $line =~ /^\+\s*EXPORT_SYMBOL/ ||
+		      $line =~ /^\+\s*(?:EXPORT_SYMBOL|early_param)/ ||
 		      $line =~ /^\+\s*MODULE_/i ||
 		      $line =~ /^\+\s*\#\s*(?:end|elif|else)/ ||
 		      $line =~ /^\+[a-z_]*init/ ||
_
