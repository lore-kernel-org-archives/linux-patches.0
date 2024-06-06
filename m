Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A0E1ABE30;
	Thu,  6 Jun 2024 14:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683299; cv=none; b=UjwlADQBoQQFJZh54s03S9YCZXgdq7u2PMkCXJJwIlFPTQxN4ZiBm3Icz3Z6EWMyMR5FxbV4kJ1ACia5uyWBm1GFxvBk0M8j6/TcHdoqop5AH3E7Lv8obp1Efcfqo6t+0l8jfMDMUV42hT2J8RLYH55vZWnZGc45SqpQUU2nmxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683299; c=relaxed/simple;
	bh=//dlDnO1rh7opNB+D/IYLBBQEztYkWDZr4hKqo4HROg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XlY3DZ7MsyGEIJ842/XB5vM/byIRk6wU6tNVCXJ37XxDHaLq+2opTTJFZTvjoxPss+TmU2a6DqiAnZkCrNqNpARvoChunsqYhjm0CRzJb2geg/1iBOTF43+o8cZjVrrZOy0N3bVh3hrxWtCFWnZkt5w8TEbOu7Jm7j9j1nKRe/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1I+sYMZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1I+sYMZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E1CC2BD10;
	Thu,  6 Jun 2024 14:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683299;
	bh=//dlDnO1rh7opNB+D/IYLBBQEztYkWDZr4hKqo4HROg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1I+sYMZNrVxEDhfKNxiey73vtDk5yMA41F/5dk9iLG1gwYfFvDEAcEf1G1LbIzPi
	 l4nlJLnyPACXWa1TgBxdsil1Dn63usLueyn1IBSS+GRnqkMEi+yyqi8hv34Tzs5AkR
	 UE6P/214eydX7+rBPsOuHvOjiCkl4Om12VHzr/sc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/744] selftests: net: add missing config for amt.sh
Date: Thu,  6 Jun 2024 15:58:32 +0200
Message-ID: <20240606131740.099891523@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit c499fe96d3f75a5cf50de6089dd8f1cddd1301a9 ]

Test needs IPv6 multicast. smcroute currently crashes when trying
to install a route in a kernel without IPv6 multicast.

Fixes: c08e8baea78e ("selftests: add amt interface selftest script")
Link: https://lore.kernel.org/r/20240509161919.3939966-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/config | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index 5e4390cac17ed..04de7a6ba6f31 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -30,6 +30,7 @@ CONFIG_IP_GRE=m
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NF_CONNTRACK=m
+CONFIG_IPV6_MROUTE=y
 CONFIG_IPV6_SIT=y
 CONFIG_IP_DCCP=m
 CONFIG_NF_NAT=m
-- 
2.43.0



