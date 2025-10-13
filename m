Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE502FB978;
	Mon, 13 Oct 2025 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368947; cv=none; b=a0T6pTsaEScpzerDG0Lr6hhzCgcLDv00Hq27qktpPZKOvDHhkZwBnJydSjJ50hpuoP5Q98ndno5+xQVOkHDfWW4rlurbzfU0J6YQ4qICwWDAN5XOrMHpu0lSFd9ddzYCspqP/nLL/8qE9e1JhWH/kOGI5Lomzjn3ANw5DIC4+MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368947; c=relaxed/simple;
	bh=bnzdAIHK6rM0+b2gIRNM+VCee+BjFwSOeonz2Fb1qYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sNZ9+kqGK6RwCb8SD+da7nLyXqs3rkeUS+EfOq6n/9B9OFK1iZPITHJpA9N5d5h/rc+Gtxo4tS6jYn2W/wZzPW35DvglLGFk3CKezfEXUdz/kNLmPjP72hqftVAkfgpOA6DIIG9s703Qp/fT1BBt9bKgdbqvq9Vg+ilX3fr70DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQMxcSih; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQMxcSih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2A23C4CEE7;
	Mon, 13 Oct 2025 15:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368947;
	bh=bnzdAIHK6rM0+b2gIRNM+VCee+BjFwSOeonz2Fb1qYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQMxcSihA0XevdKjYTTic0iUXUt6eNsDsjHwUwX1OGavn2xM8u2NBiu6q3Ao7TBu0
	 4zbjuSuPOJefs0vsH4CR+RClmplhomwlL/Tqg0dBroE+Mrc/k1zrMmdECjIYhIKfv7
	 3HevWpGrfU2s0P0koJti05hLO+PL37ndrAtMqvo8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 074/563] selftests/futex: Remove the -g parameter from futex_priv_hash
Date: Mon, 13 Oct 2025 16:38:55 +0200
Message-ID: <20251013144413.973968246@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 2e62688d583809e832433f461194334408b10817 ]

The -g parameter was meant to the test the immutable global hash instead of the
private hash which has been made immutable. The global hash is tested as part
at the end of the regular test. The immutable private hash been removed.

Remove last traces of the immutable private hash.

Fixes: 16adc7f136dc1 ("selftests/futex: Remove support for IMMUTABLE")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Link: https://lore.kernel.org/20250827130011.677600-2-bigeasy@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/futex/functional/futex_priv_hash.c | 1 -
 tools/testing/selftests/futex/functional/run.sh            | 1 -
 2 files changed, 2 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/futex_priv_hash.c b/tools/testing/selftests/futex/functional/futex_priv_hash.c
index aea001ac49460..ec032faca6a91 100644
--- a/tools/testing/selftests/futex/functional/futex_priv_hash.c
+++ b/tools/testing/selftests/futex/functional/futex_priv_hash.c
@@ -132,7 +132,6 @@ static void usage(char *prog)
 {
 	printf("Usage: %s\n", prog);
 	printf("  -c    Use color\n");
-	printf("  -g    Test global hash instead intead local immutable \n");
 	printf("  -h    Display this help message\n");
 	printf("  -v L  Verbosity level: %d=QUIET %d=CRITICAL %d=INFO\n",
 	       VQUIET, VCRITICAL, VINFO);
diff --git a/tools/testing/selftests/futex/functional/run.sh b/tools/testing/selftests/futex/functional/run.sh
index 81739849f2994..5470088dc4dfb 100755
--- a/tools/testing/selftests/futex/functional/run.sh
+++ b/tools/testing/selftests/futex/functional/run.sh
@@ -85,7 +85,6 @@ echo
 
 echo
 ./futex_priv_hash $COLOR
-./futex_priv_hash -g $COLOR
 
 echo
 ./futex_numa_mpol $COLOR
-- 
2.51.0



