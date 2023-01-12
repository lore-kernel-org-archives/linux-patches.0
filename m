Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CEB379C9
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0465FC433F0;
	Thu, 12 Jan 2023 14:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673533923;
	bh=44UCUkTvfdKe/WgkNW8ccmKuqwxETBrB0CvZk2nEmeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gb7lNyVXA0Xh2fA8kf/OJ4zFRCFNjn5KQNtHc1XqX5QSbQYivxPBhR0dL2KAfnAEl
	 wwrw6lkH70EBqblIHbecot2wYkLYEjxdCoQMESwKqv2JNiQ5gKr5m9q93zt4tsTRAu
	 MTjo7iFzCw/kOtdu6pI3VXbZFByHHsva1HCTUM20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Joel Fernandes (Google)" <joel@joelfernandes.org>
Subject: [PATCH 5.10 606/783] torture: Exclude "NOHZ tick-stop error" from fatal errors
Date: Thu, 12 Jan 2023 14:55:22 +0100
Message-Id: <20230112135552.368658870@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul E. McKenney <paulmck@kernel.org>

commit 8d68e68a781db80606c8e8f3e4383be6974878fd upstream.

The "NOHZ tick-stop error: Non-RCU local softirq work is pending"
warning happens frequently and appears to be irrelevant to the various
torture tests.  This commit therefore filters it out.

If there proves to be a need to pay attention to it a later commit will
add an "advice" category to allow the user to immediately see that
although something happened, it was not an indictment of the system
being tortured.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rcutorture/bin/console-badness.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/rcutorture/bin/console-badness.sh
+++ b/tools/testing/selftests/rcutorture/bin/console-badness.sh
@@ -13,4 +13,5 @@
 egrep 'Badness|WARNING:|Warn|BUG|===========|Call Trace:|Oops:|detected stalls on CPUs/tasks:|self-detected stall on CPU|Stall ended before state dump start|\?\?\? Writer stall state|rcu_.*kthread starved for|!!!' |
 grep -v 'ODEBUG: ' |
 grep -v 'This means that this is a DEBUG kernel and it is' |
-grep -v 'Warning: unable to open an initial console'
+grep -v 'Warning: unable to open an initial console' |
+grep -v 'NOHZ tick-stop error: Non-RCU local softirq work is pending, handler'


