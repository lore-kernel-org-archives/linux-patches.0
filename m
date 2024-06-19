Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF0212FB27;
	Wed, 19 Jun 2024 13:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803672; cv=none; b=poTUZpN1jRMO34HSomoGwgnrlgdH9iZxfeCAQeRVbhpajwXI0mSUGa9Pbll832v617xNl8u75wT+s/d6BoNKPIMun7ALlXceg2PzCwH9pRUwGWyacjNt2HBRmC9b6zj1eNDu0y0I26W5+MAuSWEBaNcVMJ2D5MUcLiLnxg/ruKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803672; c=relaxed/simple;
	bh=X4M9ev+6ZIS6NYrftiA766MNmWMfiCD0WiJm8ByNJIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cdocG/PvBT7Kf7AHD9XxcH4elFDqJv69Sc0mmxiVKRBF98WiqhKrJd9Tnxe0wXmOxgs7OlHZ7K2YRvBtqDEc/2NZP1HKtkVuCCtudxvZGxL6O6XcNnOSMdpr/ezEyuzLZLy7jNb5eSDhdnrBuDebC/qpby6o4t32ZFXLwlJz6w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldFPFOkv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldFPFOkv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA582C2BBFC;
	Wed, 19 Jun 2024 13:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803672;
	bh=X4M9ev+6ZIS6NYrftiA766MNmWMfiCD0WiJm8ByNJIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldFPFOkvmZiu8WWUgPgGEbBZIRk8v7p2kttSIH/qv4C1nhtJLbvMlrN4LqfsHoa4x
	 hR1Cx46IvlWq8Du+pxGePiRk/hSmSf2+c0EZ+s8GK7dN1x7Lj2ty4URt0YNv/n9sWa
	 ZMp1HE/qnn+HcjtSEBsjaaZnDj6yXy1g1YYje9QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 063/217] misc/pvpanic-pci: register attributes via pci_driver
Date: Wed, 19 Jun 2024 14:55:06 +0200
Message-ID: <20240619125559.117721219@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



