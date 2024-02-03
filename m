Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A457417588;
	Sat,  3 Feb 2024 04:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933980; cv=none; b=lLjfPmPlle5+K1yBkVQfJA/a1melrzlUxDR1jtrBqVZXysXrkjCWHt8MMyIlgnm7T9PTwBa/UPp0CqgfTo8VgY9GjldkQvwdcC+XzVIUziLOjljuxTlwGp1JK8U79FHB1ixb5ynI271Q6kkkm2HinXEcN6hS+5R/VkVRm8PmW7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933980; c=relaxed/simple;
	bh=SgiSVc67PW6Qij/D8RIAcvymZNM/1fJw0yGNvjVDF44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XsXYG3vB98UvdPJoLtnqgy8KkicHMPa5Gphzh8kP5WuISxcN1pjN3VlTB2HjecGEB5okR3GyAPufNB2dM3reqGpcskvcTYJwYchkBjYf9790wiJTICCVtqoge0vHnNvkUKyHb6N0mdZoL0TJU+lE3dVI75ft8DegPXr7+wGxXak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amKrs69y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amKrs69y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD57C43394;
	Sat,  3 Feb 2024 04:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933980;
	bh=SgiSVc67PW6Qij/D8RIAcvymZNM/1fJw0yGNvjVDF44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=amKrs69ySxrUBsQqda/j0l1WgQRVzKAjcji50jm106Ubyh9rVr6j5DaXmz1GZF40G
	 Vgl72c7wbauhvb9nxC+zLENncDmvmAPpH9S7GFTXn5VOZSG0bt7ZdLeHTohIpWDjig
	 JnCy1OfJcSiC1PnWzso2VqA/4CrwGo2KOdn+V7ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 337/353] selftests: net: add missing config for nftables-backed iptables
Date: Fri,  2 Feb 2024 20:07:35 -0800
Message-ID: <20240203035414.442557616@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 59c93583491ab15db109f9902524d241c4fa4c0b ]

Modern OSes use iptables implementation with nf_tables as a backend,
e.g.:

$ iptables -V
iptables v1.8.8 (nf_tables)

Pablo points out that we need CONFIG_NFT_COMPAT to make that work,
otherwise we see a lot of:

  Warning: Extension DNAT revision 0 not supported, missing kernel module?

with DNAT being just an example here, other modules we need
include udp, TTL, length etc.

Link: https://lore.kernel.org/r/20240126201308.2903602-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f7c25d8e17dd ("selftests: net: add missing config for pmtu.sh tests")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index dad385f73612..77a173635a29 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -62,6 +62,7 @@ CONFIG_NET_SCH_HTB=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_ETF=m
 CONFIG_NET_SCH_NETEM=y
+CONFIG_NFT_COMPAT=m
 CONFIG_NF_FLOW_TABLE=m
 CONFIG_PSAMPLE=m
 CONFIG_TCP_MD5SIG=y
-- 
2.43.0



