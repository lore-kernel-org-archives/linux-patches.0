Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA204BEE3C;
	Sat, 12 Sep 2026 16:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232212; cv=none; b=o8dv2oYYJLDOOPLDbbqnE8D76cQhKcwymWMArPZt75DfLW76ZZisBMkecbGXmAHILzTPzbSWZPlm0E6kZrAV9e/VUDo2Dx2gAxcPJBhINv3cJfRevif35/ZPsUUVD64udq7AHefp695lH2u0u7l9FcF6bXt6pvVGrokak93J2Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232212; c=relaxed/simple;
	bh=InHGzyFTb3CRgI1VLgad5EnTAwrPzEuByg9GGNlZbAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=neiVUWOYVvCsxLYEJCbkgYKJNPbHaFOpAiBP8P+Vv4eZsXAtQLiVwTd0axbtMqFp6ywLb7VC+qfuQDUf2vtWmKaBBYBcq1Qqmejie3SRbEz9tmHWoTP22tHGZYgbZaM8LJlLOSmjfjQZWWSA1EWHxoG64rukZuJbiPVsZ2ODrdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rIjYWCLI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rIjYWCLI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B0E1F000FF;
	Sat, 12 Sep 2026 16:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232211;
	bh=JebR2xHe6sdyuW5n2gR//afvpEnL3PXJJBw9wOyr6HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rIjYWCLIyyWNmtdS9tFAAe1qXGwIJB71Cyt+m6HqkV9rraYbpMSKXu/D3g96Kbm7o
	 DaVlhC7x0kDyVxG6kAshFNyCXIi9n7eU4b2drfw3AO0UoTRDozbTnhZiDwVzNrGdzi
	 HPi8uKvdsExyRfY/D3cyUi8tlrC/neoh6fBqlfSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1149/1191] arm64: dts: qcom: pm8998: dont use GIC_SPI for SPMI interrupts
Date: Sat, 12 Sep 2026 09:04:37 +0200
Message-ID: <20260912065613.954987033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit d9ef7a805a709a0b07341857d97a25598a7f92da ]

Unlike typical GIC interrupts, first cell for SPMI interrupts is the
USID rather than GIC_SPI/GIC_PPI/GIC_LPI qualifier. Fix the resin
interrupt to use USID value 0x0 rather than GIC_SPI define.

Fixes: f86ae6f23a9e ("arm64: dts: qcom: sagit: add initial device tree for sagit")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230409182145.122895-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/pm8998.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/pm8998.dtsi b/arch/arm64/boot/dts/qcom/pm8998.dtsi
index fabee4b716776..4034de203aa08 100644
--- a/arch/arm64/boot/dts/qcom/pm8998.dtsi
+++ b/arch/arm64/boot/dts/qcom/pm8998.dtsi
@@ -55,7 +55,7 @@ pm8998_pwrkey: pwrkey {
 
 			pm8998_resin: resin {
 				compatible = "qcom,pm8941-resin";
-				interrupts = <GIC_SPI 0x8 1 IRQ_TYPE_EDGE_BOTH>;
+				interrupts = <0x0 0x8 1 IRQ_TYPE_EDGE_BOTH>;
 				debounce = <15625>;
 				bias-pull-up;
 				status = "disabled";
-- 
2.53.0



