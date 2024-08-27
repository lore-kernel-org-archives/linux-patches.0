Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7567244C8C;
	Tue, 27 Aug 2024 14:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770188; cv=none; b=l7gMsNZ53u/UxkxPW+9BquPnI2JTq87LTjaI8++9lFiUfbTSCx7Re9hqMQxE8wY630C1EI0LdBdsSf32MXLHgiApUX+zW5VTUZ2qIqi9j+TC9amkowW1LCRmxKWeyOb3gXRI0zgi4BAsE9NWmoWSdbJQhCH4ph4IbOqwqlymRUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770188; c=relaxed/simple;
	bh=02MzllkMX1LqfgjT2lLDmmbpWQuVtebv/qr0j0HLt4k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dI7n0IA2tR5yyblEAjryGF/KqIPZXXrYgtVq9CLrPzhr/QuBNInoqKNFVujMwSBezfJugGD5i0Z8UvDBfogQ2jea5dqfgZCVKxVBuqtGQ46KaISnKH3JsfgLN8bH4LHu2wbpIYcLrPuXAUzJguwfUVjJnqKEQGqkYoHZDRb8cdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=poEytfFw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="poEytfFw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 755C2C4AF1C;
	Tue, 27 Aug 2024 14:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770188;
	bh=02MzllkMX1LqfgjT2lLDmmbpWQuVtebv/qr0j0HLt4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=poEytfFwzZDKE8VwUMN3+noxU0D+5C+KeVklYeIgQEimKUkqj8exEjz8fqrg8YwSn
	 mTvr7pNOGUnG0slgxZbWtAb3aDtd6/2K6VB2r8pNeEFzmMkKtYC6pz5wfB2vn9Y1ql
	 aoX1y8H3KsjGBq0uD//gFHJT8ksbiIzX0OHLW134=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Acayan <mailingradian@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/341] iommu/arm-smmu-qcom: Add SDM670 MDSS compatible
Date: Tue, 27 Aug 2024 16:35:53 +0200
Message-ID: <20240827143848.057795063@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Richard Acayan <mailingradian@gmail.com>

[ Upstream commit 270a1470408e44619a55be1079254bf2ba0567fb ]

Add the compatible for the MDSS client on the Snapdragon 670 so it can
be properly configured by the IOMMU driver.

Otherwise, there is an unhandled context fault.

Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230925234246.900351-3-mailingradian@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 40503376d80cc..6e6cb19c81f59 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -252,6 +252,7 @@ static const struct of_device_id qcom_smmu_client_of_match[] __maybe_unused = {
 	{ .compatible = "qcom,sc7280-mss-pil" },
 	{ .compatible = "qcom,sc8180x-mdss" },
 	{ .compatible = "qcom,sc8280xp-mdss" },
+	{ .compatible = "qcom,sdm670-mdss" },
 	{ .compatible = "qcom,sdm845-mdss" },
 	{ .compatible = "qcom,sdm845-mss-pil" },
 	{ .compatible = "qcom,sm6350-mdss" },
-- 
2.43.0



