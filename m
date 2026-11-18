Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032929;
	b=RTUnOa5AnlTw7jFgcJ7+VTesPDx9LZfnehILNeuh2DH0C0chu/Cgwf/3NIsembg8U/H7
	 IEd8VXMhQOYrJQNOY702YrpBsu9urL4RyQrvMPkDOlvGISllIkDAD+AdBdRdZR5yFjEki
	 9rl/aGMxW9pFiPGh+XzneE5FfzGXTSsGc21BnKZLgw6qkX281oElqWWkg98Yy/MAIFtDr
	 4ruLEY/7poq/kwaWDxDot3QX6CZvYYeRiD9dXdquMRkCNu4BgSDbrO0EI5oSAv2/xrusL
	 Bf/rQpV28NkRgCnLNACjDPoHfKnPNg5KLUeVzVghgDp9gswek+V93tTSKcuKBCG+R5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UxVOMuSJXY2IMOwEHBe2KrWnW5/LXhKXyukVVKw/FcE=;
	b=kXfWCYg/9pYkHPkhhkcrf57OIUNUHfFaC9orMEEzUn9PAh0PrFu+B2FajqaZ0r9AUhop
	 MfuXNrVm/OWjiph7Nlebu6Wi0axp8wniAmL2ISAKc48Nh/HUhe3IZYcfK9otmVFxDHlef
	 7tZDFu4DvZvqS72cNS+bCNzNtV8MwoTo0JmZjGck08jnDPC80cdgbrv/EbQ0QPUVS5HEP
	 jO2AVB5nLN8mPUBcsf8EjPCeLBC9JivqNVO1saopUbqckjAwx3vJjtZ1wcCneE3UICDpY
	 QHWMG6O2IyQLtv6QOZe5Ha+998GjRb9QBLoNst6JB1y3QZQ6ubp66mAx+bo6b7sh/yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmqtYfZv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95BB606A33D;
	Wed, 18 Nov 2026 20:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qmqtYfZv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4843B1F000C4;
	Wed, 18 Nov 2026 20:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032928;
	bh=UxVOMuSJXY2IMOwEHBe2KrWnW5/LXhKXyukVVKw/FcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qmqtYfZvWKO6rS12rP7sezgiIMALErNjpw73iVxpjLD651FOcDDR/5geAIT2C58Zl
	 nB1vx9WqJpTF0kBRB5MqqGO8yqQ7RViXqsZhXE3LNmFmA64ZYqwFe2UzGFB08lV9mb
	 Ni0hEpyWF/QTtMay6fO1wma3cMirecaorwpUZupE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Cassen <acassen@corp.free.fr>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1585/1756] net/sched: act_api: inherit filter offload flags only on new actions
Date: Wed, 18 Nov 2026 16:01:52 +0100
Message-ID: <20261118150112.988048182@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandre Cassen <acassen@corp.free.fr>

[ Upstream commit 9463e8d8c6922a5aa87f7e4fe6deb4f16925d498 ]

tcf_action_init() gives the skip_sw and skip_hw flags of a filter to the
actions it binds. An action that another filter created gets them too,
they then apply to every filter that uses this action. When a
skip_sw filter reuses the action of a software filter, the software
filter silently stops running it. This happens even when the filter add
fails on a later action. A skip_hw filter likewise prevents a later
filter without flags from reusing the action.

Give the flags only to the actions that the filter creates. The mismatch
check still rejects a filter that reuses an action with a flag that the
filter does not have.

Discovered by manual code inspection after the Sashiko AI review [1] of
a tunnel_key patch questioned how actions get the filter flags.
Reproduced on netdevsim without kernel changes. The egress filter below
runs in software only, since netdevsim offloads only ingress filters.
Once the skip_sw filter reuses its drop action, the last command shows
skip_sw on this action and the egress filter stops dropping packets:

  ethtool -K eth0 hw-tc-offload on
  tc qdisc add dev eth0 clsact
  tc filter add dev eth0 egress protocol ip flower dst_ip 192.0.2.1 \
     action gact drop index 1
  tc filter add dev eth0 ingress protocol ip flower skip_sw \
     dst_ip 192.0.2.2 action gact drop index 1
  tc actions get action gact index 1

Tested with the reproducer and the tc-testing action, matchall and
flower tests.

Fixes: 34d35b4edbbe ("net/sched: act_api: deny mismatched skip_sw/skip_hw flags for actions created by classifiers")
Link: https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20261009051930.3619697-1-acassen%40corp.free.fr [1]
Signed-off-by: Alexandre Cassen <acassen@corp.free.fr>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261021193222.1318333-2-acassen@corp.free.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_api.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 22f840ed11326..3ba2af867a104 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1524,6 +1524,9 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
 					err = -EINVAL;
 					goto err;
 				}
+				/* Other filters share an existing action */
+				if (init_res[i - 1] != ACT_P_CREATED)
+					continue;
 				if (skip_sw)
 					act->tcfa_flags |= TCA_ACT_FLAGS_SKIP_SW;
 				if (skip_hw)
-- 
2.53.0



