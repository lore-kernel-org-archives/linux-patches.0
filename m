Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6644D13B280;
	Wed,  3 Jul 2024 11:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006019; cv=none; b=IS5vkLRzSXMYc1xSsdctWkJyBhq3Kbwpu+gRs8mHabLtuGb0FU75kwoWn1EERkLQgZrzLA9lots3SQQ7eA6HYVp2tCAVn2o2d3VCKpcY9kvl06jzwDr+hkCOWeg0dEEN/HLiPxCBtQ6rqJo3izDtl1DnvaG0cxZquZN07drUdUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006019; c=relaxed/simple;
	bh=x4rRBSgz6ay2Acrv1uQ/8W3WD2PAvA2sn/axOLi4pg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWfh8Ne2vvJqbsHz8665CQMsFjmMH2Mnh0ktCHzmZT2eXHDPI1/r2j2KVnvsPDZlOh3YOv7sQUZgWZTHiMpNR5yBfy+5I8fGPThzxHJG6XdJFuYbo2EpxZzhNyNPcD23vvUCAEJcQXGwGpSDjVIcbiUvAZeVzcz7yZjYfof7RhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTO4bVXS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTO4bVXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8200BC2BD10;
	Wed,  3 Jul 2024 11:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006018;
	bh=x4rRBSgz6ay2Acrv1uQ/8W3WD2PAvA2sn/axOLi4pg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTO4bVXSCcRqD0/JmOpwuTqsXaFmhleQ7MExE/CU3qG2keXeELLv9ew0K045MQEMc
	 8+K9sYHPoVnrDK5KysvRhiyLuf8FnazqKT/dUDd+JDKFB9iHZbs4bwpY7UjRv785Td
	 uSGttJiVyl9vfAsQ79N3m/y/4EO1DCSQ244XJ8bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/356] net: phy: micrel: add Microchip KSZ 9477 to the device table
Date: Wed,  3 Jul 2024 12:40:09 +0200
Message-ID: <20240703102923.442236278@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>

[ Upstream commit 54a4e5c16382e871c01dd82b47e930fdce30406b ]

PHY_ID_KSZ9477 was supported but not added to the device table passed to
MODULE_DEVICE_TABLE.

Fixes: fc3973a1fa09 ("phy: micrel: add Microchip KSZ 9477 Switch PHY support")
Signed-off-by: Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/micrel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
index 59d05a1672ece..f1a6cc7ccf1a3 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1798,6 +1798,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
+	{ PHY_ID_KSZ9477, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ }
 };
-- 
2.43.0



