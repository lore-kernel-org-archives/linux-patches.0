Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C16B414B959;
	Wed,  5 Feb 2025 14:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765089; cv=none; b=uYFmR82eFgQEanALYuV7lziRaS4zZbQwc4a3NiirLTVCsNDgR1dZW2BYNYzXiJB+iVCVXs/grZeAVsEhVxaAAaW8YecqkfxJdjWnuCRuftxHY4XnqfONF+Y0hrCZGgcV1hdodLIprHp4+3WEJEJYFaqye6R6V+psRES7hfeN1Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765089; c=relaxed/simple;
	bh=uFlFu/AJVpX6x6H4Ca+RogLXDHfb6Hp7EX8t++gVsPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKczyYPTbtifFTgXTB7WZQ/uG1H/eU+QgjgPrkPHjonThsFc3UxfeFLg6SEJLOC6V89xYoicboqLXE77HVzzlEaDOOxrWXI8t6KmN6chdKYz34HYjLLfL/DaHaPQIBhdQz5/2ssZbsDaC080mS3OQX4e2FfNRkEMPptzFN71yKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYDeUy8/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYDeUy8/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4872AC4CED1;
	Wed,  5 Feb 2025 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765089;
	bh=uFlFu/AJVpX6x6H4Ca+RogLXDHfb6Hp7EX8t++gVsPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYDeUy8/ZeHhM9MyDDooZg/egjO3ZuNK/RGYCQf3jHEVlpQzQ4KxTNx6TyvCxb4LK
	 1qHEXD00MmthJwq5a/hprxQuAudwrb9AiVqJsCaUMOGt3zPB6snHXaWuvqoYpuGX7f
	 +l8d6lKY2wVXr1pSB5SO4ClX7v9oRa+FZ3kqWBHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/393] arm64: dts: qcom: sa8775p: Update sleep_clk frequency
Date: Wed,  5 Feb 2025 14:42:30 +0100
Message-ID: <20250205134429.144008289@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taniya Das <quic_tdas@quicinc.com>

[ Upstream commit 30f7dfd2c4899630becf477447e8bbe92683d2c6 ]

Fix the sleep_clk frequency is 32000 on SA8775P.

Fixes: 603f96d4c9d0 ("arm64: dts: qcom: add initial support for qcom sa8775p-ride")
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Taniya Das <quic_tdas@quicinc.com>
Link: https://lore.kernel.org/r/20241025-sa8775p-mm-v4-resend-patches-v6-1-329a2cac09ae@quicinc.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi b/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
index 2a6170623ea95..864ad109371ca 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
@@ -517,7 +517,7 @@
 };
 
 &sleep_clk {
-	clock-frequency = <32764>;
+	clock-frequency = <32000>;
 };
 
 &spi16 {
-- 
2.39.5



