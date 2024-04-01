Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96AB24778C;
	Mon,  1 Apr 2024 15:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711986605; cv=none; b=kowata0hJzOohr8yyk6XBnny65WG5Aqn6Kl7cdVYkFf64v90gn97zVlhdKGoVnTbS6dyx9cUCpXUGoMGkg7Ilt+CDF0ZYiQcIep1UjST7BPKb3gV+1bQsM7H2Yj3/dfeZWba4FC8dczquubuSY+7QiBpdsOdleAZcpu95Al0jfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711986605; c=relaxed/simple;
	bh=B1TbLJoU5rgwCzf/TI/zJ3FhVHZpwpCjLXUKXEwmm6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLp4KFPx006kQF4ngnyWqRm7KCcGMHC5/EsQNyqOlIVNo32/aFwkYowaIdwvpc8Yq+BinK5qnjlTZPYKB8tZMHpnje1poDmSoZs+Ufwyxq2G/xXe3TGmsWTzsxo37vWBt8rO1/yqiiXdNjSe4k0eXMbfy906zjJNZTOkdioFkc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHy2ESFG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHy2ESFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0532C433C7;
	Mon,  1 Apr 2024 15:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711986605;
	bh=B1TbLJoU5rgwCzf/TI/zJ3FhVHZpwpCjLXUKXEwmm6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHy2ESFGBSRyDPXYbGUzmDkNi5N+CqV2oAOXyD8YqISEP7zReyyTGpaxu1yRCFl7b
	 sSExVcuKxnNPLoGWpTTbAcEdkuRXCU+fIfpS5gBxWYHHVypdW52UqG9uNf23Ve7h8t
	 aOp132/VB65S6/OfrCIxZ3+nWvNnIdaC+qEWMcEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 027/399] arm64: dts: qcom: sm8550-mtp: correct WCD9385 TX port mapping
Date: Mon,  1 Apr 2024 17:39:53 +0200
Message-ID: <20240401152549.973362035@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit b66966b1bbc0aa58f7af83cbd56d5a206892857c ]

WCD9385 audio codec TX port mapping was copied form HDK8450, but in fact
it is offset by one.  Correct it to fix recording via analogue
microphones.

The change is based on QRD8550 and should be correct here as well, but
was not tested on MTP8550.

Cc: stable@vger.kernel.org
Fixes: a541667c86a9 ("arm64: dts: qcom: sm8550-mtp: add WCD9385 audio-codec")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20240124164505.293202-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550-mtp.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
index c1135ad5fa696..a26e169a802a4 100644
--- a/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
+++ b/arch/arm64/boot/dts/qcom/sm8550-mtp.dts
@@ -874,7 +874,7 @@ &swr2 {
 	wcd_tx: codec@0,3 {
 		compatible = "sdw20217010d00";
 		reg = <0 3>;
-		qcom,tx-port-mapping = <1 1 2 3>;
+		qcom,tx-port-mapping = <2 2 3 4>;
 	};
 };
 
-- 
2.43.0



