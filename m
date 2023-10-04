Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ABCB1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMC3As8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADE0BC433C8;
	Wed,  4 Oct 2023 18:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443455;
	bh=mtMO8jaOHgoz362NyVv0zTUXf43Vh/tkBTHlLXtIcbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMC3As8hsLHzyCTHHRs/3O/RYODo4I2Bf+QzOFBNHPLhTKyYCeHx0an45upSB2LAg
	 Z4mwOSnG2Uk7BpXVV+MkYRBMNclAEoQUBAYXBwzZSFa+Y0bwsPcmE6QbWb7Vi8TWPx
	 ET1lAmWMmiJmqyETCoU1NMtYM5XcO+rb2Zh1A3l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Yejian <zhengyejian1@huawei.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 155/259] selftests/ftrace: Correctly enable event in instance-event.tc
Date: Wed,  4 Oct 2023 19:55:28 +0200
Message-ID: <20231004175224.417575019@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

From: Zheng Yejian <zhengyejian1@huawei.com>

[ Upstream commit f4e4ada586995b17f828c6d147d1800eb1471450 ]

Function instance_set() expects to enable event 'sched_switch', so we
should set 1 to its 'enable' file.

Testcase passed after this patch:
  # ./ftracetest test.d/instances/instance-event.tc
  === Ftrace unit tests ===
  [1] Test creation and deletion of trace instances while setting an event
  [PASS]

  # of passed:  1
  # of failed:  0
  # of unresolved:  0
  # of untested:  0
  # of unsupported:  0
  # of xfailed:  0
  # of undefined(test bug):  0

Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/ftrace/test.d/instances/instance-event.tc | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/ftrace/test.d/instances/instance-event.tc b/tools/testing/selftests/ftrace/test.d/instances/instance-event.tc
index 0eb47fbb3f44d..42422e4251078 100644
--- a/tools/testing/selftests/ftrace/test.d/instances/instance-event.tc
+++ b/tools/testing/selftests/ftrace/test.d/instances/instance-event.tc
@@ -39,7 +39,7 @@ instance_read() {
 
 instance_set() {
         while :; do
-                echo 1 > foo/events/sched/sched_switch
+                echo 1 > foo/events/sched/sched_switch/enable
         done 2> /dev/null
 }
 
-- 
2.40.1



