Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EFF189524;
	Tue, 30 Jul 2024 16:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355317; cv=none; b=qdubTKugWAOC8i5uEazUzBxRznM92zTDUl0YPO+PNLLDe3oAM1xT7QtD/X/wtJOVD57D0tVBm5JEr9TKb33GETe09W+EtZxcMizcDF8aQt/i6QfC7ih7oTZJrcoCrOYvKtaMenAuAZL3aGlCe+QzFMDK8X9MbnTbIO9iqE4NICM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355317; c=relaxed/simple;
	bh=iWFcGHy5pQGs0yP1vgDcysPu3dymNTW7GecmC0oDGDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZiDhjBw3UI5lPk9MScBap92SvA1OBuHCQZbG4k2tdvGBEWSkAEGAnZAL8FlOnKkM0u3bCi39+IObbnusjARRJqFyJ59jrVARJEF0szhJRsOL18rmaxcJDHitcU3/Yt5g7uyjHOygGjP+qA0/ZGof2Smsq5a3nK0J4ALFMHZH1uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOYzaS6O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOYzaS6O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8121EC32782;
	Tue, 30 Jul 2024 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355317;
	bh=iWFcGHy5pQGs0yP1vgDcysPu3dymNTW7GecmC0oDGDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOYzaS6O4iiQ5dxA3oeN9vRjM+3j919v/MuShYPcW8kbj8tEladxDO2gakNXn9Sgs
	 GpEbbKZNQPRGCPxV2KUk62Ea92tQ3fL0hATCDIgXlCeIcCBLXgW01V/FzCVfL0hhN+
	 5TbVyH2glJLlaZobqDzSe91k6ThVOWLfOUX8LjHc=
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
Subject: [PATCH 6.6 047/568] arm64: dts: qcom: msm8996: specify UFS core_clk frequencies
Date: Tue, 30 Jul 2024 17:42:34 +0200
Message-ID: <20240730151641.678202460@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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
index dd407aa3abfb9..1f7cbb35886db 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2090,7 +2090,7 @@ ufshc: ufshc@624000 {
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



