Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B2AAD55;
	Tue, 13 Feb 2024 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845618; cv=none; b=C/5eKwqcA3OjzdK9CQ89kAnWd8SymeV4LrdCZYYJfTpNAAHEfaMRqScgLwCLCrRCnXRPoC7yOKXx0kjv/cpl2/koX4DKP1lsBvjh4w//DU94z/AJHd//Hmp2fG0JyQ6rFBgUmfnze5l9HQd7xh6iEeX/OZEW/mDoXBuoRAJt8PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845618; c=relaxed/simple;
	bh=MXsLK+V06Uj0SIRMzzloo/8KG+urlFSDPuZKP6jgeyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuWiD/IElp5G1QgLPdpYr6JaRYc2ZLHYjhzqTBIbzt50O5uVqOpRdbigsCSrxXD7cR9fkP+Qv1tDhmjXD+tWTk6j1YvogGnl8+N13ZV+Pg22mqIZsj9ayhBDY5vYW56NyAPJuAB8fSbqxaAf7eb2ZFL+NrsN9YoFV/0DzbC0UWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKEMiK7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKEMiK7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A2FFC433F1;
	Tue, 13 Feb 2024 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845618;
	bh=MXsLK+V06Uj0SIRMzzloo/8KG+urlFSDPuZKP6jgeyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKEMiK7wUNmLFdaeORRg1mCZQx2LVBJhMlozQ6oGWdpiuk3P0ierRb7uo/PyOTRQe
	 Z6+hCKYTVkZ9pLSGL5sLAZEFysDW+EvdG8eNFO29V6YjoN/6JCtHIgjqnLMwfmknNp
	 I9v0Ll+Z7x0lDBDHrJvjPHfCkk7Ax86Fcnor/XtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 010/124] perf test: Fix perf script tests on s390
Date: Tue, 13 Feb 2024 18:20:32 +0100
Message-ID: <20240213171854.034168794@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit 2dac1f089add90a45d93fe8217938281532b86c7 ]

In linux next repo, test case 'perf script tests' fails on s390.

The root case is a command line invocation of 'perf record' with
call-graph information. On s390 only DWARF formatted call-graphs are
supported and only on software events.

Change the command line parameters for s390.

Output before:

  # perf test 89
  89: perf script tests              : FAILED!
  #

Output after:

  # perf test 89
  89: perf script tests              : Ok
  #

Fixes: 0dd5041c9a0eaf8c ("perf addr_location: Add init/exit/copy functions")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Link: https://lore.kernel.org/r/20240125100351.936262-1-tmricht@linux.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/script.sh | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/shell/script.sh b/tools/perf/tests/shell/script.sh
index 5ae7bd0031a8..2973adab445d 100755
--- a/tools/perf/tests/shell/script.sh
+++ b/tools/perf/tests/shell/script.sh
@@ -54,7 +54,14 @@ def sample_table(*args):
 def call_path_table(*args):
     print(f'call_path_table({args}')
 _end_of_file_
-	perf record -g -o "${perfdatafile}" true
+	case $(uname -m)
+	in s390x)
+		cmd_flags="--call-graph dwarf -e cpu-clock";;
+	*)
+		cmd_flags="-g";;
+	esac
+
+	perf record $cmd_flags -o "${perfdatafile}" true
 	perf script -i "${perfdatafile}" -s "${db_test}"
 	echo "DB test [Success]"
 }
-- 
2.43.0



