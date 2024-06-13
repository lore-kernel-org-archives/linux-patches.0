Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35CB46EB56;
	Thu, 13 Jun 2024 12:28:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281701; cv=none; b=dMTPn6gR9vFUuuoZefRXoWMshl+8y+olw92OUo4mVO88JlHeSkDIhpvKeP1TLcpqdO/RWGuT12jGYDPpfvSXus49NV54qyY1NUuXzxRo3z2OlPxP89xU5F+P6VoF3cYeItO65XWRTmB8RDEOeYit1wV80DTG55Xdh5sUjI9mDJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281701; c=relaxed/simple;
	bh=CuxfuUL+BfY+bIzQBAcA0/5S+k4b8BtCTg/c3XN0Hnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnlwIsTsoKBfjeKkFziwMBnmNaWE2CSN3wYH8+eJL5LcVsjznR5sYKGLAVDtME0ZuGxzRbVCHXagWkJF73lmv02i6bxBb70GLF6MEkTFy/HGJiH+S2weT1Q/8qlYZhuCWzuN0NHFKXJqy+85vEgGdH4f+sq6kV68DIlCLXRNDfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCrc4aam; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCrc4aam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC4CBC2BBFC;
	Thu, 13 Jun 2024 12:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281701;
	bh=CuxfuUL+BfY+bIzQBAcA0/5S+k4b8BtCTg/c3XN0Hnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VCrc4aamC0x615xeHOjW7qx72jbIDRjnjecqCRemO50TeXmEim5Rs+B2QGcyiN4UI
	 Gcf9lFmACljJbUbA+aC8Yph7/pw/KRMHzKuDjzlTnSc6SRK1P51BMZQkNE8xOZE4VI
	 2eVYLebKb9ZG0LoqW77pZ3N1YU+MPISA6L9Yc4KI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 027/402] regulator: vqmmc-ipq4019: fix module autoloading
Date: Thu, 13 Jun 2024 13:29:44 +0200
Message-ID: <20240613113303.198398949@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 68adb581a39ae63a0ed082c47f01fbbe515efa0e ]

Add MODULE_DEVICE_TABLE(), so the module could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://msgid.link/r/20240410172615.255424-2-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/vqmmc-ipq4019-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/vqmmc-ipq4019-regulator.c b/drivers/regulator/vqmmc-ipq4019-regulator.c
index 6d5ae25d08d1e..e2a28788d8a22 100644
--- a/drivers/regulator/vqmmc-ipq4019-regulator.c
+++ b/drivers/regulator/vqmmc-ipq4019-regulator.c
@@ -86,6 +86,7 @@ static const struct of_device_id regulator_ipq4019_of_match[] = {
 	{ .compatible = "qcom,vqmmc-ipq4019-regulator", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, regulator_ipq4019_of_match);
 
 static struct platform_driver ipq4019_regulator_driver = {
 	.probe = ipq4019_regulator_probe,
-- 
2.43.0



