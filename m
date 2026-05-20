Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812C23D7D66;
	Wed, 20 May 2026 17:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298736; cv=none; b=ELjQnvlO84E492IwgfdAypf1AZp7SB/3P+DbNCYk0N9noTxdiGn3bDlCeMrDjtgLFZlFh6wfYIvjY05k/OviMqQh/NBkV4sgzyHcmXCrFQbWk3cmzr6Xc+UrRLDGjwuxRuR8siDZ2o2xztFtqWiR9VZEL77JV1HUby1CEQixaVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298736; c=relaxed/simple;
	bh=Kq0e7mFnebP7tt7nI0sx6dCdcL1VfabmGiQw2H6t1xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l9+94czYyX3wltVVDpajZJvmcFkrryrIVoGwC1PKJv778tJ3vZeC/m/F9+uy0dMQrq4aQysBCrgauqGGwTVQuDDTqv9lk27SjYXUYoTXTenDlnpZwZ7oxpjWb1j5KM5R5A3CFFgkIS+d5x9Ibwsh+Nuusv3DPsvfyUJbvM4OY6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=REdT10ri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="REdT10ri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E69321F000E9;
	Wed, 20 May 2026 17:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298735;
	bh=s1p9DuCcMdYgtJeOWYr1MO/KZWJEWI5Z/eM08q3OBuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=REdT10ri646Y+yCyJ5WUyDjNJ2Q6EscAVIyz3ukBVWaNPtHaFuLffv02JKTv4507+
	 2tdNqleQnQ3+GigabJyQyeVFar3mLzSRPf1gMPEsgIQGF6hoy619d2GdCNCnbTY6mz
	 MaNYM6JtJwL/72ZpFlFWUkpBH8XneFDK7ZC9gSVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 522/957] perf util: Kill die() prototype, dead for a long time
Date: Wed, 20 May 2026 18:16:45 +0200
Message-ID: <20260520162145.855513073@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3423778e39a56..523550e7d7ed1 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -29,7 +29,6 @@ extern bool perf_guest;
 
 /* General helper functions */
 void usage(const char *err) __noreturn;
-void die(const char *err, ...) __noreturn __printf(1, 2);
 
 struct dirent;
 struct strlist;
-- 
2.53.0



