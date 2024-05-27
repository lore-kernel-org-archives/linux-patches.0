Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0004168C4;
	Mon, 27 May 2024 19:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837609; cv=none; b=pjqi1esUODzvbGtDWSu7RtC45WWfaYnG3Ay2P5HfG+/eQkbTqfhHg8XvE/jHngHZVRJ17iLQ8D2We46rECxtu5UkmAG5TqoKN7i8lVNfmWfXNNKa8HLqAO0Vnmc79ZSWCwwLfTkZZjoXM144bqWo39eW1UHrE59vFtWdRdVcA7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837609; c=relaxed/simple;
	bh=G4eZBCHLepS1eGsvX2oRQlVJz4VVTz3WtIHma4afWs4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q1okcQ+BfQpAd1XggSg1JR272toGrPLbcInJX+XzKr1eUDvJwAmxei85iq8v74TCz7ciik8umxTfIU/h9JLLKv1amQ1iN5DHkfF/vTf3hG4875wxqocfvoT1junOlJcbCd9S0cpj9s4YbFTKP7/MAGFCDp+oSneimELdyXmGAes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vWGyVL96; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vWGyVL96"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4BE0C2BBFC;
	Mon, 27 May 2024 19:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837609;
	bh=G4eZBCHLepS1eGsvX2oRQlVJz4VVTz3WtIHma4afWs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vWGyVL96LY27yiEW2wUirvh1a3NX/liCtKpPUvNYZwp/GPw1ZIP7S2LFoDLGI+Npp
	 h6XkgNhroVdkBFDzflyZoraqc9aHb3nVjlqK3YQ4kHfnXoi4dLg1LlL7nzYnmuzMae
	 kBTyz++QMN3ZJUpEN0G5NpAO9NOv9Uir6MqS8zvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 075/493] regulator: vqmmc-ipq4019: fix module autoloading
Date: Mon, 27 May 2024 20:51:17 +0200
Message-ID: <20240527185632.426921204@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 086da36abc0b4..4955616517ce9 100644
--- a/drivers/regulator/vqmmc-ipq4019-regulator.c
+++ b/drivers/regulator/vqmmc-ipq4019-regulator.c
@@ -84,6 +84,7 @@ static const struct of_device_id regulator_ipq4019_of_match[] = {
 	{ .compatible = "qcom,vqmmc-ipq4019-regulator", },
 	{},
 };
+MODULE_DEVICE_TABLE(of, regulator_ipq4019_of_match);
 
 static struct platform_driver ipq4019_regulator_driver = {
 	.probe = ipq4019_regulator_probe,
-- 
2.43.0



