Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58E134EF15;
	Fri,  4 Sep 2026 05:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499639; cv=none; b=cA2fcNsVPWKW2A/GvYaq3OrTTEh2YGVeh4+4/4rncf+Vifajli6zz76C6BCtf6mC2Wk7UTPjvHgNrwajBzVxfs1DUHpWKc9fpohjGo6+MbHpXtzUG9DXCL3sklJisjVT1/gs3zPtHQo6tJSRWPL1tOJZW3whMZ3Kzax0yhGydsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499639; c=relaxed/simple;
	bh=VZs15+yiQvA4yXC8vMHLghd6Iksj29tdpxIGRMQ68xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvKnfyLEx77FFvwV1cp/FyZckCWjv4gRaSmBhA64A/1Ij1TT1gtlS7AOOscDyAtl8hMROZIfxkRUqBjg7ew3SWPc+zSbqZSlusj0oXT5NNG4ogjF6/Yed5zdVKksOFfrsGETldohgsQZ4wQogkqfB4y/AKT0uGUAkMp9lKRU2X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlQuLv74; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlQuLv74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBEF1F00A3D;
	Fri,  4 Sep 2026 05:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499638;
	bh=/2DsLhgX8Tn0UFATdBMGcQpv2hD9RSdkla6NHSZVbU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlQuLv746cU27us4T4nkkNiuCq95Opj/tAsTbaDVd9XdlalyBGBfxvk+lvfzK7Ef2
	 JmNv/k4Yq0Au0noHznOfWm3YA4l1Zxnb+r8amaZ+Hy2Q+K9jiKsaRSu0A3PZBFknie
	 EqRVBSVnv3jVpQYj3VTNXQSH4Zb1H0mK3PKiqxpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 451/713] regulator: qcom-refgen: correct the regulator type to CURRENT
Date: Fri,  4 Sep 2026 06:56:59 +0200
Message-ID: <20260904045813.937427809@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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


