Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06D7813C3F2;
	Tue, 26 Aug 2025 14:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219500; cv=none; b=CVcT8kf1c24OL3Ysly7yaEvJAO4aHTV/Mcd8iY6vov+peKY/KUAxMvbKiy0Xvel62c/dUJKshNVYp7waVVV4Q0GtVf0HrKJjpdS1lRBGotDE54bEpbYmBbe+CYAx5BK91R7SZRp9KN2pqhzQVmS0oy1f02xTU84/Fe48jBnaJjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219500; c=relaxed/simple;
	bh=c6zrUih7j/OAo3rlr3bAMtsN3aK0TufSARZouivXNj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwUi3iLbxv3VyE8upRFjUO6der2ODmb9s846DpRIAB8OBdJaIWVEVFwwmFsLimNTiJX6ta/7w4oH7BVoo4HQsOPdQDLODawOx332gix0VTInfFyZ5AcaDaqyeakEaJPQ+A/HLGtiFPlwCVTEjTza1p0FcRKHdlR1XWe7Da05c30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ep5c982Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ep5c982Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B8A7C4CEF1;
	Tue, 26 Aug 2025 14:44:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219499;
	bh=c6zrUih7j/OAo3rlr3bAMtsN3aK0TufSARZouivXNj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ep5c982ZSg6iOuug6yHk+Ooh0cCGvji1tlu3LLrW/mzFWGz9pWlMx8wZySPuJ24p6
	 rnh6rghMbcS7GTE27PVms46551HfMWD/lu8E8N+4vJf9d+LjpLi4sR8UyKUNsOY3OV
	 uNXKMO4o6P5AT5hF0bIUe6Bd/ugr+YznxeTxZyn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Davide Caratti <dcaratti@redhat.com>,
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Shubham Kulkarni <skulkarni@mvista.com>
Subject: [PATCH 5.4 388/403] net/sched: act_mirred: better wording on protection against excessive stack growth
Date: Tue, 26 Aug 2025 13:11:54 +0200
Message-ID: <20250826110917.740115289@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 78dcdffe0418ac8f3f057f26fe71ccf4d8ed851f ]

with commit e2ca070f89ec ("net: sched: protect against stack overflow in
TC act_mirred"), act_mirred protected itself against excessive stack growth
using per_cpu counter of nested calls to tcf_mirred_act(), and capping it
to MIRRED_RECURSION_LIMIT. However, such protection does not detect
recursion/loops in case the packet is enqueued to the backlog (for example,
when the mirred target device has RPS or skb timestamping enabled). Change
the wording from "recursion" to "nesting" to make it more clear to readers.

CC: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ skulkarni: Adjusted patch for file 'act_mirred.c' - hunk #4/4 wrt the mainline commit ]
Stable-dep-of: ca22da2fbd69 ("act_mirred: use the backlog for nested calls to mirred ingress")
Signed-off-by: Shubham Kulkarni <skulkarni@mvista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_mirred.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/net/sched/act_mirred.c
+++ b/net/sched/act_mirred.c
@@ -28,8 +28,8 @@
 static LIST_HEAD(mirred_list);
 static DEFINE_SPINLOCK(mirred_list_lock);
 
-#define MIRRED_RECURSION_LIMIT    4
-static DEFINE_PER_CPU(unsigned int, mirred_rec_level);
+#define MIRRED_NEST_LIMIT    4
+static DEFINE_PER_CPU(unsigned int, mirred_nest_level);
 
 static bool tcf_mirred_is_act_redirect(int action)
 {
@@ -225,7 +225,7 @@ static int tcf_mirred_act(struct sk_buff
 	struct sk_buff *skb2 = skb;
 	bool m_mac_header_xmit;
 	struct net_device *dev;
-	unsigned int rec_level;
+	unsigned int nest_level;
 	int retval, err = 0;
 	bool use_reinsert;
 	bool want_ingress;
@@ -236,11 +236,11 @@ static int tcf_mirred_act(struct sk_buff
 	int mac_len;
 	bool at_nh;
 
-	rec_level = __this_cpu_inc_return(mirred_rec_level);
-	if (unlikely(rec_level > MIRRED_RECURSION_LIMIT)) {
+	nest_level = __this_cpu_inc_return(mirred_nest_level);
+	if (unlikely(nest_level > MIRRED_NEST_LIMIT)) {
 		net_warn_ratelimited("Packet exceeded mirred recursion limit on dev %s\n",
 				     netdev_name(skb->dev));
-		__this_cpu_dec(mirred_rec_level);
+		__this_cpu_dec(mirred_nest_level);
 		return TC_ACT_SHOT;
 	}
 
@@ -310,7 +310,7 @@ static int tcf_mirred_act(struct sk_buff
 			err = tcf_mirred_forward(res->ingress, skb);
 			if (err)
 				tcf_action_inc_overlimit_qstats(&m->common);
-			__this_cpu_dec(mirred_rec_level);
+			__this_cpu_dec(mirred_nest_level);
 			return TC_ACT_CONSUMED;
 		}
 	}
@@ -322,7 +322,7 @@ out:
 		if (tcf_mirred_is_act_redirect(m_eaction))
 			retval = TC_ACT_SHOT;
 	}
-	__this_cpu_dec(mirred_rec_level);
+	__this_cpu_dec(mirred_nest_level);
 
 	return retval;
 }


