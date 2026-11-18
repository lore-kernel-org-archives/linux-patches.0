Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018300;
	b=lyBwl3ZpQXD6FvlavXyUGHcIRYqgoSI17VsZ6WRH1s/PEfvAwEEs1OWn5DOPQcsvu+27
	 JCTwCwbdG1bf2mtNzwxgqrCG6VKOe7SetRVFvMxHXcojdpaUdJNjHoJKVpSz/b+w8AbLo
	 X6sTVb0OCQE3xq0hMG1EEuEvelh/V5jKHbP5y8o94QshW8c0VMuSOsNF1Q01lQB85lhvq
	 9hov58Xj6VEIClBDnP4ugA9Xo4FfrzvBQDh02hxbf+ZOfvdBgmAV/QSzY8a+n5FcvmMKj
	 cloSMUozCz7/F4GmNchgDGM20KVAwjlhRrCG9nNXE5Eb6SBb+eDfAa5K/63OjJPAbIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018300;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2vDABCgL9bE7oMKpFMNfQabAja1vKE1kejSy/A6A9ss=;
	b=P4ALVm2/T1CIZVbPuxR2RgtDIr1LpFLAeXd97ulojV3Adv46BKy7IpQDjXZnpwQuXriW
	 ZAJkLD7hT58mgx/aHEWTiJAISQiSEFBXBQyGTha7OfbU+Xro6k/H5FV2HLAoiaYhzQDfI
	 BavGsZBLsLQDxdLa8TePRElXp0NUC/ZsNEs780ZWzo9OPqT1hO9t6PccITG1jP9nkWGVa
	 M5hunm9lSkJJwwBbE6fC16hZNUQza5zuhgP9bvBlg7wUaw8Pf2tTylM5ME0K73/56VgtZ
	 /d6q5CQ6Z4Jh7wia383dNf2H/pa4lXrzPbL0+ykHn5PSGYMplTA0Xk7uBr+cSswyAPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKF6retV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26EEF606A320;
	Wed, 18 Nov 2026 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKF6retV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312BC1F000C4;
	Wed, 18 Nov 2026 16:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018299;
	bh=2vDABCgL9bE7oMKpFMNfQabAja1vKE1kejSy/A6A9ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKF6retVhQjbGpb0hwQCi3YWJc1ilHQZpnXfp2qfNm2u1Djx1Ndvem/PpQU0RpHt9
	 Z6uKW+9KNrffLntPKX/glXpeiXDL+NPMDmYqIDf/sZxNY4Snz+zMm8jsUmFx8s+Zvt
	 9/M2p9vgxZ/MjhpsgB5NoRCMGF+bW7iTp+98nArc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuho Choi <dbgh9129@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1192/2651] soc/tegra: flowctrl: Release OF node reference on error
Date: Wed, 18 Nov 2026 15:40:32 +0100
Message-ID: <20261118150330.911569577@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 4eaed7ea6ab36e1160d660b05551702c36dfed6c ]

tegra_flowctrl_init() obtains a reference from
of_find_matching_node() and currently releases it only after
of_address_to_resource() succeeds.

Release the reference before checking the resource conversion result so
the error path is balanced as well.

Fixes: 1fd09e5d884a ("soc/tegra: Add initial flowctrl support for Tegra132/210")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/tegra/flowctrl.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/tegra/flowctrl.c b/drivers/soc/tegra/flowctrl.c
index 221202db33130..d5c3af586d31f 100644
--- a/drivers/soc/tegra/flowctrl.c
+++ b/drivers/soc/tegra/flowctrl.c
@@ -195,11 +195,14 @@ static int __init tegra_flowctrl_init(void)
 
 	np = of_find_matching_node(NULL, tegra_flowctrl_match);
 	if (np) {
-		if (of_address_to_resource(np, 0, &res) < 0) {
+		int err = of_address_to_resource(np, 0, &res);
+
+		of_node_put(np);
+
+		if (err < 0) {
 			pr_err("failed to get flowctrl register\n");
 			return -ENXIO;
 		}
-		of_node_put(np);
 	} else if (IS_ENABLED(CONFIG_ARM)) {
 		/*
 		 * Hardcoded fallback for 32-bit Tegra
-- 
2.53.0



