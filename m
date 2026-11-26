Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705270;
	b=oJIhxV0oxjNTJZbD4unMPTNnnYXzl/fVh/ChgGEmeyDIm7xvkQK/yVx6MyT3OrlY5fSM
	 CdoYcKMPB4b07+9joVOU8YEDBp08ZNX4O3x1MGmUC7E6Ti5CStTVrCgnftwGNbMjjO2GF
	 8Z/gsqt7Ezrs3gTMnHTe4wtfq7rNivVyCfUnrE0aOOBJztVr0Chif5jziyG3IBQBifwwV
	 z2jT9uD7gjnE4619UgmWEeu1D2PfmhLhBsTuxBxZEPBXK3X9axQyrudVdVOvgmNqChWTG
	 m1Z05Nmd8zYVwPzYJnFP3ee3hG4PGtv6HFrl2LdUymLUmXwQPIax18eMLBduVi4iWoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3KasY2i+fVn4Sd8B5Boj+DLAnMITmpuydOJ+q/4GMtU=;
	b=X+AFmGq/DtpDzd9wFNKSJM6h/wn6kEAbB2jBJIazIkfjFghHiZ7vRV11qRbN+OAIQIGo
	 b45yCCOjNeepWQrv6LCdtCkIx0Pa4y/87ds4b1hQkp4c5Nyhu6Ay0Fpdc2vkZgd0V25ly
	 E5lMxxKUU9WYmfPB+Nf95jghlvVVAo3o73Ttpl4SaVQx1u0hTm1XQc3ujEnSNIixezJJ2
	 SYSMoTCXLgs5K/prg3ndCNDs2gaSVYHy5kpDfetVt7Z8MEgjZaq+o8sna3aVj/2l5uW/E
	 gXyz2wGtO14nCvyP/NTVUBR88m0YfQGukD6w7hNyQfZVqmonhJ9UQ2JDYbQy5atclzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="2ECP8Iz/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D722A606A31E;
	Thu, 26 Nov 2026 15:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ECP8Iz/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249511F000C0;
	Thu, 26 Nov 2026 15:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705270;
	bh=3KasY2i+fVn4Sd8B5Boj+DLAnMITmpuydOJ+q/4GMtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ECP8Iz/HYY2Ba05rgJbyCmXoDSrjTQhbsuWjJRxOaQUI4C1T3nKPstaYkAh3zsAz
	 Eqju0Q/bKi7iHHI4SKcZFUq4JCyFwMqL8riEyckhQdpl4ofmDJVKdt2xq+xgrZ4fIc
	 CKHnUxx3wGdM6sZYYS+aogSasgbzygm5VKBaekHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/319] team: Add matching error label for failed action
Date: Thu, 26 Nov 2026 15:38:30 +0100
Message-ID: <20261126144009.953545053@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/team/team.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 64f8215fc2f16..359eca9f75e10 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -1307,7 +1307,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		if (err) {
 			if (dev->flags & IFF_PROMISC)
 				dev_set_promiscuity(port_dev, -1);
-			goto err_set_slave_promisc;
+			goto err_set_slave_allmulti;
 		}
 	}
 
@@ -1334,6 +1334,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	return 0;
 
 err_set_dev_type:
+err_set_slave_allmulti:
 err_set_slave_promisc:
 	__team_option_inst_del_port(team, port);
 
-- 
2.53.0



