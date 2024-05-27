Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E30262BE;
	Mon, 27 May 2024 19:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838201; cv=none; b=FxaouOyW9DHOohSRjNhciLWGHZmHIWBq4buBOfkZrf8XO6ruA7Kl6ZFcIlvGIpOWC+jaSvXz7ZVP5aFykdiL7npeAJ3lJLDslGbiL7cwEPtKzHf2cwg1LPlyVbUjf5UJ1KJx1+hXE9DUY++R9yAEriqQ/baEyGKBR1EgEWMmttw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838201; c=relaxed/simple;
	bh=OmWHndwXYWiFz0koXmJsLq4x3LAqJDMosG14tUi6AD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pf41ApfzY7Lc5Zh1Ku1t6VSet9pUcL5xK82Ti2ZPcy9+yLr6hfdqrrjlWB34pUJwJ7UkZbp4Z9GKGXAILGPN0yxZ3sQf4qg+9RGgbv9vMU/hDfmejpuS5VtxHK7G4rTf7yZKf8ced5emgP9z8KQuW/H5IS2itunV5WWZrmaqLkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xc0AcAE/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xc0AcAE/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19C2C2BBFC;
	Mon, 27 May 2024 19:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838201;
	bh=OmWHndwXYWiFz0koXmJsLq4x3LAqJDMosG14tUi6AD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xc0AcAE/dwvfwsrfriGuuctE/MEXWuNF035xMeXnyn/ESYLQdhUvfqFToH8m+VP6H
	 dtYY/SqDxibMR1Mth8N74JO0jaF1+I0d7viP1ineAuvq0dVTDFR27S0bA4x75KpmFc
	 kzvFbmKdtEoJk/WGECRvVnu/+dRJIT0CqxU8UKXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 303/493] selftests: net: add missing config for amt.sh
Date: Mon, 27 May 2024 20:55:05 +0200
Message-ID: <20240527185640.209004815@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



