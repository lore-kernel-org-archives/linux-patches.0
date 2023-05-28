Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF15569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:33:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3466EC433D2;
	Sun, 28 May 2023 19:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302417;
	bh=0cFuVe62TUdFTUcmqFWj2tVetyVOeWgFydTmT08ljmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8NFh91h26qZqIXGVFq/bxzW0JfjvuDo/kEJN3D3wLf+JBAyPfFAQd1i5Ln+m89h3
	 KRT+iHRNcoGJ3F95G8Xoci3psQNQsAqOT7Dh+3ts2TzVHbHkqtIi8GwWZ5msvX/DUa
	 GjZMAx99oyX2Us7Vfbl9N4cEpqBT+p/3chvQX2cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev
Subject: [PATCH 6.3 121/127] regulator: mt6359: add read check for PMIC MT6359
Date: Sun, 28 May 2023 20:11:37 +0100
Message-Id: <20230528190840.183167516@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sen Chu <sen.chu@mediatek.com>

commit a511637502b1caa135046d0f8fdabd55a31af8ef upstream.

Add hardware version read check for PMIC MT6359

Signed-off-by: Sen Chu <sen.chu@mediatek.com
Fixes: 4cfc96547512 ("regulator: mt6359: Add support for MT6359P regulator")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com
Link: https://lore.kernel.org/r/20230518040646.8730-1-sen.chu@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/mt6359-regulator.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/regulator/mt6359-regulator.c
+++ b/drivers/regulator/mt6359-regulator.c
@@ -951,9 +951,12 @@ static int mt6359_regulator_probe(struct
 	struct regulator_config config = {};
 	struct regulator_dev *rdev;
 	struct mt6359_regulator_info *mt6359_info;
-	int i, hw_ver;
+	int i, hw_ver, ret;
+
+	ret = regmap_read(mt6397->regmap, MT6359P_HWCID, &hw_ver);
+	if (ret)
+		return ret;
 
-	regmap_read(mt6397->regmap, MT6359P_HWCID, &hw_ver);
 	if (hw_ver >= MT6359P_CHIP_VER)
 		mt6359_info = mt6359p_regulators;
 	else


