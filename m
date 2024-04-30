Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D462312C7E3;
	Tue, 30 Apr 2024 10:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473859; cv=none; b=tXXxms/8Dzo159I8odaoIMxzTOSO1N9oePn7NnEYwDWlWaAiD4UFjzuWOdXqN09vvu9YDcV9EG3Wdd+fhe35AqkgWQRzfr7L++5DiElpaOD33jrUwyTWuiAJs/nNkpjQUdZf8IwgmA61U33jggi7EQJlS7yTW1gjlCJ+yHBGlK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473859; c=relaxed/simple;
	bh=6NCaHs8Stm2t94vtII86LXXCn17SnCF8BFZFqkkYVHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GM3Y3hNKsqTLNH3l/tF+oANYNmXes/x8ld7a6B4i27fhNWsj2j4SlTu+jKQjG/0q09iwKkB1pVJAgT9B9KZZx5+bidzxohKCdzBWqdbdJjq3nLrd+bI0ciNULzIuo0m+ZsocLa5O7yhyBkc67ZmyviMuKEIHqExQtH7hapNDxoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHjRQmC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHjRQmC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F325C4AF1A;
	Tue, 30 Apr 2024 10:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473859;
	bh=6NCaHs8Stm2t94vtII86LXXCn17SnCF8BFZFqkkYVHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHjRQmC8Zn4f9yrSaBVJGknanY9/iCEXx1nSNwi0JQTUo1lb126HgzeSoheQOS38c
	 LnQvYp83gkeUeBrsqiPCZhBDE3tg0TBybd/1oiGW0xIskoeccmeb1tTH/HDouSWwSa
	 JyKX8keEY63EhqBJPU+P1oqfIxBhEeFXijvcHNxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 4.19 14/77] selftests/ftrace: Limit length in subsystem-enable tests
Date: Tue, 30 Apr 2024 12:38:53 +0200
Message-ID: <20240430103041.545271869@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103041.111219002@linuxfoundation.org>
References: <20240430103041.111219002@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanhe Shu <xiangzao@linux.alibaba.com>

commit 1a4ea83a6e67f1415a1f17c1af5e9c814c882bb5 upstream.

While sched* events being traced and sched* events continuously happen,
"[xx] event tracing - enable/disable with subsystem level files" would
not stop as on some slower systems it seems to take forever.
Select the first 100 lines of output would be enough to judge whether
there are more than 3 types of sched events.

Fixes: 815b18ea66d6 ("ftracetest: Add basic event tracing test cases")
Cc: stable@vger.kernel.org
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
+++ b/tools/testing/selftests/ftrace/test.d/event/subsystem-enable.tc
@@ -30,7 +30,7 @@ echo 'sched:*' > set_event
 
 yield
 
-count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -lt 3 ]; then
     fail "at least fork, exec and exit events should be recorded"
 fi
@@ -41,7 +41,7 @@ echo 1 > events/sched/enable
 
 yield
 
-count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -lt 3 ]; then
     fail "at least fork, exec and exit events should be recorded"
 fi
@@ -52,7 +52,7 @@ echo 0 > events/sched/enable
 
 yield
 
-count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -ne 0 ]; then
     fail "any of scheduler events should not be recorded"
 fi


