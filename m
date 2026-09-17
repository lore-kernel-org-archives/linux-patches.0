Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEACB4848B1;
	Thu, 17 Sep 2026 18:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671041; cv=none; b=UaU0O72uspoz1MXq/VFWm5vPN9VCWgtFVn96GK0EuZmJJ1wO85dWQpoaCuxwcsC5kjmayJvM0yGp+DcLH6v4XpXa03pz99w/RhjbYUq3H10ItsONhu0ik2WFw/Ocz1xC+vJT8B/fBldmXggGDIPltUDTRBnmx04cdLN3EYjqrIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671041; c=relaxed/simple;
	bh=3Uv1KHdj2kKanfErcjvQyO6K4K0YSNLrkfHarT8zYOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l1/anaXP/aXk9wHeuFVe2BrH7ynwStrsOoUkIBWBh6ahpVmiqfkciS25U+xdfMelwoY9sGajLcEebpNk47vUPnRO20QIyBjfsqBO8XlpyqWTAaUAuTgjGrkRk2cU4NTIXa1ztDZYi9sr3SiCMWH1at0eOucX9zcJhyUtAcn5trg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLbagi9V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLbagi9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A8D1F000FF;
	Thu, 17 Sep 2026 18:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671039;
	bh=0988Ekr+GwqHNW35iEbvryguOF2p1cxn1CiZ6c7wUfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLbagi9VDdVCxepTd8UhvEEDzwdM+zDVWJJfdaUviTmd0cLtBjGlkNlwqr5aE89Jj
	 cWCGDNjFdoQ6l0JdQ6u0ieYuVTmURXRwF0nDoqPcrn++h1kbCRClQW1bAGHGQw4h04
	 bUixDxfUaw3hRke5LNQ3Xrg+vyCE4m6/SflMam3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <n.schier@fritz.com>,
	Nicolas Schier <nsc@kernel.org>
Subject: [PATCH 6.12 0850/1102] scripts/sorttable: Mark long_size as __maybe_unused
Date: Thu, 17 Sep 2026 16:13:13 +0100
Message-ID: <20260917151601.877650620@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


