Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89614D512
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:38:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12657C433EF;
	Mon, 12 Jun 2023 10:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566317;
	bh=v8B+kOzEEpG+dXC5lHSww7Vti07BD26sIQmkWiiarl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XxWVWY8/OAy0OFRtypHipob+qaq8RFLB8U9bTqU7DzwvGAZ+2O00WxA3Wv8y2kFgL
	 pNXKU6ZOLkp532JAQl6kZV/rDd69p45Qg6u6cWqtzTiAVZoSAjvTWE+tgZU8U6YKie
	 12mvqptKV0c6hgLSLqSRN/ky8fthbh/VJzZyS/Fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 39/91] net: sched: move rtm_tca_policy declaration to include file
Date: Mon, 12 Jun 2023 12:26:28 +0200
Message-ID: <20230612101703.715016521@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101702.085813286@linuxfoundation.org>
References: <20230612101702.085813286@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 886bc7d6ed3357975c5f1d3c784da96000d4bbb4 ]

rtm_tca_policy is used from net/sched/sch_api.c and net/sched/cls_api.c,
thus should be declared in an include file.

This fixes the following sparse warning:
net/sched/sch_api.c:1434:25: warning: symbol 'rtm_tca_policy' was not declared. Should it be static?

Fixes: e331473fee3d ("net/sched: cls_api: add missing validation of netlink attributes")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_sched.h | 2 ++
 net/sched/cls_api.c     | 2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/pkt_sched.h b/include/net/pkt_sched.h
index 9e7b21c0b3a6d..9cd2d4e84913f 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -134,6 +134,8 @@ static inline void qdisc_run(struct Qdisc *q)
 	}
 }
 
+extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
+
 /* Calculate maximal size of packet seen by hard_start_xmit
    routine of this device.
  */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 501e05943f02b..0aca0ecb029bd 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -41,8 +41,6 @@
 #include <net/tc_act/tc_gate.h>
 #include <net/flow_offload.h>
 
-extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
-
 /* The list of all installed classifier types */
 static LIST_HEAD(tcf_proto_base);
 
-- 
2.39.2



