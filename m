Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015C431355F;
	Mon, 13 Oct 2025 15:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370075; cv=none; b=WbaU1GdymFZcxdJoPl4ymuJUiSUmkKlr9F8LKQ58jfNOBCOBZacnqNi4e5Czj8U8/5B8+TWn6ZtzUyZ4sk8HpeYVRk3fRv4ukOhtxUCSp5bM91W2O/NS8US6j/plCddJu6/dGQUG/CbIDlS2eDpl6F5S5LMfnfVa3lyt3bSoXQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370075; c=relaxed/simple;
	bh=uoq4kVNW3nDTZJDviFHZNxPI7VzcLG5+4qgbhve/4cs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XqlvxUzPH6Fq/gZLn37kFCiOfDoLA51i2OjROPvt3A7r6x70+BeS/84TKJf0UJDgvS92ola6IgMyE84MwHdhZb4ZbJG+XgCOgl+VxSTM3d9XFog6/3/af7CBsndFXbIPXH1bro/L1ls5vq809E7rYn7agZ+gIbYbX57dQkATfck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LybaMTZR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LybaMTZR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5309DC4CEE7;
	Mon, 13 Oct 2025 15:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370074;
	bh=uoq4kVNW3nDTZJDviFHZNxPI7VzcLG5+4qgbhve/4cs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LybaMTZRb6ywW66exJffOPDGHwHE7V8oDphMe3riebiqyi3QZhJS6OzozKjIWTwhI
	 3Ont3W0MXT0Q4MOO/JObhbrXzf9W8313yF2B86I9tYUMiayWb4KUosuppiyjkTlMSL
	 /PU4M3d9TiYU9L/l4bRsl87SVD6q8JwaDg0wUUDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 469/563] PCI: j721e: Fix incorrect error message in probe()
Date: Mon, 13 Oct 2025 16:45:30 +0200
Message-ID: <20251013144428.280431202@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit cfcd6cab2f33c24a68517f9e3131480b4000c2be ]

The probe() function prints "pm_runtime_get_sync failed" when
j721e_pcie_ctrl_init() returns an error. This is misleading since
the failure is not from pm_runtime, but from the controller init
routine. Update the error message to correctly reflect the source.

No functional changes.

Fixes: f3e25911a430 ("PCI: j721e: Add TI J721E PCIe driver")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://patch.msgid.link/20250905211436.3048282-1-alok.a.tiwari@oracle.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/cadence/pci-j721e.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/cadence/pci-j721e.c b/drivers/pci/controller/cadence/pci-j721e.c
index 6c93f39d02888..5e445a7bda332 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -549,7 +549,7 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 
 	ret = j721e_pcie_ctrl_init(pcie);
 	if (ret < 0) {
-		dev_err_probe(dev, ret, "pm_runtime_get_sync failed\n");
+		dev_err_probe(dev, ret, "j721e_pcie_ctrl_init failed\n");
 		goto err_get_sync;
 	}
 
-- 
2.51.0



