Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E1924CEEA;
	Sat, 12 Sep 2026 13:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220428; cv=none; b=S9dpvBeMyNxQbGvZr50kmWJB2rPcs6p/mj1pcBatAE8MahADFhDM/jSf25lmDKnqutdReZqjAVlhzDgqdrt1DFP4MolxITlGIMK+OGlWRgNP9vozmzNgBVu1IspmeQT/KpkI6Vi+58FI/izcOKyRN8/QXxLQuD/qVJcbJloSxIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220428; c=relaxed/simple;
	bh=UY6JlAvfVpzKK3ENQPY1Jlz3qHuyJ+GXFoyHhNLYG6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hl6Fz4RDS50o+OEx00xlOk9cQ6YS4QDILBcwAXpBOwSzBSFsIiU9HcfORgSkKlYvWNqEuB9WoZarAwI8/N0bujtu8QBP6nu3yPZPmhdBeBf+OUbDqoaDghoRjNpMyGsQ7iSLOQb9H7hoKV2UpyDAkz9RCdH6VkGMiHgzSIa3PCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bS0HoVuV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bS0HoVuV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2861F000FF;
	Sat, 12 Sep 2026 13:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220427;
	bh=yZcRIGpvauV+FGfmADFWVhWIcIWo/OVb+ww9ii+8lDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bS0HoVuVWu1vpGuc6Uwc8f5QjXBfaIe+7mykKgarAB6niDKrMH3YIwo2OPwtF4Yws
	 huNAjZwZGAP8qQtLWV+l5bomIGBPmVsa/PqKcZizslDu5Z+unf/IPEHBRP+hnXLiE9
	 5Oqc0b0Fkoc3yO6RWbOBiE4XWgQmkFfpvcPMHSi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 0176/1424] regulator: qcom-refgen: correct the regulator type to CURRENT
Date: Sat, 12 Sep 2026 08:43:28 +0200
Message-ID: <20260912065611.234106720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -66,7 +66,7 @@ static struct regulator_desc sdm845_refg
 	.enable_time = 5,
 	.name = "refgen",
 	.owner = THIS_MODULE,
-	.type = REGULATOR_VOLTAGE,
+	.type = REGULATOR_CURRENT,
 	.ops = &(const struct regulator_ops) {
 		.enable		= qcom_sdm845_refgen_enable,
 		.disable	= qcom_sdm845_refgen_disable,
@@ -82,7 +82,7 @@ static struct regulator_desc sm8250_refg
 	.enable_time = 5,
 	.name = "refgen",
 	.owner = THIS_MODULE,
-	.type = REGULATOR_VOLTAGE,
+	.type = REGULATOR_CURRENT,
 	.ops = &(const struct regulator_ops) {
 		.enable		= regulator_enable_regmap,
 		.disable	= regulator_disable_regmap,


