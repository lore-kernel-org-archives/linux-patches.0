Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2195A143C7E;
	Tue, 23 Apr 2024 21:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908574; cv=none; b=KcKSUbMtzmJkdT6VE+AFPgL7sIbyqDmDE6akHisi1qrSVtSsqk1DrE8hUiRDeTcW9HZOCmL7HesDc+cnuW9476yKjQELL5ipFLzLHngx0YYCfKgaSCaq6yJ/i155j1KsiLxy5KLluoTXd410r+8awnr38ITNh6WrJXTfxIqeYnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908574; c=relaxed/simple;
	bh=FsMlwNEoFMxcwpt8q8Mc+QStKkZLNBdxSKyOF+4Z9ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NWEBLFdzkZH3N1VwyPeG7ePVRIEv7fA7jy8LCFVITUkoq4SG0wlc+GYz4KAFYU7JEBHq8sMn4Qs8GZLpsxVSw5Raj4C/lG3aNb6JZ5dU92eBYahzjKGe3upIg1RnRuKXqGRgw2yLUp2K/ofIKU40E/lGQfh/vxDSP+g3/3jxpdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCtJ9xdP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCtJ9xdP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB28BC4AF07;
	Tue, 23 Apr 2024 21:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908574;
	bh=FsMlwNEoFMxcwpt8q8Mc+QStKkZLNBdxSKyOF+4Z9ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCtJ9xdPKPy683pE70idxKtkPub96O7ICyH+SoSqKCmYQyt+oWM/W3FdKbiJcRK2j
	 uYEr8QnvYR87RDandE8WpQW6vXWp8w+jvETCJ1LN44Q3e/O10vF59zwbC+VyHMkiDf
	 9uIDtfbfO1BudRfqpPAeuulfX1vFNFxgKHYJtJxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.6 026/158] selftests/ftrace: Limit length in subsystem-enable tests
Date: Tue, 23 Apr 2024 14:37:43 -0700
Message-ID: <20240423213856.595700337@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


