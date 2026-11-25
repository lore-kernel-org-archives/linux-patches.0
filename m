Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622112;
	b=Od4lIYB5fzPec5JC1/FHohDunLtIX5c1HUGirQM9lf1X4+29Gh0hTAZaQvzrUEFWzjo5
	 mwgz1ZPnrFJJaKJ/CGw3mtteJEwriZL3gLq+r4spjj9X8Af84aReC5155VvGB1y9H5+8a
	 wIt8UV0gy4bWRMcjs3xqwUEBJL0AwcCUZy+eDgtHw8uTzonnvNUY1TPwYdGxkKpzn6JAF
	 PCAn5Dz3wZ3JST6V1Ggff81/AVn5RnAiftDX3oxOiOgFSpMgfP91U78WruvEFy/i6jztU
	 DLFt3aUBrqZbDClMrij3871VrHRzE8riGZxWzLuBv1ikjC95+CVWbBGbXOzypHkf0/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622112;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EVAGWzK+xd+FySOtBjv8LHHU22XlUdQsrjvELajHEXU=;
	b=FEi7xuCGqjv7cIpVQXonvcDxdb7mgqyjX3neAyiITpdeUSW4pB1SSoigHN7oZeWCPFUV
	 BdwGL8fYABuoqYPQCt/hdVo2u/ptHLbR0/5etLo6r68l6ZHx+ghmTgh6x/bjqEFgbSXNY
	 7gUCwJd69Ej2KBM4WJ1fAghsV7m1WNlAvdU5WmoJsEezY6M/AUGhlBDxmGAHzTQqGY6jH
	 HazgafGPSof5ArhLLO1J41uYG6X3/RVixCpTsxDWNhI/Opp2WLgIo96RwcITdch8Ti2x8
	 teB+LBwpDxrhX0yS0q+WpGPQsdIIauOw0YNfCqr9Z88wAWWGGbMNN/4YiBO74YMlCRg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKzxmdUM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DED606A31E;
	Wed, 25 Nov 2026 15:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NKzxmdUM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED7811F000C4;
	Wed, 25 Nov 2026 15:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622112;
	bh=EVAGWzK+xd+FySOtBjv8LHHU22XlUdQsrjvELajHEXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NKzxmdUMgk23binhQVEjXwup9LIk9cyzsgAREZginF30Om+OBzCITuA74965TbgDG
	 vzaCPfbTjS1W/8gal3XUcQ4k3wS5UPlj+E+OqZM95PedT3lPC9WqPjTFjHooFnp3uy
	 E4FUBVHm8PhJcc7cTQdczj6jlq/0/YwXIGA3oB7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikola Z. Ivanov" <zlatistiv@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 408/990] team: Add matching error label for failed action
Date: Wed, 25 Nov 2026 15:29:35 +0100
Message-ID: <20261125143831.655977700@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 7a189f32c865b..cb0ff3d89de93 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -1260,7 +1260,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 		if (err) {
 			if (dev->flags & IFF_PROMISC)
 				dev_set_promiscuity(port_dev, -1);
-			goto err_set_slave_promisc;
+			goto err_set_slave_allmulti;
 		}
 	}
 
@@ -1287,6 +1287,7 @@ static int team_port_add(struct team *team, struct net_device *port_dev,
 	return 0;
 
 err_set_dev_type:
+err_set_slave_allmulti:
 err_set_slave_promisc:
 	__team_option_inst_del_port(team, port);
 
-- 
2.53.0



