Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0B4B14F6A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piWgr9pa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C6EFC433C8;
	Mon, 23 Oct 2023 11:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060142;
	bh=OnKnlbgX1oCBCL1CqcNPo2P3iGNB/XmLwNO01Iw7Mvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=piWgr9paUzw6A49ZVj28hX9dF6C8YDjHCf582+2NX4Enhz7qcWWh1iNZdm7NQsCzJ
	 KzKM4PT8QAqPuuM+hCTCaMEN8rQ5ec+iHoAa7+IHmi8+eN1goExAqIUeJwYPahJNqS
	 0Eg0fWxHrtRdD1B6Sg1tsnkM5jl2YwCP8O8mXddk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 072/196] net: phy: bcm7xxx: Add missing 16nm EPHY statistics
Date: Mon, 23 Oct 2023 12:55:37 +0200
Message-ID: <20231023104830.584188543@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

commit 6200e00e112ce2d17b066a20dd2476d9aecbefa6 upstream.

The .probe() function would allocate the necessary space and ensure that
the library call sizes the number of statistics but the callbacks
necessary to fetch the name and values were not wired up.

Reported-by: Justin Chen <justin.chen@broadcom.com>
Fixes: f68d08c437f9 ("net: phy: bcm7xxx: Add EPHY entry for 72165")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20231017205119.416392-1-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/bcm7xxx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -907,6 +907,9 @@ static void bcm7xxx_28nm_remove(struct p
 	.name		= _name,					\
 	/* PHY_BASIC_FEATURES */					\
 	.flags		= PHY_IS_INTERNAL,				\
+	.get_sset_count	= bcm_phy_get_sset_count,			\
+	.get_strings	= bcm_phy_get_strings,				\
+	.get_stats	= bcm7xxx_28nm_get_phy_stats,			\
 	.probe		= bcm7xxx_28nm_probe,				\
 	.remove		= bcm7xxx_28nm_remove,				\
 	.config_init	= bcm7xxx_16nm_ephy_config_init,		\


