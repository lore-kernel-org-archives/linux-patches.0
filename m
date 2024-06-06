Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2143B19EEA4;
	Thu,  6 Jun 2024 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683122; cv=none; b=WfUDv8Jbw+kn0NWA2NAVmLuAWYIheyMbIdr9kDsJ8wH1b7XlJCK4OAevxhCNLLb9TLZP/K3WgWiRugUTWZTngZ77xqThU1+c/Zhy/rZsVR0DxIe6Nn12HW8nG+Nfi8PCCC303M+WE53nVOnY5GKoaYHJVgGQRBEF2ycd5eGzgIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683122; c=relaxed/simple;
	bh=WDuntyQUKmYArG96SSfC9CD1hiAQFSxKZmHeBmoCGSo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DgFFlphVm0FQzX1mwCWTX7TrzedjKFk4hbdI47+++h8AcUGlkmi0Rfn2xeaqeHdnF/66/NOoxzeL4CaRZpAIG05aENtJuwkcenznxInik3i4ndM+vXCYnGbgKgMG//z8k1mUnRz0rlo9PDmU5PqTh1te0PVx75llm1OFpzQsRQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Xpex/ZT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Xpex/ZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBCA1C2BD10;
	Thu,  6 Jun 2024 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683122;
	bh=WDuntyQUKmYArG96SSfC9CD1hiAQFSxKZmHeBmoCGSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2Xpex/ZTiDJNwJ8A1M7ApAMZtW3ECvuwS5WwRiVNTeREjMTISknj+LQawnPnpslcs
	 s95/XT6S/en/2AB5GF4fH2lmIus5L68Te4hpOVMXiCJSolh3SNtEeeXzrKg0D/wwOW
	 A9cAZDC9Mz4q7RcIszRoplLsE+nm6UIH8oK94uAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 062/744] regulator: qcom-refgen: fix module autoloading
Date: Thu,  6 Jun 2024 15:55:34 +0200
Message-ID: <20240606131734.405537640@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit ddd3f34c10002e41ed3cd89c9bd8f1d05a22506a ]

Add MODULE_DEVICE_TABLE(), so the module could be properly autoloaded
based on the alias from of_device_id table.

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://msgid.link/r/20240410172615.255424-1-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-refgen-regulator.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/regulator/qcom-refgen-regulator.c b/drivers/regulator/qcom-refgen-regulator.c
index 656fe330d38f0..063e12c08e75f 100644
--- a/drivers/regulator/qcom-refgen-regulator.c
+++ b/drivers/regulator/qcom-refgen-regulator.c
@@ -140,6 +140,7 @@ static const struct of_device_id qcom_refgen_match_table[] = {
 	{ .compatible = "qcom,sm8250-refgen-regulator", .data = &sm8250_refgen_desc },
 	{ }
 };
+MODULE_DEVICE_TABLE(of, qcom_refgen_match_table);
 
 static struct platform_driver qcom_refgen_driver = {
 	.probe = qcom_refgen_probe,
-- 
2.43.0



