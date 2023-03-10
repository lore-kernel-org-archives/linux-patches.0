Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D87C8489
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FDBC433EF;
	Fri, 10 Mar 2023 14:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457900;
	bh=U3i1RJQwvFWKC+wTdZSVlgAf3c98rYi+a/wZUZmMj8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ocKMJ352MIlsRs+qnjOqcdcJVKDjhDxHIhz8y0CNXO5hUw5HkkqqWVynxf2th3yKI
	 6ja517G/l6IySMpc027sn+hPlaxO2jpr0lFlvQxxgpy5NkVRffsZosVsh02MEWHdYo
	 +GrTMayiT1vQKCtbI16RlD3ouACoS3YZDF6SwGmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 097/252] selftests/ftrace: Fix bash specific "==" operator
Date: Fri, 10 Mar 2023 14:37:47 +0100
Message-Id: <20230310133721.755940604@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 1e6b485c922fbedf41d5a9f4e6449c5aeb923a32 ]

Since commit a1d6cd88c897 ("selftests/ftrace: event_triggers: wait
longer for test_event_enable") introduced bash specific "=="
comparation operator, that test will fail when we run it on a
posix-shell. `checkbashisms` warned it as below.

possible bashism in ftrace/func_event_triggers.tc line 45 (should be 'b = a'):
        if [ "$e" == $val ]; then

This replaces it with "=".

Fixes: a1d6cd88c897 ("selftests/ftrace: event_triggers: wait longer for test_event_enable")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/ftrace/test.d/ftrace/func_event_triggers.tc       | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc b/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
index 79d614f1fe8e4..d620223a3f0f6 100644
--- a/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
+++ b/tools/testing/selftests/ftrace/test.d/ftrace/func_event_triggers.tc
@@ -49,7 +49,7 @@ test_event_enabled() {
 
     while [ $check_times -ne 0 ]; do
 	e=`cat $EVENT_ENABLE`
-	if [ "$e" == $val ]; then
+	if [ "$e" = $val ]; then
 	    return 0
 	fi
 	sleep $SLEEP_TIME
-- 
2.39.2



