Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A332F7DA9E;
	Thu, 15 Aug 2024 13:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729200; cv=none; b=JY5GJa6nPQCMCJtVBk2YxqUunOUJ7QgPZQz7a6/tZi7FURJ+hJfMhMJ4Qz2oUh3LDkdfMTYjRQsjK8tcEN179e8g6B/oniTDNGr1KwHCl5F4jkUnRls7ez5F5/oYmOhf6WkissTg6KKdrh9jqq0n7ArCs6OcMIkgb5bO1tei/88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729200; c=relaxed/simple;
	bh=XBFgiqbDDy3rZHHoKGv/+ilGhzHzkwQfXaa3S1jttck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xocg4cO+ujQE7vdVkPOsfBpDMGToEQZw/60F5+hAOcG2Il2FYDENIiq4uhyBJw4FlxDmRH3U/XSQRKlJvbncyNP8gBO4b38ZgtpxBhCURH4nlrFluRZS8INggCPeWN9rI8+0tHFi8iUPNVDYmRf9q3Wsfn5qov7PTBPe+L5Up2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ySpRzpwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ySpRzpwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B7BC32786;
	Thu, 15 Aug 2024 13:39:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729200;
	bh=XBFgiqbDDy3rZHHoKGv/+ilGhzHzkwQfXaa3S1jttck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ySpRzpwoGD6KVWp6EpLVtXz/IPQz5/xKFR3v0WboGUX7hXlpMWJp868c2jiTAxBQ1
	 8nxWMfsTRFcRyIEHlFVl4zWO/LiVZ9PKI00sNzhgGRIwfXz+ZZUioTvvU6tdWEgy/m
	 g5Rkk4EOF8ZH6g4kZKppqgaSar5gaCMlqfMyZ7Ac=
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
Subject: [PATCH 5.15 022/484] arm64: dts: qcom: msm8996: specify UFS core_clk frequencies
Date: Thu, 15 Aug 2024 15:18:00 +0200
Message-ID: <20240815131942.131854578@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index 8b3e753c1a2a1..210016ff50449 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -1756,7 +1756,7 @@ ufshc: ufshc@624000 {
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



