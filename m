Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE5A14A4E7;
	Tue, 17 Dec 2024 17:22:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456177; cv=none; b=gduJFL5bAHeb1r+T6JShrxqjp6tKTlFfBgHzP3NH/t12Qpq6R5atTNfIQmwPqQ26UcxgB+kJi/hWRp03+inohtXAjDi+mAf5jgGB8UO4+qC1IreSGgFAm44v6iBZF1rmJSyy3z7BZPxsgIk1KWF489sW54hTf8vpqiYVc10trgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456177; c=relaxed/simple;
	bh=n0ZJS07MXK4KsZiHMCcYzqfPAigBuHwUKzm4tfYNgH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzeacz4tpBYj20jGr+ZmYkXkb8P0wkYKuCk7iDcFf2YU94F2rFTmF50hOGKOMPngYP6l9K9TU+s34Lii//0UKtYVfHGNJq0Z52+yLG4PJSDvZzAWwNWHAPXapnhFduTysYCcpkisbPxmplIwKyMd/dFq9gxCsAcbzMFRwH4jaLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Una4ufDd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Una4ufDd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D20CC4CED3;
	Tue, 17 Dec 2024 17:22:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456177;
	bh=n0ZJS07MXK4KsZiHMCcYzqfPAigBuHwUKzm4tfYNgH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Una4ufDdSuALjTkhu7ffxLY3Ku7w1CnAoJxm9i8E/fJe3ttnUWkvQeAkU6plV8IRq
	 SOf1kiSs4E/4mwLfuxJEmtgiPbioEY51HP6fp0cnYcooNdb24e6oadepQ6V2mchh4A
	 UTpET/OwSAZtP71EzPPpxGwFqAJeR3AZfJEjyO+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@idosch.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/109] team: Fix feature propagation of NETIF_F_GSO_ENCAP_ALL
Date: Tue, 17 Dec 2024 18:08:08 +0100
Message-ID: <20241217170536.887903948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170533.329523616@linuxfoundation.org>
References: <20241217170533.329523616@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 98712844589e06d9aa305b5077169942139fd75c ]

Similar to bonding driver, add NETIF_F_GSO_ENCAP_ALL to TEAM_VLAN_FEATURES
in order to support slave devices which propagate NETIF_F_GSO_UDP_TUNNEL &
NETIF_F_GSO_UDP_TUNNEL_CSUM as vlan_features.

Fixes: 3625920b62c3 ("teaming: fix vlan_features computing")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Ido Schimmel <idosch@idosch.org>
Cc: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Link: https://patch.msgid.link/20241210141245.327886-5-daniel@iogearbox.net
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index f575f225d417..ae257fa43d87 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -982,7 +982,8 @@ static void team_port_disable(struct team *team,
 
 #define TEAM_VLAN_FEATURES (NETIF_F_HW_CSUM | NETIF_F_SG | \
 			    NETIF_F_FRAGLIST | NETIF_F_GSO_SOFTWARE | \
-			    NETIF_F_HIGHDMA | NETIF_F_LRO)
+			    NETIF_F_HIGHDMA | NETIF_F_LRO | \
+			    NETIF_F_GSO_ENCAP_ALL)
 
 #define TEAM_ENC_FEATURES	(NETIF_F_HW_CSUM | NETIF_F_SG | \
 				 NETIF_F_RXCSUM | NETIF_F_GSO_SOFTWARE)
-- 
2.39.5



