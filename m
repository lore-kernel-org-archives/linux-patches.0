Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8B43CFF66;
	Wed, 30 Sep 2026 19:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795647; cv=none; b=r/Svp9oGlbp2v3UoxH1kcqeBjJPDlIGonOPu7ZBw61wOh+cvwG+3TjtBTOB8xXB3SYcURW0+vqFPnsg+mhkTSewKiRvvJR+AVmeBK+CU4y3U0UlccFidXarfkIVHMY0GWvtYGQ/QshadFjunp9eA1K+G1uQStR8K5wFsXdI0+cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795647; c=relaxed/simple;
	bh=7dcSY7AZZzP96J1RqAphU9WeByv07T+wkC+SBouky7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uSfaWCD4u7kltACbxxhBw1C/rFdVEuK0k6e2QVyNTj+gccDATJ4PwHacShGlHm2YL6XFrTxljkMKuDqHsWzhne4Ai/7jCA6Jj4gvUwMZ+5ZIXRWligfIqD49nOygPDsuDNB9J9Z094B6FpvTsbfqMpK/s+HIcDdauZcbEYCAxLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0CN3WpK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0CN3WpK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3B31F000FF;
	Wed, 30 Sep 2026 19:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795645;
	bh=k7s5k7s9G5CCFDzgX7iouuhhQ/qM2EFYe/AZmfhCFPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N0CN3WpK8N/KQLZOyBtbLT2itVE72qy+xDaLPHXyl+v0rC5tku+ai3BMmeyjm1nQz
	 fxgBxb2mO15RqiYUCBhHZpEcqj+w/BV2lC1SAWfSlo+PjuXNYFlxYmwRxjwARud4ko
	 b7yRguGHrT5mn+JL+8o0dcRlYKuOik7ucBKaUmcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nicolas Schier <nsc@kernel.org>
Subject: [PATCH 6.6 0634/1193] scripts/sorttable: Mark long_size as __maybe_unused
Date: Wed, 30 Sep 2026 17:21:58 +0200
Message-ID: <20260930152448.329854800@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 4f73462856576797b8f3c55564a9be99f76dc67b upstream.

When building in a kernel tree prior to commit b055f4c431e3 ("sorttable:
Move ELF parsing into scripts/elf-parse.[ch]") with clang-23 or newer,
which implements a new warning under -Wunused-but-set-variable for
static global variable, there is a warning from sorttable because
long_size is unused when MCOUNT_SORT_ENABLED is not set:

  scripts/sorttable.c:452:12: error: variable 'long_size' set but not used [-Werror,-Wunused-but-set-global]
    452 | static int long_size;
        |            ^

Mark long_size as __maybe_unused to avoid inserting more ugly #ifdef
directives while insuring the warning does not reappear, as the
aforementioned change does not alter the uses of long_size, so it
appears to be coincidence that the warning disappears after this
refactoring.

Cc: stable@vger.kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Tested-by: Nicolas Schier <n.schier@fritz.com>
Link: https://patch.msgid.link/20260831-sorttable-long_size-unused-but-set-global-v1-1-8a96b88697e5@kernel.org
Signed-off-by: Nicolas Schier <nsc@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/sorttable.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/sorttable.c
+++ b/scripts/sorttable.c
@@ -449,7 +449,7 @@ static inline void *get_index(void *star
 }
 
 static int extable_ent_size;
-static int long_size;
+static int long_size __maybe_unused;
 
 #define ERRSTR_MAXSZ	256
 


