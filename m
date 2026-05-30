Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 350431C5799;
	Sat, 30 May 2026 17:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161530; cv=none; b=pr8zrliXEnlu8qpeo+fYf9cKhtj8FgWL7cPOQ1D7rH/W0SNOTuQpOimwTfjEp/IJU4M50UnvubpiHdJa2h69BeXbT6BRVoff73cYXceubyEwi3dTPIzWp/JsSWVMtbV99RAdc9rAmG2aDrRYRbEmLEgyQec+tMni185FyyXv7zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161530; c=relaxed/simple;
	bh=xqutCXFy1CU2yu4vATjTXfPBSAFimTU0eRv4ZYq+WHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fdo2fREyPnbhKEHhM6ACPtKMrGycE+x/gYRPORA4BYM5jpAIq5v1Xb5//NQSvpYlkAY52iFu8CJbYoH4u3F9ZqaAU9nRPHSocwXrDYALdiFrFNRuzitYEHG0drxBZwcm4p/Id0kbTbVrSxfCcmP/92gx/rrG95TRsDNyMFq67YY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HVKSojg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HVKSojg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD4D1F00893;
	Sat, 30 May 2026 17:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161528;
	bh=L4kr/nErAOHS9h+nb8wrB1a8yOYWr6tHjzGjIJZ0eP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HVKSojgrm3t5lt15yR87qwg0voSb5e3TDlDg+TRp5O58ANd+gzkazKXL4gPXz7aw
	 hGbFuvbi0lqVpiovUGBjLBCLoqk3k0T5pPwNoalFy+8wVPIUG1HlAai9FNQbWjaZer
	 jYZv2nlbdnK/eBADE2l/PY1HURpskYUaTI2Ojnzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 633/969] perf util: Kill die() prototype, dead for a long time
Date: Sat, 30 May 2026 18:02:37 +0200
Message-ID: <20260530160317.929744389@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c1f2d423a9ecb..bdb6d5e7102db 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -17,7 +17,6 @@
 
 /* General helper functions */
 void usage(const char *err) __noreturn;
-void die(const char *err, ...) __noreturn __printf(1, 2);
 
 struct dirent;
 struct strlist;
-- 
2.53.0



