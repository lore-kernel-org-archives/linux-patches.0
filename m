Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9D22FDC5E;
	Sat, 30 May 2026 17:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162036; cv=none; b=UQvpeTWK48+CzCghICfzPxJqet/b9skeFZ1rRmf0BAe7qr57RN/Tx/js+GdhXSHQQVwaf8g795JueZjmZojCRFt7DOsTbONlZkbECh4wOvFtK/yO+oWfJTie6zb6hL/oM+U3MUHcBFZDKQ+lQXTBIElQ56OIyxIfs97GAN/i96E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162036; c=relaxed/simple;
	bh=3HIWl3VbHPhwyViKZWdZPvt2fQJvmRJ8cUssomwjWdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YRzwYzWVG8aigqivlSZnW84vnMU0JcjbjU17swdx28wlaa2skjL62yDNx+zdvuIl/8PbTt3xc7jMphhEWXFnhCqNDBIy1j94nIPOLt9Hc+4x94JE9NSj4WSYd4MDvkFEkwQJCMLOXlwQbxhr/HdQIlrccpC1ENci7dcLpbx1GAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UaD23iR2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UaD23iR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DCA1F00893;
	Sat, 30 May 2026 17:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162035;
	bh=prR82i5szzIyy4Lg1Tbftvl4JdzhWOcSirgzfdK2haM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UaD23iR2XHjGr5N3vzx5lmb2WpY5An1fLtRhz+Trq3HEDxni23ZHXMs2Ug2kqn3Pd
	 8I57QoDhb4C1FsUVdzXABenk3hU1W4jwgTJzdoiiM5/8XvwlaoAaQshk3xr94Sgleq
	 61gclBj7eMBrcnefM2GNCNy5vQAiQCU32tvyGcYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Ryo Takakura <ryotkkr98@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 794/969] net: bcmgenet: Initialize u64 stats seq counter
Date: Sat, 30 May 2026 18:05:18 +0200
Message-ID: <20260530160322.541926496@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryo Takakura <ryotkkr98@gmail.com>

[ Upstream commit ffc2c8c4a714df53a715827d6334ab9474424f6a ]

Initialize u64 stats as it uses seq counter on 32bit machines
as suggested by lockdep below.

[    1.830953][    T1] INFO: trying to register non-static key.
[    1.830993][    T1] The code is fine but needs lockdep annotation, or maybe
[    1.831027][    T1] you didn't initialize this object before use?
[    1.831057][    T1] turning off the locking correctness validator.
[    1.831090][    T1] CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.16.0-rc2-v7l+ #1 PREEMPT
[    1.831097][    T1] Tainted: [W]=WARN
[    1.831099][    T1] Hardware name: BCM2711
[    1.831101][    T1] Call trace:
[    1.831104][    T1]  unwind_backtrace from show_stack+0x18/0x1c
[    1.831120][    T1]  show_stack from dump_stack_lvl+0x8c/0xcc
[    1.831129][    T1]  dump_stack_lvl from register_lock_class+0x9e8/0x9fc
[    1.831141][    T1]  register_lock_class from __lock_acquire+0x420/0x22c0
[    1.831154][    T1]  __lock_acquire from lock_acquire+0x130/0x3f8
[    1.831166][    T1]  lock_acquire from bcmgenet_get_stats64+0x4a4/0x4c8
[    1.831176][    T1]  bcmgenet_get_stats64 from dev_get_stats+0x4c/0x408
[    1.831184][    T1]  dev_get_stats from rtnl_fill_stats+0x38/0x120
[    1.831193][    T1]  rtnl_fill_stats from rtnl_fill_ifinfo+0x7f8/0x1890
[    1.831203][    T1]  rtnl_fill_ifinfo from rtmsg_ifinfo_build_skb+0xd0/0x138
[    1.831214][    T1]  rtmsg_ifinfo_build_skb from rtmsg_ifinfo+0x48/0x8c
[    1.831225][    T1]  rtmsg_ifinfo from register_netdevice+0x8c0/0x95c
[    1.831237][    T1]  register_netdevice from register_netdev+0x28/0x40
[    1.831247][    T1]  register_netdev from bcmgenet_probe+0x690/0x6bc
[    1.831255][    T1]  bcmgenet_probe from platform_probe+0x64/0xbc
[    1.831263][    T1]  platform_probe from really_probe+0xd0/0x2d4
[    1.831269][    T1]  really_probe from __driver_probe_device+0x90/0x1a4
[    1.831273][    T1]  __driver_probe_device from driver_probe_device+0x38/0x11c
[    1.831278][    T1]  driver_probe_device from __driver_attach+0x9c/0x18c
[    1.831282][    T1]  __driver_attach from bus_for_each_dev+0x84/0xd4
[    1.831291][    T1]  bus_for_each_dev from bus_add_driver+0xd4/0x1f4
[    1.831303][    T1]  bus_add_driver from driver_register+0x88/0x120
[    1.831312][    T1]  driver_register from do_one_initcall+0x78/0x360
[    1.831320][    T1]  do_one_initcall from kernel_init_freeable+0x2bc/0x314
[    1.831331][    T1]  kernel_init_freeable from kernel_init+0x1c/0x144
[    1.831339][    T1]  kernel_init from ret_from_fork+0x14/0x20
[    1.831344][    T1] Exception stack(0xf082dfb0 to 0xf082dff8)
[    1.831349][    T1] dfa0:                                     00000000 00000000 00000000 00000000
[    1.831353][    T1] dfc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
[    1.831356][    T1] dfe0: 00000000 00000000 00000000 00000000 00000013 00000000

Fixes: 59aa6e3072aa ("net: bcmgenet: switch to use 64bit statistics")
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Ryo Takakura <ryotkkr98@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250702092417.46486-1-ryotkkr98@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 43fba7b47d1cd..64bc7b3afb514 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -4079,6 +4079,12 @@ static int bcmgenet_probe(struct platform_device *pdev)
 	for (i = 0; i <= priv->hw_params->rx_queues; i++)
 		priv->rx_rings[i].rx_max_coalesced_frames = 1;
 
+	/* Initialize u64 stats seq counter for 32bit machines */
+	for (i = 0; i <= priv->hw_params->rx_queues; i++)
+		u64_stats_init(&priv->rx_rings[i].stats64.syncp);
+	for (i = 0; i <= priv->hw_params->tx_queues; i++)
+		u64_stats_init(&priv->tx_rings[i].stats64.syncp);
+
 	/* libphy will determine the link state */
 	netif_carrier_off(dev);
 
-- 
2.53.0



