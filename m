Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0842EBDCD;
	Wed, 21 Jan 2026 18:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020152; cv=none; b=jn10XWnPpNvDdizuSZT0NGDiH8FL8SIXO6S9VLdHSBQc1y/UecUQpG5Qdia/fSNy7wuWwbFiM+iCaqZyoA8DrIyUljeWYdHnJaa5lQBmctvnpCAnFS+rYG4mPi1sJtfI2RyLPhTqz4M0hanzqTmEOWCr0tRH+TMXr0gGjwXK1uI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020152; c=relaxed/simple;
	bh=4tvK9EDi5LijkdjS7Lbu2wEPxCApP75pCLdI27vSp3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFJZW8op7fexZEBke/MOh8xl8M31n1Cv4nPLnZFFMSwbZcV/u604X1yI5m30n7spTi1jRnlpwLJ9XIAVBRxHsA0Uwq/ablQjaFuvJiV9D8IYdsOaRvBV7pnmEaZZiO6gfL0MS53SdKLvfPnizH9vC1vd9l6eDI6xEPnT4tp22Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OHl+ccSh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OHl+ccSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E760C4CEF1;
	Wed, 21 Jan 2026 18:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020152;
	bh=4tvK9EDi5LijkdjS7Lbu2wEPxCApP75pCLdI27vSp3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OHl+ccShG91QSEqs0Mo0UdbkPRiZvkamOouluucWH/NIAffbgvJqi/0/7dtOBjBoF
	 utqUvr175Iw2x7+9yoUuwEbT9kyKpgJ47goPfWVCAKT5ROyG0Ic2E8uEHyuEatsmjG
	 rn+bqVtglslCC6A3K6cKbvZAaqNa3vcunWlfprPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 075/198] phy: stm32-usphyc: Fix off by one in probe()
Date: Wed, 21 Jan 2026 19:15:03 +0100
Message-ID: <20260121181421.256738953@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 27fe92f73f331..b44afbff8616b 100644
--- a/drivers/phy/st/phy-stm32-usbphyc.c
+++ b/drivers/phy/st/phy-stm32-usbphyc.c
@@ -712,7 +712,7 @@ static int stm32_usbphyc_probe(struct platform_device *pdev)
 		}
 
 		ret = of_property_read_u32(child, "reg", &index);
-		if (ret || index > usbphyc->nphys) {
+		if (ret || index >= usbphyc->nphys) {
 			dev_err(&phy->dev, "invalid reg property: %d\n", ret);
 			if (!ret)
 				ret = -EINVAL;
-- 
2.51.0



