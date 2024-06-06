Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C7D19AA7F;
	Thu,  6 Jun 2024 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683328; cv=none; b=awRQ1lfsnAjTQMGaadLMZn87QuI9yiTQr+1sqEAAA7ydEny4U0uQbvZqNszD4MOmEZdQUFxc5sn02RduuHAoWkD64aIZHeUe+4sRNQWB8z8uoLuRw3ik4BK69tTVRja43sewoiplj7Uj40i6n2kim3vL6tFKravUrK80Iw11ARg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683328; c=relaxed/simple;
	bh=LS3yPtAdbZZlVj45aaWmo7VVyo4dbouIB8GGaAlhwpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9Ll+GIwPoDtunMD5mJ20Q+ot8OS7qlkkFhWui7rZofWyWmJHjo3TCdWjiZ2wWK5zYQjMFSabgLYji4aLO4s755D7ppDJ0l/tLM8fnY++iGnQDjorOdxw72KBeRMLZh68+vF3/vF9DAuQkROFYHjrA2DcWDFcQ4VZHi/G5ueU64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLFQX9Zw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLFQX9Zw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451E9C2BD10;
	Thu,  6 Jun 2024 14:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683328;
	bh=LS3yPtAdbZZlVj45aaWmo7VVyo4dbouIB8GGaAlhwpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MLFQX9ZwfA3GsnbBdiu78yyyYu68kxnBXay+7S/2DF3uqxIPpwbzRJTLgBgD/gars
	 pYvayJIw8IJ9BF9iTfWxD/DgliXe0Zqfaw0DQ8X2+7Mg+AlWQFB00c+i037vG5FTS7
	 kPaE2ZD+GroN58hLJEe5BMdXkukSVx0jnxrBNjRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 239/744] selftests: net: add more missing kernel config
Date: Thu,  6 Jun 2024 15:58:31 +0200
Message-ID: <20240606131740.066442570@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit 02d9009f4e8c27dcf10c3e39bc0666436686a219 ]

The reuseport_addr_any.sh is currently skipping DCCP tests and
pmtu.sh is skipping all the FOU/GUE related cases: add the missing
options.

Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/38d3ca7f909736c1aef56e6244d67c82a9bba6ff.1707326987.git.pabeni@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: c499fe96d3f7 ("selftests: net: add missing config for amt.sh")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 3b749addd3640..5e4390cac17ed 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -24,10 +24,14 @@ CONFIG_IFB=y
 CONFIG_INET_DIAG=y
 CONFIG_INET_ESP=y
 CONFIG_INET_ESP_OFFLOAD=y
+CONFIG_NET_FOU=y
+CONFIG_NET_FOU_IP_TUNNELS=y
 CONFIG_IP_GRE=m
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NF_CONNTRACK=m
+CONFIG_IPV6_SIT=y
+CONFIG_IP_DCCP=m
 CONFIG_NF_NAT=m
 CONFIG_IP6_NF_IPTABLES=m
 CONFIG_IP_NF_IPTABLES=m
@@ -62,6 +66,7 @@ CONFIG_NET_CLS_MATCHALL=m
 CONFIG_NET_CLS_U32=m
 CONFIG_NET_IPGRE_DEMUX=m
 CONFIG_NET_IPGRE=m
+CONFIG_NET_IPIP=y
 CONFIG_NET_SCH_FQ_CODEL=m
 CONFIG_NET_SCH_HTB=m
 CONFIG_NET_SCH_FQ=m
@@ -78,7 +83,6 @@ CONFIG_TLS=m
 CONFIG_TRACEPOINTS=y
 CONFIG_NET_DROP_MONITOR=m
 CONFIG_NETDEVSIM=m
-CONFIG_NET_FOU=m
 CONFIG_MPLS_ROUTING=m
 CONFIG_MPLS_IPTUNNEL=m
 CONFIG_NET_SCH_INGRESS=m
-- 
2.43.0



