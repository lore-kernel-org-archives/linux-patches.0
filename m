Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027959;
	b=uH1Qe0p3wIyCQ4PeM23vNrNb8L3pOeDmQUzxCtvQwvdwneuwu5yvFFxnnT3k1phG7gdu
	 IbvuOihDlUakO5O7cqxTpe5aJqO9itz8JT4CGfYBwo5JBdAuG8Q/gRBQgBjZGF00xgdDc
	 IhTbvsc00vt9oUkdEGz2y5+LFCBJNLYB2ynKVa7/1ZsO/cBRSQe0F9jcCKnqbl1bjeCi9
	 vdx6+rspficvTQo+gAPuhu+s4qwWvT7nQCv1pFRIAt4D30DVbOZII6vSjmBe+kDVvXVDn
	 1eSiDjgjJNdZUr2iFOg/5czTZ0XSDKsB/vsXnQsbpPAZZZPkwD8syasg5C1GRwGM+vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gTjQSRU8bSOQ0KLqO/fSJNZHHIlNEs+MCcvCSKzwRCs=;
	b=jXW1VdkjSF60p6r3kKfmwJXmPfiIj0BRBq8J35JJxT9we0YVdNAp5XCmRPnAR+YpRCAJ
	 MRKCHSoE+0srwkzY9yrEah6AwbeHQS4ANtYB1hG3MxWiv8yyltBPYqErF4/uDRaVbWBYZ
	 BSKP+BZ8FNIwfoWrAZPMwlOfMMn+/g1MFyRoIFdSI9ICqPBOIsZQ0CyTjkFjKVV6yBgCC
	 r1KwHMg/UCnx+3qq3oivU7ht9+q1BOWm8oQu5DsoK2mACKZskm5SeLwsHoYml+6tI7yAa
	 yB3lDc7VxDowrxBy5axHr8oYoojBMQFsIFau4FGFW5+Atvn0Ez9N9RL/9sovWXlYwRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="iYaqah/a";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0C8606A31C;
	Wed, 18 Nov 2026 18:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iYaqah/a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B4F51F000C4;
	Wed, 18 Nov 2026 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027959;
	bh=gTjQSRU8bSOQ0KLqO/fSJNZHHIlNEs+MCcvCSKzwRCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYaqah/al946Qqg1jbdHlNKInKVY6vr4RhC9FM47MdFrs8reOuy2qzOXkoKliHqr9
	 w99K3lV9sd1Q18PMrJeVqeoF47sQggM7CZaSKrJughWqA6wA2tcgIE7rKvFS+UQoue
	 iNn2y+30eBMrsIOGCYr1ltFy9ExTpsCx/4O2HRzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Cassen <acassen@corp.free.fr>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1974/2151] net/sched: act_api: inherit filter offload flags only on new actions
Date: Wed, 18 Nov 2026 16:01:49 +0100
Message-ID: <20261118150233.650515712@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0494b31bfcabe..6f9ad397050fa 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -1544,6 +1544,9 @@ int tcf_action_init(struct net *net, struct tcf_proto *tp, struct nlattr *nla,
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



