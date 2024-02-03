Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9570F1AAD8;
	Sat,  3 Feb 2024 04:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933711; cv=none; b=P69fkuSWnxej64jzvGtETZ1zk1qUneqqXozVWVpsic/hQ6zJ/pfatLdSQvrfoSmvtfRaBbwj46BOe8Lz1dk1fTroYd4U8FOwUd/8J+4XKdAGrEEd2daBVsr1fFigvMaI0slJA7Antj7EyE24UK5R4Ji8JvwFcra68tgIs+KTrPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933711; c=relaxed/simple;
	bh=Q/ruibSpp1zIeQ0sdCoxpLCW2zveQNjvtUwrRdqj6/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CkmZRPrxjzUyiGCOUK1RRTRHc7lWOYngEb4CqKoxCctyV/pH37YAvzqFNjSfv3QrzaPBg99RjIXV2XOT5NQPotKFztTdvB/m9iAmoh0BupEIzEy4TsagCPBmQRaZWD0N/fsuXKlZPsoAIiUgVIN+lBtAwedfLgcoA4wKJFSDsmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aUGS9O/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aUGS9O/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF6BC433C7;
	Sat,  3 Feb 2024 04:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933711;
	bh=Q/ruibSpp1zIeQ0sdCoxpLCW2zveQNjvtUwrRdqj6/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aUGS9O/C7EL9P8iQ4GSZuR++KWURH8UmbQcB+X/trBZE/KoiNnbLs2VJ19BTIyX1J
	 m+vh9+ZjFO/gWMGkxQVEvWsZ0budIDPNsuarhA94tNIm+E+rVCPybc0r7eDWGHI6ni
	 TJXXjzYp47+D55QqQBn/adGu8QJc0k0EjHiQuJKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 314/322] selftests: net: add missing config for NF_TARGET_TTL
Date: Fri,  2 Feb 2024 20:06:51 -0800
Message-ID: <20240203035409.171752203@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1939f738c73dfdb8389839bdc9624c765e3326e6 ]

amt test uses the TTL iptables module:

  ip netns exec "${RELAY}" iptables -t mangle -I PREROUTING \
  	-d 239.0.0.1 -j TTL --ttl-set 2

Fixes: c08e8baea78e ("selftests: add amt interface selftest script")
Link: https://lore.kernel.org/r/20240131165605.4051645-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 98c6bd2228c6..24a7c7bcbbc1 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -33,6 +33,7 @@ CONFIG_IP6_NF_NAT=m
 CONFIG_IP6_NF_RAW=m
 CONFIG_IP_NF_NAT=m
 CONFIG_IP_NF_RAW=m
+CONFIG_IP_NF_TARGET_TTL=m
 CONFIG_IPV6_GRE=m
 CONFIG_IPV6_SEG6_LWTUNNEL=y
 CONFIG_L2TP_ETH=m
-- 
2.43.0



