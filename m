Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D42D2DE1E2;
	Tue, 12 Aug 2025 17:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021176; cv=none; b=f4PDLY5H0x5jx7kysGGU5iM6ZVrchSlLHD0E/t59uKCt0ngsT0w2AwXGw0RTvdxjHUM7l0TbpTJmHtQvU3hhIR8BooPXKM8jZmz2GpiuFZxdmQg10pLYzYDSWH8pMJCG+WVDwfPK5NHV9223/6S8Pai8kPo0EXKc3rdo3NxtSy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021176; c=relaxed/simple;
	bh=7mcBqLR9csTgmZGbu6rCAKBxXYogV9hr4ZU9bvbQlRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgn9KCSO5po9FrQfyEho+EuVp6rcu0XukmMpyOuJg+s3Gqh7bKpHpV/CwLgkKL/wVAu636YNEqQ1UWfou4KOkemViBz5usxnJ5Z9K9QTJeFmwEyCW8iyAcgGEd1mH0TmtgOZ8UiQPrPY8TXIZnUkFmbgBtgihbDdpT3G3iuKvok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S2CCgwm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S2CCgwm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319CEC4CEF0;
	Tue, 12 Aug 2025 17:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021174;
	bh=7mcBqLR9csTgmZGbu6rCAKBxXYogV9hr4ZU9bvbQlRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2CCgwm4uxACuFZNMysypVG+zqX4BW6mNqQP1EdISqBWhRPmlpkhX1Saolgdj0aBv
	 20bz6onZS5jDUQd6fhAJJVIfQXyoxIAQgICvWt/3vucNNxylgrrtgamL1Fa9dyIxdu
	 irol7y3QsICdkw8Q1pGhfM0TdQpY8vFmfUqRxfwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Korsnes <johan.korsnes@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 073/262] arch: powerpc: defconfig: Drop obsolete CONFIG_NET_CLS_TCINDEX
Date: Tue, 12 Aug 2025 19:27:41 +0200
Message-ID: <20250812172956.132901129@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Johan Korsnes <johan.korsnes@gmail.com>

[ Upstream commit 75cd37c5f28b85979fd5a65174013010f6b78f27 ]

This option was removed from the Kconfig in commit
8c710f75256b ("net/sched: Retire tcindex classifier") but it was not
removed from the defconfigs.

Fixes: 8c710f75256b ("net/sched: Retire tcindex classifier")
Signed-off-by: Johan Korsnes <johan.korsnes@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20250323191116.113482-1-johan.korsnes@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/configs/ppc6xx_defconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/configs/ppc6xx_defconfig b/arch/powerpc/configs/ppc6xx_defconfig
index eaf3273372a9..80989e3f6780 100644
--- a/arch/powerpc/configs/ppc6xx_defconfig
+++ b/arch/powerpc/configs/ppc6xx_defconfig
@@ -254,7 +254,6 @@ CONFIG_NET_SCH_DSMARK=m
 CONFIG_NET_SCH_NETEM=m
 CONFIG_NET_SCH_INGRESS=m
 CONFIG_NET_CLS_BASIC=m
-CONFIG_NET_CLS_TCINDEX=m
 CONFIG_NET_CLS_ROUTE4=m
 CONFIG_NET_CLS_FW=m
 CONFIG_NET_CLS_U32=m
-- 
2.39.5



