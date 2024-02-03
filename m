Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286A912E46;
	Sat,  3 Feb 2024 04:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933681; cv=none; b=dQcLkWHnWBuXABWkQyuBmUntj/haf4HSvHLRJ+gfZWot83V0QNgN0adKREPlGtgk4iH0rcCy1vCzwGuYV/yQQMrs0/30c+NgxFVeCtRPelTaPSaN7UP+ctfIQwXE+UZ/+tRnGsZGWJyWkLDd4eYU4RloV+BBe+H382kso05vAks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933681; c=relaxed/simple;
	bh=P4QTwk9cGpI4fsuG3r3kMldbnV+tVfBUTKRNlhw34Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yq79gUDfHNGOLtBLR0YGbkRoTjYVz94+NwQ/9sJK9Pt4Yqv5dc4XY77SV3a5DyJOCDCQwsheJ4uj1Z6UkepQmKoXKxepWHcSXtQrn2+MWAdTsLcf18RLFT8cbdirkJGTMaEyT1CLXZtzKkK7ZdWJkHXtCxjCDwdxxNC574zZ9YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i/IY0q+I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i/IY0q+I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85041C43390;
	Sat,  3 Feb 2024 04:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933680;
	bh=P4QTwk9cGpI4fsuG3r3kMldbnV+tVfBUTKRNlhw34Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i/IY0q+IePC/OxgIAAjBU0GfPQM5H2UyrswXfJFxcBhWfSEPh812KfZ1ONjMT9XKQ
	 56CeEepLS0Kk2yLr+/xYU3eIZSpofcIdXCOe3+eVfSfKUk/w5QixZOn5wyZBmTmh8t
	 souUs+m6UY/beJdYOppCr1Y9loAtJi3Xb6V1Lkgo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/322] selftests: net: add missing config for big tcp tests
Date: Fri,  2 Feb 2024 20:06:11 -0800
Message-ID: <20240203035407.957078100@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Abeni <pabeni@redhat.com>

[ Upstream commit fcf67d82b8b878bdd95145382be43927bce07ec6 ]

The big_tcp test-case requires a few kernel knobs currently
not specified in the net selftests config, causing the
following failure:

  # selftests: net: big_tcp.sh
  # Error: Failed to load TC action module.
  # We have an error talking to the kernel
...
  # Testing for BIG TCP:
  # CLI GSO | GW GRO | GW GSO | SER GRO
  # ./big_tcp.sh: line 107: test: !=: unary operator expected
...
  # on        on       on       on      : [FAIL_on_link1]

Add the missing configs

Fixes: 6bb382bcf742 ("selftests: add a selftest for big tcp")
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Acked-by: Aaron Conole <aconole@redhat.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/all/21630ecea872fea13f071342ac64ef52a991a9b5.1706282943.git.pabeni@redhat.com/
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 19ff75051660..413ab9abcf1b 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -29,7 +29,9 @@ CONFIG_NF_NAT=m
 CONFIG_IP6_NF_IPTABLES=m
 CONFIG_IP_NF_IPTABLES=m
 CONFIG_IP6_NF_NAT=m
+CONFIG_IP6_NF_RAW=m
 CONFIG_IP_NF_NAT=m
+CONFIG_IP_NF_RAW=m
 CONFIG_IPV6_GRE=m
 CONFIG_IPV6_SEG6_LWTUNNEL=y
 CONFIG_L2TP_ETH=m
@@ -45,6 +47,8 @@ CONFIG_NF_TABLES=m
 CONFIG_NF_TABLES_IPV6=y
 CONFIG_NF_TABLES_IPV4=y
 CONFIG_NFT_NAT=m
+CONFIG_NETFILTER_XT_MATCH_LENGTH=m
+CONFIG_NET_ACT_CT=m
 CONFIG_NET_ACT_GACT=m
 CONFIG_NET_CLS_BASIC=m
 CONFIG_NET_CLS_U32=m
@@ -55,6 +59,7 @@ CONFIG_NET_SCH_HTB=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_NETEM=y
+CONFIG_NF_FLOW_TABLE=m
 CONFIG_PSAMPLE=m
 CONFIG_TCP_MD5SIG=y
 CONFIG_TEST_BLACKHOLE_DEV=m
-- 
2.43.0



