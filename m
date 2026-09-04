Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D4B35AC03;
	Fri,  4 Sep 2026 05:53:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501207; cv=none; b=h/wecRezw1gN00PaiTljPcc5hdKE3+3+xoyvEks8unZkLs+3uaD2d+ngbsCYfVi49vg3MK9Wlz6ERngh+sAzFCzR513nN8jPDauQ8x+0BszEzRYt3beHJ/EmsY2Ks0LyRJiIPH5Mkfxoer1h63gFwNoKCaZWNZNB3WMFaFpWhMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501207; c=relaxed/simple;
	bh=IiFaO/v7VOrkTw/JPrJaIFoIny4MLAP6yUJa62W7Nk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FVvUWTJQ6zovvSAEaYBZIXX74C+LGy2XWW50ivlC1uGsBDkcjJ0fF4oyDmahgKmRmJfhzzZhrhBH00bMAsM3A/p3F1JX+YOAnfltEhJTVfDaivAiP++qhTDbkymakqHkp3LEBTqglHadLGurOrnbSpZ2Rk+0lk7diFLRlNKgHWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SsmnIBXu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SsmnIBXu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6911F00A3D;
	Fri,  4 Sep 2026 05:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501206;
	bh=2ZWv6KdwM1FwtoFrVMLNmyjby8lqO5MbaW8t6cFItvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SsmnIBXulxp6S4TPmqrGKKiAVnXs8/Z0FBQ4BmJVy6PGiw76xBoG9rm+oUc9iYmzt
	 9nwXyZfT4C/nA28fwJ5qskAEp8wsJON4sFz5QehsDnTHUZJwcMgzTJj9asAyKziL+Z
	 An5Gex/FI0tnuyYydItPINmZl2+mcAZxA2TAtLc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 328/552] regulator: qcom-refgen: correct the regulator type to CURRENT
Date: Fri,  4 Sep 2026 06:58:05 +0200
Message-ID: <20260904045757.704462775@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

commit 05dfeb2d0ccf87a7b92cd149a393b8423a26a04e upstream.

As per the REFGEN IP team, this block supplies the reference current to
the PHYs in the SoC. So, correct the regulator type to REGULATOR_CURRENT
to match with the HW behavior.

Fixes: 7cbfbe237960 ("regulator: Introduce Qualcomm REFGEN regulator driver")
Cc: stable@vger.kernel.org
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Link: https://patch.msgid.link/20260617-ipq9650_refgen-v4-1-c505ea6c6661@oss.qualcomm.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/regulator/qcom-refgen-regulator.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/regulator/qcom-refgen-regulator.c
+++ b/drivers/regulator/qcom-refgen-regulator.c
@@ -66,7 +66,7 @@ static const struct regulator_desc sdm84
 	.enable_time = 5,
 	.name = "refgen",
 	.owner = THIS_MODULE,
-	.type = REGULATOR_VOLTAGE,
+	.type = REGULATOR_CURRENT,
 	.ops = &(const struct regulator_ops) {
 		.enable		= qcom_sdm845_refgen_enable,
 		.disable	= qcom_sdm845_refgen_disable,
@@ -82,7 +82,7 @@ static const struct regulator_desc sm825
 	.enable_time = 5,
 	.name = "refgen",
 	.owner = THIS_MODULE,
-	.type = REGULATOR_VOLTAGE,
+	.type = REGULATOR_CURRENT,
 	.ops = &(const struct regulator_ops) {
 		.enable		= regulator_enable_regmap,
 		.disable	= regulator_disable_regmap,


