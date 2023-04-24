Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B412108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37150C433D2;
	Mon, 24 Apr 2023 13:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343402;
	bh=gO+GdgzoIZYjyjSatOpE+L9B1XWj2PfSgMH+vHfqlEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=acHh7+xL95GaLDaI4JUM1GiGLh+DWDeD5EATDZjTCBG1trJXfSxkLawubFLB93do6
	 HJflfcG//+4x8lWvkqGZJLqPs84OyJatpVXUIrnBTV8NUwGeaxnu8zeCgWC+3qs/ql
	 5SkshD8cPw2GvG4t0tuxpMJMGJAMBVI/t98KLrtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 12/28] net: dsa: b53: mmap: add phy ops
Date: Mon, 24 Apr 2023 15:18:33 +0200
Message-Id: <20230424131121.734824859@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131121.331252806@linuxfoundation.org>
References: <20230424131121.331252806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 45977e58ce65ed0459edc9a0466d9dfea09463f5 ]

Implement phy_read16() and phy_write16() ops for B53 MMAP to avoid accessing
B53_PORT_MII_PAGE registers which hangs the device.
This access should be done through the MDIO Mux bus controller.

Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_mmap.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_mmap.c b/drivers/net/dsa/b53/b53_mmap.c
index ef63d24fef814..985eb0bbf7dbd 100644
--- a/drivers/net/dsa/b53/b53_mmap.c
+++ b/drivers/net/dsa/b53/b53_mmap.c
@@ -207,6 +207,18 @@ static int b53_mmap_write64(struct b53_device *dev, u8 page, u8 reg,
 	return 0;
 }
 
+static int b53_mmap_phy_read16(struct b53_device *dev, int addr, int reg,
+			       u16 *value)
+{
+	return -EIO;
+}
+
+static int b53_mmap_phy_write16(struct b53_device *dev, int addr, int reg,
+				u16 value)
+{
+	return -EIO;
+}
+
 static const struct b53_io_ops b53_mmap_ops = {
 	.read8 = b53_mmap_read8,
 	.read16 = b53_mmap_read16,
@@ -218,6 +230,8 @@ static const struct b53_io_ops b53_mmap_ops = {
 	.write32 = b53_mmap_write32,
 	.write48 = b53_mmap_write48,
 	.write64 = b53_mmap_write64,
+	.phy_read16 = b53_mmap_phy_read16,
+	.phy_write16 = b53_mmap_phy_write16,
 };
 
 static int b53_mmap_probe(struct platform_device *pdev)
-- 
2.39.2



