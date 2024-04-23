Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962A5143C46;
	Tue, 23 Apr 2024 21:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908681; cv=none; b=CA7HtnK0Yi7uY1cqD9iSivnndOrvvbzzReAqKC3c2PIzzSPoSZRFDKpNTQEMyLifqwFmqK4SUH7lc0/TioW6+mRpaYTxfyQzVWDyDLdmuC46os1qJBT1Onmjbh0W4Nr+4BA+mXGDY9ieYIC9d0cTUsAbCTOY5gD2w2gc2nOV0yQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908681; c=relaxed/simple;
	bh=/GCgFnWs3e4LZnhej04tqCkSBUoKo6lICXlY/qv4ITg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rm7z2naRznJKDlBeAQn2e/8O3WzUTazaRLdZLApKhLvmc8+H4zfw9zjrZe2h/hevLZxVF+Tx4kSyqaYxod55L/SSu5d3ldTp2aQ6r3wBzuGFZBEk3xJJpb5b/NV9953O7XGv/kl7SC1XPlCkdHEOZjyUAyHEi0HSF+EPhGXS4+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W8HD5JXA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W8HD5JXA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A31C3277B;
	Tue, 23 Apr 2024 21:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908681;
	bh=/GCgFnWs3e4LZnhej04tqCkSBUoKo6lICXlY/qv4ITg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W8HD5JXAbBiRV2DzbJ/rtfnf1aXG1B4aQV1hvGd45H2nZjNA+ime1i1Y+8AXS+9o2
	 Tl3qv48/LavmQeijEov/UhDEhj9NGpI8XyBiD4vOu8sS6jAl5+u6m5MFWGYdSmJzS9
	 QroApxRubc8kyOfyuiaYPz361/cft0vFHdwiMe0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 007/141] selftests/ftrace: Limit length in subsystem-enable tests
Date: Tue, 23 Apr 2024 14:37:55 -0700
Message-ID: <20240423213853.592948142@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -18,7 +18,7 @@ echo 'sched:*' > set_event
 
 yield
 
-count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -lt 3 ]; then
     fail "at least fork, exec and exit events should be recorded"
 fi
@@ -29,7 +29,7 @@ echo 1 > events/sched/enable
 
 yield
 
-count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -lt 3 ]; then
     fail "at least fork, exec and exit events should be recorded"
 fi
@@ -40,7 +40,7 @@ echo 0 > events/sched/enable
 
 yield
 
-count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -ne 0 ]; then
     fail "any of scheduler events should not be recorded"
 fi


