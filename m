Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC5D38CFF5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302120; cv=none; b=J/P3tmZ6ouZlyAQS6pJepATmPTog7vtEO1h2cEZ8Q3cWI2+gJQG0dfXCwaMVCNrJ0vGSEP4vUK+c4cJamdYjtAqmXP/8L/BUTqUitlKCpODgrZo0N2ibdlkrHHx2dQC7F6eqDTCN4erUe9g8ses8SwZcFnbGN3MwPeYqdtwlsdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302120; c=relaxed/simple;
	bh=6gGc5LsNWMi4btpyyS4OvKK7cUt20jWlFbFx1pe5iaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eJ3TYKYrQhTFCFHE/xgNy87Url2aMcxUAJAluDHGyBbZ+SVHW9kFW6pi6sZtomix/lHjhxSIcSsmHLNfe0e+aV8Wtd6clEI5j8Vo54gNlvVXtNsMMFPn642Pocs7kD+Rkt5AmU3sv61Ybl/ebHSGdv+THj1X79k/fOvm55AxveM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KxLxeIbk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KxLxeIbk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89674C116D0;
	Sat, 28 Feb 2026 18:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302120;
	bh=6gGc5LsNWMi4btpyyS4OvKK7cUt20jWlFbFx1pe5iaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxLxeIbk2lz/I1TKK36XhKqGuEm/1s7t+HmPKL0IxZr8bEeqOCFS1Y7tmuOgHVX7Y
	 mSmvSXYJqLG6Fmi9Ut8NA6a0Mp3UpJt1TwrpgDP3ULU7LoyEZ262gqXkCOjw+/zKfS
	 j8/iGSfz9npQsKTyLVyhXDRI6I6mvKzdtea3ZQ5HY517UT1XNOj/0I3xoHFtXrVQic
	 7mcZvq8XqAS27GruVr7egFDIkpG5mFwKsb4Dz8EFoe+Dn8ZAptCFfJ+bpolYgQKfbD
	 DGfLKKM43GJ2rWb6jXhqkICJLlVwa7I/JFIOmbznuWiBycGM2ykQFYHOv4FfJtWjvt
	 ZwC/v7XOwczOw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 110/283] PCI/portdrv: Fix potential resource leak
Date: Sat, 28 Feb 2026 13:04:12 -0500
Message-ID: <20260228180709.1583486-110-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 01464a3fdf91c041a381d93a1b6fefbdb819a46f ]

pcie_port_probe_service() unconditionally calls get_device() (unless it
fails). So drop that reference also unconditionally as it's fine for a
PCIe driver to not have a remove callback.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Link: https://patch.msgid.link/e1c68c3b3f1af8427e98ca5e2c79f8bf0ebe2ce4.1764688034.git.u.kleine-koenig@baylibre.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/portdrv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/pcie/portdrv.c b/drivers/pci/pcie/portdrv.c
index d6e5fef54c3b8..dac3ba1b2552f 100644
--- a/drivers/pci/pcie/portdrv.c
+++ b/drivers/pci/pcie/portdrv.c
@@ -554,10 +554,10 @@ static int pcie_port_remove_service(struct device *dev)
 
 	pciedev = to_pcie_device(dev);
 	driver = to_service_driver(dev->driver);
-	if (driver && driver->remove) {
+	if (driver && driver->remove)
 		driver->remove(pciedev);
-		put_device(dev);
-	}
+
+	put_device(dev);
 	return 0;
 }
 
-- 
2.51.0

