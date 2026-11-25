Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624806;
	b=YotI4ohDnLQwd3x9+yXqgugPgjy8gNUihb1iSRhxYaHCnj58LwAyB34L2Ksb6ocIffY/
	 hY2qTHJmcefpPivciENU6K8cjdy5V3A3uR4zAKkjJcNC2fJ/fUPceEjt9I5IEZRU5KUF6
	 1Ra0RRXulGpebioOt49tlQMT6TxymCw9yZlQjES4cOil4PZ/wJkC2++QbfasTg7xhOINg
	 q4lWG+i9W+yeeLgQ4/tmns+jlqYEHlfflyz0VEMxX4nbuLYI9TpXYxfaFv/UIsXlANBs+
	 b2TO/fXlvzQbdmJd+ZwmoEvlVk69wXTf4VaKR4hOiRp1bMoWapBdGG4Z6g+AWQxHv4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZSlkTjjrjO+RT5t7/e8DKA5L38BfLcahlWLDA8gSVcM=;
	b=D5blAd1NEtyOCTtg3/jpdtl3qxA2V6XAufdEDjgl7bf/cVfms3dABSRIYhpmRmPDt3lN
	 gmdfUMFV41/seUAZ6VnWaqt9ItizMFk33AFMm6IbHOYiAUba+jb0Pd++sRZnZTR7Ock1p
	 Y0qLn0VNPjoLmMb2f7A70wWNZ8coLXa/5Y4/DiHnQQJiywIaYmsuL1fUWI9hNsdPRdmXe
	 CtZqq4u/84pcBOGbkSeFiEVVKUT6s379ZJL3NWcrnmdN8i9Rj+grFBsus+r2NxWK4lRX2
	 BDv/yPUVS8cIhRcn93kBxXWO00g7sMKLx0HGjnbM1J2apiRmBxNa+ifzoN4Iiv+9sTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DFhYfiLB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666EE606A334;
	Wed, 25 Nov 2026 16:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DFhYfiLB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 668131F000D2;
	Wed, 25 Nov 2026 16:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624805;
	bh=ZSlkTjjrjO+RT5t7/e8DKA5L38BfLcahlWLDA8gSVcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DFhYfiLBeTMnPG+8QFh6sXjWsiAQ7v75wP7qIJAVhub4TVnT46DxVu2aRhFZCNe2y
	 6QqRp2UAi3z1hjOrn/4UGoq4MwRhFtlxsZNYlDel+vv5TbRr7bqavgI1jq7AgH5CMi
	 5gEqpeI1G5LpmNdedG9YXWlQld9lw+Ar6ZNQwnPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 311/816] team: Add matching error label for failed action
Date: Wed, 25 Nov 2026 15:30:59 +0100
Message-ID: <20261125143856.398939762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikola Z. Ivanov <zlatistiv@gmail.com>

[ Upstream commit aee0f01b4f118844cb126a5f27e91c2adf087c59 ]

Follow the "action" - "err_action" pairing of labels
found across the source code of team net device.

Currently in team_port_add the err_set_slave_promisc
label is reused for exiting on error when setting
allmulti level of the new slave.

Signed-off-by: Nikola Z. Ivanov <zlatistiv@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://patch.msgid.link/20251128072544.223645-1-zlatistiv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ff618cb00a64 ("team: fix promisc/allmulti leak in team_port_add error path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 479d5a51152ef..a688f122661d2 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -1316,7 +1316,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		if (err) {
 			if (dev->flags & IFF_PROMISC)
 				dev_set_promiscuity(port_dev, -1);
-			goto err_set_slave_promisc;
+			goto err_set_slave_allmulti;
 		}
 	}
 
@@ -1343,6 +1343,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	return 0;
 
 err_set_dev_type:
+err_set_slave_allmulti:
 err_set_slave_promisc:
 	__team_option_inst_del_port(team, port);
 
-- 
2.53.0



