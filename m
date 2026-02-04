Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE91A41B379;
	Wed,  4 Feb 2026 14:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216891; cv=none; b=kavbhWPLKawZpZuxLAEZjZqsBV7kRc1T6kX4siWVS6N5Rq1WrrkT2CJfVmJ+RVfR48Sev4c/gTVe7NdUxN22iiDOpIBarnNBdXLGZ01xOmHBrLq+pMixUz2/z5RiR8o4viqU0+GFnr2Hm/P1R/ft44woGNjEBAPkXgTdviYDm2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216891; c=relaxed/simple;
	bh=SedTDsa8ebpaI+npEa5HRGvLalRwXIzZI0U9sGcqBbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a5a9qG/sJQXmbCfDfMTaKKNFxDfT44NDXz8KXOwXs3V34qeZ15CnEzi6AEgc7vFWWlOMspZHJbzdz6kkqFcyr1m2Qr97LPjSi3VtvSgomZnY2stUaCX38lqDgFHxZUcJftKG70nL/YJMuimA8ElMS//V6/ZDwZX8qb6CRzfuOMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBE5m485; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBE5m485"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 605EFC116C6;
	Wed,  4 Feb 2026 14:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216891;
	bh=SedTDsa8ebpaI+npEa5HRGvLalRwXIzZI0U9sGcqBbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBE5m485uPHRn/v7jCvczk+XnS69ma7yhQIzKS2ptLhWpvRMuuYcieIJMVq27FQOw
	 D9djAdZe8wlzt+Epxf+9YB2lVROSN8FIe4wuep9wFmPL9FfluT6cYJLS4dQ+8+FGXk
	 MMTbD62On/yfHyCK/Yf4oY+jio/WPMHTYdy293NY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/206] phy: stm32-usphyc: Fix off by one in probe()
Date: Wed,  4 Feb 2026 15:37:30 +0100
Message-ID: <20260204143858.895216872@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit cabd25b57216ddc132efbcc31f972baa03aad15a ]

The "index" variable is used as an index into the usbphyc->phys[] array
which has usbphyc->nphys elements.  So if it is equal to usbphyc->nphys
then it is one element out of bounds.  The "index" comes from the
device tree so it's data that we trust and it's unlikely to be wrong,
however it's obviously still worth fixing the bug.  Change the > to >=.

Fixes: 94c358da3a05 ("phy: stm32: add support for STM32 USB PHY Controller (USBPHYC)")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://patch.msgid.link/aTfHcMJK1wFVnvEe@stanley.mountain
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/st/phy-stm32-usbphyc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/st/phy-stm32-usbphyc.c b/drivers/phy/st/phy-stm32-usbphyc.c
index 27f7e2292cf0b..1e3f73cee9efd 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -530,7 +530,7 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 		}
 
 		ret = of_property_read_u32(child, "reg", &index);
-		if (ret || index > usbphyc->nphys) {
+		if (ret || index >= usbphyc->nphys) {
 			dev_err(&phy->dev, "invalid reg property: %d\n", ret);
 			if (!ret)
 				ret = -EINVAL;
-- 
2.51.0



