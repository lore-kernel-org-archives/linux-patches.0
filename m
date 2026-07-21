Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEED522B8DF;
	Tue, 21 Jul 2026 18:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660180; cv=none; b=RFnjg7VWMHbOVTVOzdEnu++i0uljtB3frR2KPU25O+vZIa1RiKjd7t4jsJlMJY4b2LBK0cU0n2Kpi6tyvmfr1PvbvbWKUl92EmFluvdmL+DBiCG5hvhf67WybcIJkL3u+cn7zpHSpXRFzdjHUcxfNH86B4frCvM3Vi4wNDNuCTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660180; c=relaxed/simple;
	bh=DTuCihMeS5j2NBsSztMb+tOaiinJE8G6U3KjavUZLVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nG/t9AERLDUaeXuP6U9AV3C0DvmmNZuxODzF8w60T6FiJXkVkJdYuCeNhyhEFtLtTxxz0TJYjxXZ+WCwWTfbwoJGkmQtdEBmXyBF1oopgvwPxL4QNKF5nhdeyzM6jtiPkgEY9tUEHOR7CSxkBKUVmqGUw+wGPY7txtIKf4oYFlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmQAEj1C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmQAEj1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E251F000E9;
	Tue, 21 Jul 2026 18:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660179;
	bh=Ry36cZp90RIRF3Ta3+e0VqDiJHB7AD9HL/niOhvhzZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmQAEj1CRZHnQzAeul15ZQTwg3yAamdmw1UDSTjhtlkNu6LZe9r6KL5HiHgy8p+Fw
	 qu5D4IpeskneHHvYQmr9kP5kiAHLb8OgT1JbYs3rb5K5d2DJBS+PyMxF4Gk1+Nv3ml
	 mjw3Z15hpvfRNI+jMaR7D7WRnaW41xkzfrYqOtGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Hans Zhang <18255117159@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0883/2077] PCI: mediatek-gen3: Fix incorrectly skipped pwrctrl error message
Date: Tue, 21 Jul 2026 17:09:16 +0200
Message-ID: <20260721152613.631179089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 8ba433753d9b131c2e43b1ff7ba8c5730cef8231 ]

When pwrctrl integration was added, the error message for
pci_pwrctrl_create_devices() failure was incorrectly added after the goto
statement, causing it to be skipped.

Move the goto statement after the dev_err_probe() call so that the
error message actually gets printed (or saved if probe is deferred).

Fixes: 1a152e21940a ("PCI: mediatek-gen3: Integrate new pwrctrl API")
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/all/adjNaKB5KGpl6qIp@stanley.mountain/
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Hans Zhang <18255117159@163.com>
Link: https://patch.msgid.link/20260512103347.1751080-1-wenst@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-mediatek-gen3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-mediatek-gen3.c b/drivers/pci/controller/pcie-mediatek-gen3.c
index e6acca7e79a0ff..88e3fdcb74c062 100644
--- a/drivers/pci/controller/pcie-mediatek-gen3.c
+++ b/drivers/pci/controller/pcie-mediatek-gen3.c
@@ -1222,8 +1222,8 @@ static int mtk_pcie_probe(struct platform_device *pdev)
 
 	err = pci_pwrctrl_create_devices(pcie->dev);
 	if (err) {
-		goto err_tear_down_irq;
 		dev_err_probe(dev, err, "failed to create pwrctrl devices\n");
+		goto err_tear_down_irq;
 	}
 
 	err = mtk_pcie_setup(pcie);
-- 
2.53.0



