Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571CB17588;
	Sat,  3 Feb 2024 04:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933981; cv=none; b=Et5IoEGMqULsvgffFxWbrrHrsVUNKikIpkVNT180xtV7XyEZnzZDUrw0M7dLX8QM/N0Pfm13Om9GGEn4VKZtCpvhxSHZXfR8Lj5w6o6gOfEsG96lKTB4DXioU4NXHa6rmqAuaAp8O0N3WhFPRw7m4xCngXGMdATHgFhtQPcsBfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933981; c=relaxed/simple;
	bh=NkLG7acjza50NAPPops2avWDk/OFB0LiE9PESaGLIek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrba+Jr6mJoSiwKLuTYQSP7GqprbL2EaQqx7KdK+NfOaxrep56IFoQw+H2ga9n900OYXb2sp3872gf961RyMmGQBD93d3zxy9c20VZlNUE7lOAnCxVbas3BpsOB3jr8NKPiYkzgVZdKF2JsFkPbw75HcgraE+4+rWB+xEnNFAbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XX4fRUVv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XX4fRUVv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5C5C433C7;
	Sat,  3 Feb 2024 04:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933981;
	bh=NkLG7acjza50NAPPops2avWDk/OFB0LiE9PESaGLIek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XX4fRUVvvF5OyW6MrGRrZyTYi7DYDwca3j7ZhNa6+T8ZuWluxwkpxwMp4p2H5EHrw
	 //IrkNeodViHMMX4uxEpyfc+SlJMpLb6sE69YbDjlpGjAYGGcB6Y6Md+CGFsFoBN+t
	 qPXooxkdtT5+N6ReDuXZi9pikW/7wVpWNky6TPRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Guillaume Nault <gnault@redhat.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 338/353] selftests: net: add missing config for pmtu.sh tests
Date: Fri,  2 Feb 2024 20:07:36 -0800
Message-ID: <20240203035414.470977621@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit f7c25d8e17dd759d97ca093faf92eeb7da7b3890 ]

The mentioned test uses a few Kconfig still missing the
net config, add them.

Before:
  # Error: Specified qdisc kind is unknown.
  # Error: Specified qdisc kind is unknown.
  # Error: Qdisc not classful.
  # We have an error talking to the kernel
  # Error: Qdisc not classful.
  # We have an error talking to the kernel
  #   policy_routing not supported
  # TEST: ICMPv4 with DSCP and ECN: PMTU exceptions                     [SKIP]

After:
  # TEST: ICMPv4 with DSCP and ECN: PMTU exceptions                     [ OK ]

Fixes: ec730c3e1f0e ("selftest: net: Test IPv4 PMTU exceptions with DSCP and ECN")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/8d27bf6762a5c7b3acc457d6e6872c533040f9c1.1706635101.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 77a173635a29..98c6bd2228c6 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -49,8 +49,10 @@ CONFIG_NF_TABLES_IPV6=y
 CONFIG_NF_TABLES_IPV4=y
 CONFIG_NFT_NAT=m
 CONFIG_NETFILTER_XT_MATCH_LENGTH=m
+CONFIG_NET_ACT_CSUM=m
 CONFIG_NET_ACT_CT=m
 CONFIG_NET_ACT_GACT=m
+CONFIG_NET_ACT_PEDIT=m
 CONFIG_NET_CLS_BASIC=m
 CONFIG_NET_CLS_BPF=m
 CONFIG_NET_CLS_MATCHALL=m
@@ -62,6 +64,7 @@ CONFIG_NET_SCH_HTB=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_NETEM=y
+CONFIG_NET_SCH_PRIO=m
 CONFIG_NFT_COMPAT=m
 CONFIG_NF_FLOW_TABLE=m
 CONFIG_PSAMPLE=m
-- 
2.43.0



