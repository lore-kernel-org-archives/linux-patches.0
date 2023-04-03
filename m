Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4506FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:49:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2524DC433D2;
	Mon,  3 Apr 2023 14:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680533383;
	bh=DVsWSBvy+EpPeMBt0bjXaMfpsBY6XhGAU0Y/OE6SH4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqV1SnBPgTM4OjORxXcbUr3NGX3cR1bTPKokz1d/0v3o6VIsF54Ek1rCsGhqp6RAe
	 pA+EA/PK0ukudwGAmqmm0iSCjiVMcFl6qsrpqihpa2glKBVMyxppEyOKpVb2uXTpzk
	 Hcp5THLO0dZILkQq1EZXvVwcKBgps4/5AcBXXs8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Raillard <douglas.raillard@arm.com>,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: [PATCH 6.2 163/187] rcu: Fix rcu_torture_read ftrace event
Date: Mon,  3 Apr 2023 16:10:08 +0200
Message-Id: <20230403140421.514623776@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Douglas Raillard <douglas.raillard@arm.com>

commit d18a04157fc171fd48075e3dc96471bd3b87f0dd upstream.

Fix the rcutorturename field so that its size is correctly reported in
the text format embedded in trace.dat files. As it stands, it is
reported as being of size 1:

    field:char rcutorturename[8];   offset:8;       size:1; signed:0;

Signed-off-by: Douglas Raillard <douglas.raillard@arm.com>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: stable@vger.kernel.org
Fixes: 04ae87a52074e ("ftrace: Rework event_create_dir()")
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[ boqun: Add "Cc" and "Fixes" tags per Steven ]
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/rcu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/rcu.h
+++ b/include/trace/events/rcu.h
@@ -768,7 +768,7 @@ TRACE_EVENT_RCU(rcu_torture_read,
 	TP_ARGS(rcutorturename, rhp, secs, c_old, c),
 
 	TP_STRUCT__entry(
-		__field(char, rcutorturename[RCUTORTURENAME_LEN])
+		__array(char, rcutorturename, RCUTORTURENAME_LEN)
 		__field(struct rcu_head *, rhp)
 		__field(unsigned long, secs)
 		__field(unsigned long, c_old)


