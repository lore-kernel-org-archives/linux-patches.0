Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7586196D90;
	Thu,  6 Jun 2024 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683665; cv=none; b=VDdLFbvij//fa3oqtgZ9pHBIGSPIeYeor0SL0g7sSk+gjJkcogN7saLos4M/7Q00W8jXZ/15WQn34p/lDatgc9ZnFEvtc4eMxOlI952FPrp0EGIl1pw3L0cCljkfr1CWf4JiB4ys6mrmB++liqQcFGbP/NewY9+t2RnTuIn9VYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683665; c=relaxed/simple;
	bh=C1hBd1yHkS1eVoybmemrVFWpBMu3XaN9/YbG5CWG8II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Sm8dEhtFLafSKhfNL3UttaKlcsyqzWvUdLXGRnDJ/UmxrO5ZnbxM4ncAsEH8IcrJ3jfikZHxQoAoPkw9adJRM0bQYga+4Jwn9tdxe06bgwTfOLzFHoiwj3vasJd1ZT1v4p2hWbpG4FRq8pjIMxzYNLocilYGgq/aTAxElWfW9q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MketUEbN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MketUEbN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9842DC2BD10;
	Thu,  6 Jun 2024 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683665;
	bh=C1hBd1yHkS1eVoybmemrVFWpBMu3XaN9/YbG5CWG8II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MketUEbNkWJMmVtZGuWJJdyEcDzYykX7t95BSXDqMo1RdR37/Ig0LOmDQ9SXjYJxr
	 MUROFlal+Z+4XiV0HRF4PiEWEXiNX1icr+q81veljbZx+dGfmSQnw1XTZPC6qXDYGI
	 YVOuFWRunFMt+wXCc/47J/ddKMAukg8bT1L4agik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 550/744] misc/pvpanic-pci: register attributes via pci_driver
Date: Thu,  6 Jun 2024 16:03:42 +0200
Message-ID: <20240606131750.096708902@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



