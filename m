Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F37003081CC;
	Mon, 13 Oct 2025 15:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368635; cv=none; b=BpV396ywERG7g0EdAXiqd8lL7esm3KHbPuugedsOsn2abPWlydioaNBizmmkgtBSSc3J0JCLQgbpShUmVe+aGTHNVM+SmXd0r37Ki12tKYXexIOEisDFFwBpFnOGj3JKbZ/TyBHu6CDub2aZSHYZLfbffIHXbcjpA0D4kUKrJWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368635; c=relaxed/simple;
	bh=rnWGzEBAAYxCTwWfZQnoWLyr+je+iYsOago3w7uvGAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQ7eqDOFbsLFqdZEgQriQ5faNOiCdQDAk+1nK1pHuM+5T5SQ/euej6OwkDtsRKoWgUD8VbovTHDfKpzbzxhhO4dIwNsry8wooCm/Pg1aFLsRSjKgA0C3JY5/OjIgCOSS4KUeprmSaDqgbSsZBfuvWrx1Tlz73MoJJ9ZPwW1gIUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k/Rbq4Ww; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k/Rbq4Ww"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EEABC4CEE7;
	Mon, 13 Oct 2025 15:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368634;
	bh=rnWGzEBAAYxCTwWfZQnoWLyr+je+iYsOago3w7uvGAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k/Rbq4WwNhLLUDewOunQY52YsmSojb0wPfNGlrkY5/V6pavZfWJOTwv8Mv0GIWX+s
	 +wYVkMF2+9v0ufAtAr5Y3hpaJi1zwf/nAXp0J71+TYvqX6uHyCHzuk3bihuXS2D5Z8
	 dJBwesGhiGwPXKQPXHQkHXjni6o/qOz0UQy5ktKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 212/262] PCI: j721e: Fix incorrect error message in probe()
Date: Mon, 13 Oct 2025 16:45:54 +0200
Message-ID: <20251013144333.878405162@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index bae829ac759e1..eb772c18d44ed 100644
--- a/drivers/pci/controller/cadence/pci-j721e.c
+++ b/drivers/pci/controller/cadence/pci-j721e.c
@@ -531,7 +531,7 @@ static int j721e_pcie_probe(struct platform_device *pdev)
 
 	ret = j721e_pcie_ctrl_init(pcie);
 	if (ret < 0) {
-		dev_err_probe(dev, ret, "pm_runtime_get_sync failed\n");
+		dev_err_probe(dev, ret, "j721e_pcie_ctrl_init failed\n");
 		goto err_get_sync;
 	}
 
-- 
2.51.0



