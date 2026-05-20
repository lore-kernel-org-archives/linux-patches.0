Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41CF3FB072;
	Wed, 20 May 2026 18:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302484; cv=none; b=g+EG6Sm7w114z12Y76mIiYm9NhP1Bf2v65A+lABrS78QY7fRJGcOmc5ORHpCTclps6amOlyZT3E9dCtj1j987366vjIR+ERWRcpHzn2SYuqzPuGLsbKy0TIIn/pvDMGD1q3IIskhpElWUqkXSWbr/yO6G0SpAa2BVnqitRPsqjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302484; c=relaxed/simple;
	bh=iYEutHC11KWNs7CwgWkvSe+IeQ4fXTPmopzuPc6uZ5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Th9uTv8dXuxGbEHGdXNY1iWuMEljcVPDFJClgAT5+UQkBeVwYzRSnHlWhmhYu7+qckdYI73tJBtvAvYXWekymJGZG8icb1XrOOniiqLTuJOb/m7QOsCUQLvYj/FslPsHh7J8CMRb5u2iHHprq9DRWtyprjrvpYTmxRd31EA97c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2Qurf2G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2Qurf2G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C98C1F000E9;
	Wed, 20 May 2026 18:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302482;
	bh=n0aUm9Htrmwdvv028BuMfLdusnDb8+yOyYxXxrbeS10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2Qurf2GzDLbvcgrKO9C0vRiinN5CxjpX3x6aEwidHhVcVBIJaRQhMaZIvt4ewNGf
	 kGINpH7MJXBIn/QJjL5eZEgTi0PzyMARJLSHR/t1Q+S75rZcKc0VBC7jJWXBuf34r2
	 6QGHV/6YQFn0V/DKpDqq7IfRQFjO1J9RmPw7ys0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 257/508] perf util: Kill die() prototype, dead for a long time
Date: Wed, 20 May 2026 18:21:20 +0200
Message-ID: <20260520162104.214909804@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit e5cce1b9c82fbd48e2f1f7a25a9fad8ee228176f ]

In fef2a735167a827a ("perf tools: Kill die()") the die() function was
removed, but not the prototype in util.h, now when building with
LIBPERL=1, during a 'make -C tools/perf build-test' routine test, it is
failing as perl likes die() calls and then this clashes with this
remnant, remove it.

Fixes: fef2a735167a827a ("perf tools: Kill die()")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/util.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7c8915d92dca2..d49f66a986ae7 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -25,7 +25,6 @@ extern bool perf_guest;
 
 /* General helper functions */
 void usage(const char *err) __noreturn;
-void die(const char *err, ...) __noreturn __printf(1, 2);
 
 struct dirent;
 struct strlist;
-- 
2.53.0



