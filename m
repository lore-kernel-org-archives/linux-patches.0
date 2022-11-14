Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B98A4C6A
	for <patches@lists.linux.dev>; Mon, 14 Nov 2022 12:55:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3365C433C1;
	Mon, 14 Nov 2022 12:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1668430531;
	bh=JcDojgrwfL4TA+KULbOBYm34OG7//WzQE7SNgUo+RSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FcvyACKvSUZbTX/G5ORlRcAJhmzoZaC3t4QP1Hxg65z/u2IMzvBIHJ8WjNQ5Yuavx
	 w8voL4NQabrRNE1b7xBaB43STvCtAQXXBTi4eqVmOr0KgA6XXeK0r90C2G65BxQYln
	 A79vIfFlvGmTLHLCSIuOm5LMojnLRHFOn3ZVSlzw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donglin Peng <dolinux.peng@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/131] perf tools: Add the include/perf/ directory to .gitignore
Date: Mon, 14 Nov 2022 13:45:24 +0100
Message-Id: <20221114124451.056062594@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
References: <20221114124448.729235104@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Donglin Peng <dolinux.peng@gmail.com>

[ Upstream commit 94d957ae513fc420d0a5a9bac815eb49ffebb56f ]

Commit 3af1dfdd51e06697 ("perf build: Move perf_dlfilters.h in the
source tree") moved perf_dlfilters.h to the include/perf/ directory
while include/perf is ignored because it has 'perf' in the name.  Newly
created files in the include/perf/ directory will be ignored.

Testing:

Before:

  $ touch tools/perf/include/perf/junk
  $ git status | grep junk
  $ git check-ignore -v tools/perf/include/perf/junk
  tools/perf/.gitignore:6:perf    tools/perf/include/perf/junk

After:

  $ git status | grep junk
  tools/perf/include/perf/junk
  $ git check-ignore -v tools/perf/include/perf/junk

Add !include/perf/ to perf's .gitignore file.

Fixes: 3af1dfdd51e06697 ("perf build: Move perf_dlfilters.h in the source tree")
Signed-off-by: Donglin Peng <dolinux.peng@gmail.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20221103092704.173391-1-dolinux.peng@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/.gitignore b/tools/perf/.gitignore
index 8e0163b7ef01..cdb7a347ceb5 100644
--- a/tools/perf/.gitignore
+++ b/tools/perf/.gitignore
@@ -4,6 +4,7 @@ PERF-GUI-VARS
 PERF-VERSION-FILE
 FEATURE-DUMP
 perf
+!include/perf/
 perf-read-vdso32
 perf-read-vdsox32
 perf-help
-- 
2.35.1



