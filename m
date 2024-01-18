Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E177423771;
	Thu, 18 Jan 2024 11:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575654; cv=none; b=LRGVd7htSCp0rMgG/KIz+HUArJA0tdHxau/Apkzz4iywhlW9udSM/f7+qZeurevTxZQDskQtVXMOuhEzHTtafEO5fWHyX//fT0Nz0FLHlx/hVkPeHJgkkbjFDp9Eh+zbezkUnlNaB1Df73DLAVEkV6LUNAEe54othFKhkwiqu60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575654; c=relaxed/simple;
	bh=JxYIei1PFAGeM7q2ieolSJH7sKPFh0JGil0xkVuwVsQ=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=f2/em25njq9i9LOgSp2FqlioyzyFiAd2WS4VQPRw8lTddzkr2yCLtneUI1+bqxA5JY0go8JJXOysQLR7020OpgDo03K9buVQsu7fJVPjxXL0VwS/4vu2yKrE0Qut2bgAZbm6QF3V8lcinKFHL6t+qX0zx6PDAgx6/JeBiJouL2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFPNnBx0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFPNnBx0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42044C433F1;
	Thu, 18 Jan 2024 11:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575653;
	bh=JxYIei1PFAGeM7q2ieolSJH7sKPFh0JGil0xkVuwVsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFPNnBx0E3rvY+YZZasvuhnCxyjFbSX/8Xb1odthF4fw+fmp3PYFV3NQtor0ztH4+
	 vliZ61Hf9Mad2MJzpKz9BVF9oTDIW8eOYMRai74nM5VMxvAb9cCLbQtXxfJpBDCQC5
	 PoOXba/yk/zM15ZzGhEh7y5ABL4w2pzh0siUfb88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/100] reset: hisilicon: hi6220: fix Wvoid-pointer-to-enum-cast warning
Date: Thu, 18 Jan 2024 11:49:05 +0100
Message-ID: <20240118104313.390160721@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b5ec294472794ed9ecba0cb4b8208372842e7e0d ]

'type' is an enum, thus cast of pointer on 64-bit compile test with W=1
causes:

  hi6220_reset.c:166:9: error: cast to smaller integer type 'enum hi6220_reset_ctrl_type' from 'const void *' [-Werror,-Wvoid-pointer-to-enum-cast]

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20230810091300.70197-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/reset/hisilicon/hi6220_reset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/reset/hisilicon/hi6220_reset.c b/drivers/reset/hisilicon/hi6220_reset.c
index 5ca145b64e63..30951914afac 100644
--- a/drivers/reset/hisilicon/hi6220_reset.c
+++ b/drivers/reset/hisilicon/hi6220_reset.c
@@ -164,7 +164,7 @@ static int hi6220_reset_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
-	type = (enum hi6220_reset_ctrl_type)of_device_get_match_data(dev);
+	type = (uintptr_t)of_device_get_match_data(dev);
 
 	regmap = syscon_node_to_regmap(np);
 	if (IS_ERR(regmap)) {
-- 
2.43.0



