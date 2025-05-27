Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4DE19AD48;
	Tue, 27 May 2025 02:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748313464; cv=none; b=a8WxiiUDPBCul0dYRXllxw5fkrb3aekI6nWjnSOTIZ5kHjSKIsH0xdNHwgQNuQjS0M0csfPzsyZRQ5fFNI+nXZmy6vCH4slIsniMWeU7m2iTfbTsTKajGlAbWWQ9q4txbSNZm8Ji42l98uwo2fWYa64jhu3dI71AWKHX3ON4Mco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748313464; c=relaxed/simple;
	bh=kd9mQLCjXRwykBXhmaoNX+HltWALGxF9dytY4l6yTc8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BafVaThSD61QPM5BjiG+s1YspR9N7vaBRTKgE9XPj2KcbysbYUpt7oRkEB7fT8tB+71NVhMNqw7hI7wGvZVlWFi+jeDF1pEoGiupoYdn4BOC2+4nLC0oZBTxUtvLeBqW2yktWlpzWe8X0BRp/gVjoVT7AKU1No1CVnd4fWSWJyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hiu6OaM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hiu6OaM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9055C4CEE7;
	Tue, 27 May 2025 02:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748313464;
	bh=kd9mQLCjXRwykBXhmaoNX+HltWALGxF9dytY4l6yTc8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiu6OaM+PsGAF1r3Z/wi67FqYcxa8jlhE6vDymTfj0v7wcrqIK/RhAtM9T03a6z7u
	 ozrOuf32sNVsdqdY5otHjPk6/HTLcpRsc6r63e7wIGX9Yq2J0ZcCnXiLGHXaUvCQPV
	 eLPpbWAikqQCu+pWP5vHNlrPCR/Hk5Sm1PaSL6YtrH3DWxp4ltCFpzJNmVXYG05Qp7
	 rGQkPGVD7eksJ9GpfsyQPSXwGfNzMXlT9qupbRxW78kw6XqiLGS7Mx7ljo5L9WEQKj
	 mQf+JycJY/mBAevEyh30jPi9DsLWhVXUX+MED9lvi40RUt4qfGY+x16bMniJjcou0j
	 KTgOTkfn6hwVA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nishanth Menon <nm@ti.com>,
	Simon Horman <horms@kernel.org>,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	alexander.sverdlin@gmail.com,
	dan.carpenter@linaro.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.14 4/5] net: ethernet: ti: am65-cpsw: Lower random mac address error print to info
Date: Mon, 26 May 2025 22:37:33 -0400
Message-Id: <20250527023734.1017073-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250527023734.1017073-1-sashal@kernel.org>
References: <20250527023734.1017073-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.8
Content-Transfer-Encoding: 8bit

From: Nishanth Menon <nm@ti.com>

[ Upstream commit 50980d8da71a0c2e045e85bba93c0099ab73a209 ]

Using random mac address is not an error since the driver continues to
function, it should be informative that the system has not assigned
a MAC address. This is inline with other drivers such as ax88796c,
dm9051 etc. Drop the error level to info level.

Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://patch.msgid.link/20250516122655.442808-1-nm@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index afe8127fd32be..15bae216be2a9 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2775,7 +2775,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 							port->slave.mac_addr);
 			if (!is_valid_ether_addr(port->slave.mac_addr)) {
 				eth_random_addr(port->slave.mac_addr);
-				dev_err(dev, "Use random MAC address\n");
+				dev_info(dev, "Use random MAC address\n");
 			}
 		}
 
-- 
2.39.5

