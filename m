Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD14846D544;
	Tue, 21 Jul 2026 19:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661225; cv=none; b=D7kS/urEZhyTfZEb5yZy+2RY276Enu0HGyl0MLc2ItV0uNB/WjnZuhKUnV7u/HaPJxY+5q3Mp0LmLzmlsILDC4RsAauLzi0p+XFBedoYVRNzg5LN5KPeU5PWvod9Ii/miS0ilMSM4zUTg1B4SNu6Z5VHY4fcoQYRzcLVBX27lO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661225; c=relaxed/simple;
	bh=hFblhuk8C16TrxdzaA70sr82vFSfhh+cxKdqH6oMUs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/YOYGSoONiGc+EzeO/jbY3deYV2xGpd1mtYZHUTD4l+j2mDHARdKksUXYmGhEurEutsgglA9UtTl/Fnhakjbf4sDVUEqfROo/VuZn8Nc6PQnX9aJte5H/rxbhkPSWx3zHtPIT5lHgxHNFJn0qchsHH2GIiMO8CcWoBVJVtMSA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MUmVcveZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MUmVcveZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4071F000E9;
	Tue, 21 Jul 2026 19:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661224;
	bh=Q1y9I+uw1czSI0lGvEOIkbuIxzc91Ui+FhmFK13jXjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MUmVcveZVzOnvwfK2QaUy/FCtG6yAAEdfLZWODQ8rJdOoetyZQV0dzhk8bICefdbJ
	 4eck2gWcjKpX7PFg5ZDG5RgZqRrKzAq2UT6ojdtGj+CYP89faHzhVaGPUiWSOoV/fi
	 BPAQpF3F3DBdXv9HQzi6qALLMcu57Cac66nd7zvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jan Klos <honza.klos@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1277/2077] net: phy: realtek: Clear MDIO_AN_10GBT_CTRL_ADV10G bit
Date: Tue, 21 Jul 2026 17:15:50 +0200
Message-ID: <20260721152622.937513503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Klos <honza.klos@gmail.com>

[ Upstream commit 510a283f4d12367a3f811f382a2c89202954bbd1 ]

On RTL8127A connected to a link partner that advertises 10000baseT
speed cannot be changed to anything other than 10000baseT as 10GbE
is always advertised regardless of any setting. Fix this by
clearing MDIO_AN_10GBT_CTRL_ADV10G bit in rtl822x_config_aneg()'s
call to phy_modify_mmd_changed().

Fixes: 83d962316128 ("net: phy: realtek: add RTL8127-internal PHY")
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Signed-off-by: Jan Klos <honza.klos@gmail.com>
Link: https://patch.msgid.link/20260620011956.37181-1-honza.klos@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek/realtek_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek/realtek_main.c b/drivers/net/phy/realtek/realtek_main.c
index 79c867ef64dad0..01bbddeb4a306d 100644
--- a/drivers/net/phy/realtek/realtek_main.c
+++ b/drivers/net/phy/realtek/realtek_main.c
@@ -1632,7 +1632,8 @@ static int rtl822x_config_aneg(struct phy_device *phydev)
 		ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND2,
 					     RTL_MDIO_AN_10GBT_CTRL,
 					     MDIO_AN_10GBT_CTRL_ADV2_5G |
-					     MDIO_AN_10GBT_CTRL_ADV5G, adv);
+					     MDIO_AN_10GBT_CTRL_ADV5G |
+					     MDIO_AN_10GBT_CTRL_ADV10G, adv);
 		if (ret < 0)
 			return ret;
 	}
-- 
2.53.0



