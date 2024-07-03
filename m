Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D628D6E5ED;
	Wed,  3 Jul 2024 11:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005429; cv=none; b=NbFO8hvHMOTm8JJ0GcNvpACikiTHXYzOE5yDH4Qg9Xz+hDihkrSQi742MLE5GQ76SwOCGDeA6idW9LKk3kCrohQQ3nB68ehNa5tDrqobFTLdQJAm7F0tIl4DZ3IqotgZXjSxKH73JSF+WUor3NI6qwEBtySjLHDCQ3qfO6cka6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005429; c=relaxed/simple;
	bh=1NV0F5xTtwM/S7XpoxmKPo59/TEg4AAgV97F13LpSj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UgKfsPjlTcw+jfdLHmHCDlX/fX4s+rpgi78/2tLqJ4oKa8Hu3ileg7CW+jgLo5dNsTpn5OC2XyrU7FTTIWXAm2Tut2dYhsEpkjP+ZDch9jHrK2+Gomdlw3hPTQjf67aR4+izPpvS/FN0sjwZEXgByMGv51LXxtMuLHonZRZYEnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KAbtyDD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KAbtyDD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEDAC2BD10;
	Wed,  3 Jul 2024 11:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005429;
	bh=1NV0F5xTtwM/S7XpoxmKPo59/TEg4AAgV97F13LpSj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAbtyDD5Ssfm8/hNQUod36q0D/sXrLOYKqDUDl1bJOgrkg/au4pnznAzI375Fiolu
	 Qp2Sbv0dzgH3iDXfv3VqL6nuyiMEN6L4nugvPUBOJypOlyFv10l2Tbzi8ivSXAbILi
	 HZXXiCGpHcpKqBnIkjaF7UWJo/A95Zn+ZHLnZblU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 047/356] misc/pvpanic-pci: register attributes via pci_driver
Date: Wed,  3 Jul 2024 12:36:23 +0200
Message-ID: <20240703102914.875346884@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit ee59be35d7a8be7fcaa2d61fb89734ab5c25e4ee ]

In __pci_register_driver(), the pci core overwrites the dev_groups field of
the embedded struct device_driver with the dev_groups from the outer
struct pci_driver unconditionally.

Set dev_groups in the pci_driver to make sure it is used.

This was broken since the introduction of pvpanic-pci.

Fixes: db3a4f0abefd ("misc/pvpanic: add PCI driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Fixes: ded13b9cfd59 ("PCI: Add support for dev_groups to struct pci_driver")
Link: https://lore.kernel.org/r/20240411-pvpanic-pci-dev-groups-v1-1-db8cb69f1b09@weissschuh.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/pvpanic/pvpanic-pci.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/misc/pvpanic/pvpanic-pci.c b/drivers/misc/pvpanic/pvpanic-pci.c
index 689af4c28c2a9..2494725dfacfa 100644
--- a/drivers/misc/pvpanic/pvpanic-pci.c
+++ b/drivers/misc/pvpanic/pvpanic-pci.c
@@ -48,8 +48,6 @@ static struct pci_driver pvpanic_pci_driver = {
 	.name =         "pvpanic-pci",
 	.id_table =     pvpanic_pci_id_tbl,
 	.probe =        pvpanic_pci_probe,
-	.driver = {
-		.dev_groups = pvpanic_dev_groups,
-	},
+	.dev_groups =   pvpanic_dev_groups,
 };
 module_pci_driver(pvpanic_pci_driver);
-- 
2.43.0



