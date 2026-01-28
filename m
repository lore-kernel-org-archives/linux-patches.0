Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E58F82475E3;
	Wed, 28 Jan 2026 15:30:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614219; cv=none; b=F4nUwaVBYIJqrWs/q6eDiN1BTsV/ZHs7BqaUr67OOu/Y2kIlnWhBcLPBKlRvooqaI8gLK2ZbmiZ/Fb6TJs1grpaK2amgbvv0gvRghyg4+jGcseQ69+bUyei/iW/xtZjhfv1Qmz202NEV6gC8WzHENcXd8kNtmFjsI1UrWaPgTWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614219; c=relaxed/simple;
	bh=6OISrTO6/WeMj6SsF00Ylvpr5sdKJW5J8Z9hDcbYcOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYhvHWWP9cQyWzLNC5vWh6eUQ6fWgO9QB6r0nxPl/uoGRPLIg1y9N2z7CnD9ZOX866NLWtRZsNjiKJbSRm+xANbA86hiiEvD2J7fIUxgZ8iLtravHG03ZRf9PUaEjSgfFrcZqdS29rbuRfQeYFnmFA5J2utQfgF4Toa0yGQaFyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdobODZi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdobODZi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58438C4CEF1;
	Wed, 28 Jan 2026 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614218;
	bh=6OISrTO6/WeMj6SsF00Ylvpr5sdKJW5J8Z9hDcbYcOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdobODZiQPOcDfw+aMRzDhdeC8qXqUAFMBWULpOPoaDyPrbqhNRXluyl/8gtSdz0S
	 SPlTtSbNzlzErFmrEERIIs6VXFP/CWleA5s8r2qKhRLCrE48dp2B2FdfA6DxfD5qgf
	 8O2EB7rcVoZWD4qwHLhQEX4Cv2X8w4vJczSjw2Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/254] phy: stm32-usphyc: Fix off by one in probe()
Date: Wed, 28 Jan 2026 16:20:15 +0100
Message-ID: <20260128145346.108760815@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f8374a7f3a655..4a8f2ab65571a 100644
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



