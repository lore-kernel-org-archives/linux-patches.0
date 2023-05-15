Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B839FBEA
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:05:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD49C433EF;
	Mon, 15 May 2023 17:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170317;
	bh=MapsZVpRj1V/QFWIebHTZnskccuSz+6QBhPZx2yRK34=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjTmf38G+FOcvfrtBO770QLtqp/t/AeNohafnvp3BxXNmI0hUH2hlcRzAjzv4LNfF
	 yT4eVQZx5ztZik9lPOtOVfW26ZivEE11WVo4ojERY1XYi5C36WnrA+0SsEHkEaT3Vz
	 0sN6bXkUyG1cS2tOGfI3CHzV4FQq/nAWB8/jpYBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Duroux <patrice.duroux@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 093/239] perf tests record_offcpu.sh: Fix redirection of stderr to stdin
Date: Mon, 15 May 2023 18:25:56 +0200
Message-Id: <20230515161724.460432581@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.545370111@linuxfoundation.org>
References: <20230515161721.545370111@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Patrice Duroux <patrice.duroux@gmail.com>

[ Upstream commit 9835b742ac3ee16dee361e7ccda8022f99d1cd94 ]

It's not 2&>1, the correct is 2>&1

Fixes: ade1d0307b2fb3d9 ("perf offcpu: Update offcpu test for child process")
Signed-off-by: Patrice Duroux <patrice.duroux@gmail.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20230303193058.21274-1-patrice.duroux@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/record_offcpu.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/record_offcpu.sh b/tools/perf/tests/shell/record_offcpu.sh
index d2eba583a2ac9..054272750aa9c 100755
--- a/tools/perf/tests/shell/record_offcpu.sh
+++ b/tools/perf/tests/shell/record_offcpu.sh
@@ -65,7 +65,7 @@ test_offcpu_child() {
 
   # perf bench sched messaging creates 400 processes
   if ! perf record --off-cpu -e dummy -o ${perfdata} -- \
-    perf bench sched messaging -g 10 > /dev/null 2&>1
+    perf bench sched messaging -g 10 > /dev/null 2>&1
   then
     echo "Child task off-cpu test [Failed record]"
     err=1
-- 
2.39.2



