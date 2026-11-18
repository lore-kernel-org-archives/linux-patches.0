Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042454;
	b=xfbUiZSXEGMULYLVSlvX9t5+XAnMbxoOxIumxaN9SNKRWryLl6SjanBFZHD9gSdiYoBI
	 Lazzz0dZqM7UjIPtpzpZGNCI/4aqSC/Z5KoCyztNLpfqlgNLQbbwjGTg8L4xNWmdUmMXx
	 QEYbLQw6NSKZ2R+Hm73YGvmFTLYRHAhn7vblZKwDtptccV+d2aPClxhLa4vl2iVt5VYx3
	 8jXVePB2+zBfH+/a3ZVcSIGhH422EIJSWjpFsJ+dzjCHGJBK3K/Gi5E1yXiyJF3MTquvQ
	 4yoZ2EiYS4zKbdETR9AOVjfnNDQR1nFwVFr6IjT5izxUH/+svnWKkucN66/e3e0PomQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SXbcFnk/9MS9LEEdzBgCWrfjVZkGvJDh1wa01NHCgvg=;
	b=JhYxrHlyJnqJbj+3ASJluHOLaDCs0VDePPdra/1FFbzvlmeu8h2X7Kie2LHo5UP0XWao
	 5L1BPIdeQ7owSBe5ogEGn6OkUKUyWC/ebpkNlm4lW867l8qhJpVGuxgMC2oC7G17bNVbl
	 n6Yyuqbcmbll+J8AVfhT6KGFV08st0gTAs/BjBzpu1Uy6AgRvkHmlzcTX8bJEG+9/yfjY
	 QAbRIBSnYY7IMxLSbsLZ63KiAmd6CA2CNrJAsV/1y4UYkCfRaxHBRLsJCNHSWCd3YAEEx
	 qrMgU6+85ZgE8yQWqAPs9pU4giooCSQRe03rrjBjJ0uloX7k87xwW64Te2vl5kenT5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iudT3tun;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 478E5606A31C;
	Wed, 18 Nov 2026 22:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iudT3tun
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7621F000C4;
	Wed, 18 Nov 2026 22:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042453;
	bh=SXbcFnk/9MS9LEEdzBgCWrfjVZkGvJDh1wa01NHCgvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iudT3tunh1ONQkR9+g6sbkyU6W3+coPSbNSTxg8kEkLSANkyh2/6K8WjMoKMLtmjn
	 F5FW/aloS7Rw8Vi6mp2A1x10IzszfRA66oY8IYZVj8DB00K8rWPrFHZsPm9t24/S9R
	 FfUGWX6br+fozDuH/Oy5E9vMWhGq1Gti9Zn+x6xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Cassen <acassen@corp.free.fr>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3176/3318] net/sched: act_api: inherit filter offload flags only on new actions
Date: Wed, 18 Nov 2026 16:03:18 +0100
Message-ID: <20261118150455.106369702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 94026b9ae4c00..12ba6ac27d4bb 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1508,6 +1508,9 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
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



