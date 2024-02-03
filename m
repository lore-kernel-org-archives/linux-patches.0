Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A57171D4;
	Sat,  3 Feb 2024 04:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933941; cv=none; b=oPhfXR2ru6c3JIHgU0DyfgGKDHwF0UonOx/RbcUt5q0BTy/91XUZKcdtw9dVPTWmb9FfXg0lzwX6hpevv2HqRdvmKwcv7NJwhPsGu6ooV24K5PQteyoa9ydXQ8fP1i9OAuWZ+THj2GpCsq8aqJVYRpjuKsyBTHtJATUOjuc3aNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933941; c=relaxed/simple;
	bh=eyBig6eaMNC9nAOexa9donygW1Oj5sTqxSza0s+oVzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hc45ghFBvNMhxmPYq5FSzObgKxAUFINBciyzybkKY2Le5Ng20jHl0AZLGcpWM5dLuJCUYetA8sqeAOmghdj++v9e8yUs7AKvghbUgOPmeyhMhOUhO2fLbQgz9VX6Ufdk/rvXpnfmc8irh6eWKO3CW6gWNxx6zc/v5YF4oUSFLVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Farg2fhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Farg2fhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A362C433C7;
	Sat,  3 Feb 2024 04:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933941;
	bh=eyBig6eaMNC9nAOexa9donygW1Oj5sTqxSza0s+oVzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Farg2fhdZuLY1Y+zWQe8ivRSdvteSy5fUkEuWUPxpzg4rh7q01FRnYeulbF31ukY+
	 FcEf1Qc2z2XT5H1+QCoaRNGIeQtoOlYFabSr9rgZajbAiV/8Lxz4Epq7B84OBfC/NI
	 VK6+8KCtRZm4xd2GQ/M8o4+ag4xdxZOdbc7nKdlA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Aaron Conole <aconole@redhat.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 304/353] selftests: net: add missing config for big tcp tests
Date: Fri,  2 Feb 2024 20:07:02 -0800
Message-ID: <20240203035413.456817915@linuxfoundation.org>
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



