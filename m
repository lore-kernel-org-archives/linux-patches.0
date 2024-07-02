Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC9E1BE226;
	Tue,  2 Jul 2024 17:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941304; cv=none; b=FuUtxtFYlYJrDWNXn34PnDLUHkitIcKrlfaeMPLt3Nc56+gJAeLAjySTAiz6Qt0NjikFNTK6Iidq7rgLiZA7Tyu6LkUN/qJgHEZUGEt5oSfVCJikpOhIc1E3REoOHaegVgokATT3Wi97/6+HMPZicSx3CvmalyLzUVZe0coDSCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941304; c=relaxed/simple;
	bh=Xv14gKyXYXEfsnDKkZN137Ug5V0axGi2e7wDiNtunas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/irI1fol/g5rf7x+96P5EzYOoaLRmmYZVXqGerIKVuPnVi6qWWLf8ciNBH9VLBoDbwCOFtyTAITUIlCf6XauBekkf3SyJPFQnsvvtNixmZKcpVvDsiNFBmn4G9BrJAqkn5jF4I9Y9aCTU9FCpiNyQXeJwN1aZli4pZshUxV0Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuBsD5Xz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuBsD5Xz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C96FC116B1;
	Tue,  2 Jul 2024 17:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941303;
	bh=Xv14gKyXYXEfsnDKkZN137Ug5V0axGi2e7wDiNtunas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuBsD5Xz05sD/EQGajQmx0OGpxUyVXxmMm7lxcZIF1kiNKV2W7154YnpOnIqGTVk9
	 YqrI2hr6QueGJvUHupgy82GnH2vsNZI7kAGGUHB6DGkps9GmCykZQlOiOUidZkr7Jz
	 cGBln55dps9wKDJd1Qegy8T6KrscOX08x9ABCWSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enguerrand de Ribaucourt <enguerrand.de-ribaucourt@savoirfairelinux.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/128] net: phy: micrel: add Microchip KSZ 9477 to the device table
Date: Tue,  2 Jul 2024 19:03:45 +0200
Message-ID: <20240702170227.146927909@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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
index 98c6d0caf8faf..90f3953cf9066 100644
--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -3405,6 +3405,7 @@ static struct mdio_device_id __maybe_unused micrel_tbl[] = {
 	{ PHY_ID_KSZ8081, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ8873MLL, MICREL_PHY_ID_MASK },
 	{ PHY_ID_KSZ886X, MICREL_PHY_ID_MASK },
+	{ PHY_ID_KSZ9477, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8814, MICREL_PHY_ID_MASK },
 	{ PHY_ID_LAN8804, MICREL_PHY_ID_MASK },
 	{ }
-- 
2.43.0



