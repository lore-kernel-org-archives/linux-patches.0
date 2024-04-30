Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A108801;
	Tue, 30 Apr 2024 11:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476056; cv=none; b=T2HMtEi7xf9C1ZV+yGxSnrBPPxhD6G78MPjkFsnhz/sX2eQPJ7k0w1CB5+d69EOoBm/Z7OFtHF6gTlpfG2mz6KJHPcLI5IMGF/23I2ZsV4ma2L/ZZMmFYRbg3hMPAuF33+aTibLT1uQo+dOC2GJc1JiMJKj3I9XBARIDe8sfIEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476056; c=relaxed/simple;
	bh=BIOB3psQ+Hn+AyIs/Zhl7s7628hHA9TYeWTQA14krj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVq8XkoN76w4I8kisuT26e5vJ+6+DR9JdZ9QDabKFiMHElHCK6o6GJR1RDMlSbxs5R7HEt18NiHtZOaZP2XalDMcK3NYSvG8QlfcV0CrfBrFqU3aw8gaJQ8PS8pSzVlOQIAJU7E7M/yrkGLBJdmLmKJDZ5ckuDCvf06fUcZdrlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOVFGk4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOVFGk4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E66FCC2BBFC;
	Tue, 30 Apr 2024 11:20:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476056;
	bh=BIOB3psQ+Hn+AyIs/Zhl7s7628hHA9TYeWTQA14krj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sOVFGk4L7MsV5JZfHSGbKYEurFM3XADYyPw80z0C0iiLMGcxrSC05d9nB44JcDcCJ
	 A/zVbWK/unY2biYnqudgjkKsQceOduaDwAt3vmOCCjGnRHdYd/K7dbU+SpX79sPzC9
	 F4tdtrMtfsZcpMbvC3GbW7VMzupxiPcID3YM0M0A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanhe Shu <xiangzao@linux.alibaba.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 020/107] selftests/ftrace: Limit length in subsystem-enable tests
Date: Tue, 30 Apr 2024 12:39:40 +0200
Message-ID: <20240430103045.261139315@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -22,7 +22,7 @@ echo 'sched:*' > set_event
 
 yield
 
-count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -lt 3 ]; then
     fail "at least fork, exec and exit events should be recorded"
 fi
@@ -33,7 +33,7 @@ echo 1 > events/sched/enable
 
 yield
 
-count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -lt 3 ]; then
     fail "at least fork, exec and exit events should be recorded"
 fi
@@ -44,7 +44,7 @@ echo 0 > events/sched/enable
 
 yield
 
-count=`cat trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
+count=`head -n 100 trace | grep -v ^# | awk '{ print $5 }' | sort -u | wc -l`
 if [ $count -ne 0 ]; then
     fail "any of scheduler events should not be recorded"
 fi


