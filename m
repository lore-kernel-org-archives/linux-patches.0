Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D85D185E4F;
	Wed,  3 Jul 2024 10:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004169; cv=none; b=mX++lao3nBi2xp+X5epASCeejyC3HaA1HoS9Laxsk0UhZIucQscHJmKMB3blS4mEobbrpvgoekDmRkr7Wx09DFyGIrBRE5PZMcb9caUDEwe9odYMyGOktW3XIUAngKkO10boWNWgv+GPK+nz53wHmXAvsIJVh0CnuTrE4pT3q64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004169; c=relaxed/simple;
	bh=CGPa+ilyXfEqHwmafR6PGEYhRwU4DxplZsvLc2zBDQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhpxgxLKLdqDic8riOCRpKyNba2tSIvwo4yi5JuuVyvfUu73/+G2OWBw0PDhWu2l6msAzJ4Orsd4W4lLT5cvk086haVHD0ye22qLBelxEMXqSJmlAy5NpeA3GTTeTds8a9jhSJzmxSo5bd2PWG3ilYFdXWRNgwPqa2NkfiGUuWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VB9vl9zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VB9vl9zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD49C2BD10;
	Wed,  3 Jul 2024 10:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004169;
	bh=CGPa+ilyXfEqHwmafR6PGEYhRwU4DxplZsvLc2zBDQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VB9vl9zcYgMPNlQeUGSVj/qeNP9qzfhKoKR8WOMwDtKmJFaM8uu8JP4tcYSEYK83f
	 nNor7WYaznxpVljesupLnvTBEso2zNgH9AODjAeYKcD/v3dqboYACrD5bMNmRtH8e6
	 iYyMMMhTMDaztkDX5mAJ9uNPxS0wrdC68k+O0yOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 143/189] net: phy: micrel: add Microchip KSZ 9477 to the device table
Date: Wed,  3 Jul 2024 12:40:04 +0200
Message-ID: <20240703102846.876927520@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2cd812c097baf..d46c2ae817be9 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -1234,6 +1234,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
+	{ PHY_ID_KSZ9477, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ }
 };
-- 
2.43.0



