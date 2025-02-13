Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E4D2281349;
	Thu, 13 Feb 2025 14:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457324; cv=none; b=S/kgYXCBTYzagIpRcpWpi+vGl+7ElfSkDiF4SQ2ZQ3SjTPKrMbvW0Kx3kdFizJii5HDqLmmlY/eFpEQLZt0mK5gcLA+7zaH021VT+SsVjsf/O8U9WIVKVV3DihxWeGCE3/rv1NlqICIkKOAkQaNRNmXfX7UqwmAchVzxn0TcHLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457324; c=relaxed/simple;
	bh=4rcWcO02J1qvPlNxQopmOfWIF17WERIUBRW5EWNwnT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C7n02iPshY9jgBRdiWwG/i8RV62PL1bTE30QU5/Kdi4ibR1n6rIfu8czMr4dgNi9I1zUTb7wDIWAW7PmigSR6mNK9UXD7Rt+Dbb00jCuCWQkPK1Nb3tT+B3Vwin+dqCKL72owAatzq8lFd3xa8EdDKulyJCxNlWG9rL+j57jy3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3nyCtSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3nyCtSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53B41C4CED1;
	Thu, 13 Feb 2025 14:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457323;
	bh=4rcWcO02J1qvPlNxQopmOfWIF17WERIUBRW5EWNwnT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3nyCtSEAiAaLz7e+/ZfIA/8fjzZBankSnmgZs9VSKXF14KBtKadKP49g49U71K6P
	 7MgEf7+JX6DhzX3SADcr+B7+F+IyqPunKl3ShdaR1TuDeUFk8Xl5ANS8EpE0AJf+aE
	 FbMq0XsxYWeoYnPvRxl/pWg1gTSwqP1i+KyAlvI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Acayan <mailingradian@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 079/422] iommu/arm-smmu-qcom: add sdm670 adreno iommu compatible
Date: Thu, 13 Feb 2025 15:23:48 +0100
Message-ID: <20250213142439.603805084@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Acayan <mailingradian@gmail.com>

[ Upstream commit 42314738906380cbd3b6e9caf3ad34e1b2d66035 ]

Add the compatible for the separate IOMMU on SDM670 for the Adreno GPU.

This IOMMU has the compatible strings:

	"qcom,sdm670-smmu-v2", "qcom,adreno-smmu", "qcom,smmu-v2"

While the SMMU 500 doesn't need an entry for this specific SoC, the
SMMU v2 compatible should have its own entry, as the fallback entry in
arm-smmu.c handles "qcom,smmu-v2" without per-process page table support
unless there is an entry here. This entry can't be the
"qcom,adreno-smmu" compatible because dedicated GPU IOMMUs can also be
SMMU 500 with different handling.

Signed-off-by: Richard Acayan <mailingradian@gmail.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20241114004713.42404-6-mailingradian@gmail.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 6372f3e25c4bc..601fb878d0ef2 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -567,6 +567,7 @@ static const struct of_device_id __maybe_unused qcom_smmu_impl_of_match[] = {
 	{ .compatible = "qcom,sc8180x-smmu-500", .data = &qcom_smmu_500_impl0_data },
 	{ .compatible = "qcom,sc8280xp-smmu-500", .data = &qcom_smmu_500_impl0_data },
 	{ .compatible = "qcom,sdm630-smmu-v2", .data = &qcom_smmu_v2_data },
+	{ .compatible = "qcom,sdm670-smmu-v2", .data = &qcom_smmu_v2_data },
 	{ .compatible = "qcom,sdm845-smmu-v2", .data = &qcom_smmu_v2_data },
 	{ .compatible = "qcom,sdm845-smmu-500", .data = &sdm845_smmu_500_data },
 	{ .compatible = "qcom,sm6115-smmu-500", .data = &qcom_smmu_500_impl0_data},
-- 
2.39.5



