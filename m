Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDF6425A63D;
	Tue, 25 Mar 2025 12:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905901; cv=none; b=PAhGB4OMDbpwxENDrmXYd/QrhC2D4beJyeMTpCr2q/tbKRhbuFtikugUoAzvyAsMqluajmDQEq5nf/UFhsA8jeZRG8pvWSW4hTv+n85Ld1IMz8svh0mL6TS30IeXTSZOz0HchpCo41bg36JQL85vBPTdfxnHbLT7gqt4Hblt304=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905901; c=relaxed/simple;
	bh=bqax7SUXDmL0LkHTfV5Tg34wyVYg41YsDsSlGdafIhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7hGJpKcQKD5pybdqvrCMCLxYZRIEMkE4Qdg1FdV50CHTcgC1jtTYUF+9U/U914HO9NS7U9zIepDRDkQJRQ62oGWB2324nw6rPCAoAAqhquEC+umamUQTYFu0s+M8Ws29GGm0ZVnLxUfVXqU02khz8BwFkwqXrvmf4FCFjTkUEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2STmhyRl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2STmhyRl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8151FC4CEE4;
	Tue, 25 Mar 2025 12:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905901;
	bh=bqax7SUXDmL0LkHTfV5Tg34wyVYg41YsDsSlGdafIhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2STmhyRlNwt1i6obLggX6P7vbkiNUUI2J+QzeGGW8wnFZzWa2NC1hbwzp4UhtaD7E
	 ubsthgUl14hJ7HjFmRrbC61878OwoVMI8cd+02V1F+nhS7VVhZ9NChAbAXnVOqI93h
	 7PRoyD36rPAW7AIUP1Asw0pVUntqNxvCIMXABaas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 009/119] Revert "arm64: dts: qcom: sdm845: Affirm IDR0.CCTW on apps_smmu"
Date: Tue, 25 Mar 2025 08:21:07 -0400
Message-ID: <20250325122149.300351600@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit f00db31d235946853fb430de8c6aa1295efc8353 ]

There are reports that the pagetable walker cache coherency is not a
given across the spectrum of SDM845/850 devices, leading to lock-ups
and resets. It works fine on some devices (like the Dragonboard 845c,
but not so much on the Lenovo Yoga C630).

This unfortunately looks like a fluke in firmware development, where
likely somewhere in the vast hypervisor stack, a change to accommodate
for this was only introduced after the initial software release (which
often serves as a baseline for products).

Revert the change to avoid additional guesswork around crashes.

This reverts commit 6b31a9744b8726c69bb0af290f8475a368a4b805.

Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Closes: https://lore.kernel.org/linux-arm-msm/20250215-yoga-dma-coherent-v1-1-2419ee184a81@linaro.org/
Fixes: 6b31a9744b87 ("arm64: dts: qcom: sdm845: Affirm IDR0.CCTW on apps_smmu")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250225-topic-845_smmu_not_coherent-v1-1-98ca9d17471c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
index cb9fae39334c8..5eb076a109f47 100644
--- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
@@ -5159,7 +5159,6 @@ apps_smmu: iommu@15000000 {
 				     <GIC_SPI 341 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 342 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 343 IRQ_TYPE_LEVEL_HIGH>;
-			dma-coherent;
 		};
 
 		anoc_1_tbu: tbu@150c5000 {
-- 
2.39.5



