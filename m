Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C403919536
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:30:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2176BC433D2;
	Mon, 12 Jun 2023 10:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565828;
	bh=arxZZynGdZtSjlrkY5dZb15DFXerYNj9uCu9kQ5//s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g+bNDHlmvpKdxyj2RAHm2OR5/u8JpFlWwc5bTZVB0JO4PUo4uCkoy5phc7Y5p0ZhZ
	 82/P30TTHnay9c1l2czvpOXouqfEXW2SookPclKyVaWs2vvOsSAjw3H4y9LqSYT4Mp
	 hI5og0jFPG+70ovx8LRUPkJDX/oyeac7RzZ3asTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 09/23] net: sched: move rtm_tca_policy declaration to include file
Date: Mon, 12 Jun 2023 12:26:10 +0200
Message-ID: <20230612101651.476483186@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101651.138592130@linuxfoundation.org>
References: <20230612101651.138592130@linuxfoundation.org>
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
index 1a6ac924266db..e09ea6917c061 100644
--- a/include/net/pkt_sched.h
+++ b/include/net/pkt_sched.h
@@ -124,6 +124,8 @@ static inline void qdisc_run(struct Qdisc *q)
 	}
 }
 
+extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
+
 /* Calculate maximal size of packet seen by hard_start_xmit
    routine of this device.
  */
diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 435911dc9f16a..fdd4af137c9fe 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -31,8 +31,6 @@
 #include <net/pkt_sched.h>
 #include <net/pkt_cls.h>
 
-extern const struct nla_policy rtm_tca_policy[TCA_MAX + 1];
-
 /* The list of all installed classifier types */
 static LIST_HEAD(tcf_proto_base);
 
-- 
2.39.2



