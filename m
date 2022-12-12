Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8392628ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D975DC433EF;
	Mon, 12 Dec 2022 13:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851080;
	bh=8LYAV81/wBfJ17AaJz8wLLoRXhnwoBMpkT+3u1q2wto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPvBsBhzxX4KsbBL/Yo3YL0f7PfdCHd8BQ/cvsuRVDEfD/3qQJDrHJ2A5gvbtjT0N
	 FDSB/eNvsPEmwpBunWrF21YbyYE3z4CJi5wQMWbM0Uag1It4whnv/B8HT8OZNxiMfB
	 lFVdW7LGwK2G9k7V6wropbK5kDMis4RH98rVDmfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emeel Hakim <ehakim@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/106] macsec: add missing attribute validation for offload
Date: Mon, 12 Dec 2022 14:10:48 +0100
Message-Id: <20221212130929.442254487@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130924.863767275@linuxfoundation.org>
References: <20221212130924.863767275@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Emeel Hakim <ehakim@nvidia.com>

[ Upstream commit 38099024e51ee37dee5f0f577ca37175c932e3f7 ]

Add missing attribute validation for IFLA_MACSEC_OFFLOAD
to the netlink policy.

Fixes: 791bb3fcafce ("net: macsec: add support for specifying offload upon link creation")
Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/20221207101618.989-1-ehakim@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 3e564158c401..eb029456b594 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3680,6 +3680,7 @@ static const struct nla_policy macsec_rtnl_policy[IFLA_MACSEC_MAX + 1] = {
 	[IFLA_MACSEC_SCB] = { .type = NLA_U8 },
 	[IFLA_MACSEC_REPLAY_PROTECT] = { .type = NLA_U8 },
 	[IFLA_MACSEC_VALIDATION] = { .type = NLA_U8 },
+	[IFLA_MACSEC_OFFLOAD] = { .type = NLA_U8 },
 };
 
 static void macsec_free_netdev(struct net_device *dev)
-- 
2.35.1



