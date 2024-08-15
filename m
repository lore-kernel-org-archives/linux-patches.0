Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F8B19DF85;
	Thu, 15 Aug 2024 14:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731076; cv=none; b=kExdupCisiRE78CH7pgSv1A6choiWKqTOH4KUHbEFn0I8BkIU2G1zJHUA7oxfq35iwuflyNIsRwGY2QCWB9Z/xbSeGRut1s7b5txzknGEM1LMxBt3m/HJdsR09+1Ngmhm4XR1CToPxPCPA2q2bKU3YGFulUXRa65+bYMbzpVKhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731076; c=relaxed/simple;
	bh=aG9q98gDBH7UZYe9uF3LHohmiwAFn0rNOCXezdESaBM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojbvDZLOFB/z8LXlMfrVGv4bpFQ7xa0xjYIBTbfDul6MZr+kGdFOeJj/djsVhfkf+afSKq6qGyB6w65mtCgY+hz58c5vz2O5C3gGC102ubJVSpAlLqCgYFoY62cx+3AmRj9DRZ21xYjBcmApKRVfVo0CKIEv5k/eKFHJuAOiHYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zj/3fWP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zj/3fWP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DB6C32786;
	Thu, 15 Aug 2024 14:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731076;
	bh=aG9q98gDBH7UZYe9uF3LHohmiwAFn0rNOCXezdESaBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zj/3fWP5UI6q3uDYVCZY3d5EzgT9loYTGB+lq8ipDVS0H5b5faEYi3HmZvsiBdNge
	 +wbIJeEQ36AXBOpU1LpkAJ94s5CivC6dqZdsxFOmCNAj6oa1KPmP6jInBNdMv1fO+A
	 grPp2lp7YKRTi0z/GpRmbmClExIUepfUiwafzcpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 016/259] arm64: dts: qcom: msm8996: specify UFS core_clk frequencies
Date: Thu, 15 Aug 2024 15:22:29 +0200
Message-ID: <20240815131903.421903944@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 02f838b7f8cdfb7a96b7f08e7f6716f230bdecba ]

Follow the example of other platforms and specify core_clk frequencies
in the frequency table in addition to the core_clk_src frequencies. The
driver should be setting the leaf frequency instead of some interim
clock freq.

Suggested-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Fixes: 57fc67ef0d35 ("arm64: dts: qcom: msm8996: Add ufs related nodes")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20240408-msm8996-fix-ufs-v4-1-ee1a28bf8579@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 8bfb897b0e81b..f82f23a10fae9 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -1386,7 +1386,7 @@ ufshc: ufshc@624000 {
 				<&gcc GCC_UFS_RX_SYMBOL_0_CLK>;
 			freq-table-hz =
 				<100000000 200000000>,
-				<0 0>,
+				<100000000 200000000>,
 				<0 0>,
 				<0 0>,
 				<0 0>,
-- 
2.43.0



