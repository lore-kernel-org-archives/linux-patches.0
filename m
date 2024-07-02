Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B68C7178381;
	Tue,  2 Jul 2024 17:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940782; cv=none; b=Mk86Btb2hxU9KJtNSRczwbr9gm7egUFYYIpJ/4/OvrfDwcc9gu2qgc2cM8VNvPP4zAZI4FMrImLAcsu72y0DuGCt5C2hgcO3EjgJrG3Po4igRpfcKa40eU0/dSPBLAwl/vCC9WQU2AwluaiBYHfiqfzIFi0clsXKoLIsdf95HpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940782; c=relaxed/simple;
	bh=xFy67gAK/9Y9WTq5FRP+SdG5vLBKHclJxaYbi+z9ZDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/uOdoALJBC59Y0PQZqTly7w73exgQ3WGZhnTifr1FEoypUZbgTXclixDzgBr7z5MMLf+7zAY/xToW8flLZT1HhewZPlxpD+DK55MuOhadCy8YjtttP/HMgioAnOYC0ZCYiDRce/e4N+zV8dxs6aRTqtTH4QKET+t7RlRsApQL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOUvr0qy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOUvr0qy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DBAC116B1;
	Tue,  2 Jul 2024 17:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940782;
	bh=xFy67gAK/9Y9WTq5FRP+SdG5vLBKHclJxaYbi+z9ZDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uOUvr0qyxK8pWSIkMpAsZ6wAkIY9PbkPz3S8jt4n6P85OFZ/B50Ller6Pcfr7XR5q
	 Na2VcBClKC7ti9S4DH+zjsyxOrqXfP8uAu3aAt6CElitO/PxY/cMUBLzbzqvNxF/ft
	 qa08ZD2XSHCVyM4PJrSP+pQzuKnjN5CrxjP8aqkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 033/163] net: phy: micrel: add Microchip KSZ 9477 to the device table
Date: Tue,  2 Jul 2024 19:02:27 +0200
Message-ID: <20240702170234.311707149@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 366ae22534373..029c82f88ee38 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -5030,6 +5030,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
+	{ PHY_ID_KSZ9477, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8804, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8841, MICREL_PHY_ID_MASK },
-- 
2.43.0



