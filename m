Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59F947A53;
	Tue, 23 Jan 2024 00:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969822; cv=none; b=NZXrFyx6mx/yZGN5sAjMDOMuhSqXwcV5/zYkNKLuB/3Fr+l0BQZBWWIuzwj2AEH4vNM7BRAFFx6HFqJRKlCPjTTzp6YUfPrb1+SYpLUXGAVCg5qq9qhA9Q5baWg2S1rHp9YwCT/QKa6CWtA2tZADwtvXvW0VMaCY2PxM5JmCYUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969822; c=relaxed/simple;
	bh=RFlxzlC3GSmyAKF+d4JTTk2KvdN8/OytA33Zc/HFGjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lqv1aPa+vjQa2xZHPJ/g3ymxoVAAQTKdLqTry6GfikI7EO74LPXeuH70aNRDLGHIyzhKM72PCvrheLmwMW/yqasZsguYeZui9k/R1DJB5h38ZBzy20vUxCF0vHHkJen7vAuOSBv3RYvc5ifVvwWGU0UqDtnAaJRYjPV+FHnICtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1yI0zt7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1yI0zt7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A4EBC43390;
	Tue, 23 Jan 2024 00:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969822;
	bh=RFlxzlC3GSmyAKF+d4JTTk2KvdN8/OytA33Zc/HFGjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q1yI0zt7YTamuXpY24ymj+tNZzh9lU5Gr7gqlYDkqwRn7A1KoeJKt+xB4W+5wSrSq
	 UAVW1GtjtAslBypO+DzFDuOpC4VVHuh+lz3CkaPC3fKgagWM04b1Tl/RIb2vIkm6Sq
	 WQp3g4omo+mSMpuy1P1NgzFUECmh43BwzbdNRFd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.7 470/641] ARM: dts: qcom: sdx55: Fix the base address of PCIe PHY
Date: Mon, 22 Jan 2024 15:56:14 -0800
Message-ID: <20240122235832.753027106@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit cc6fc55c7ae04ab19b3972f78d3a8b1be32bf533 upstream.

While convering the binding to new format, serdes address specified in the
old binding was used as the base address. This causes a boot hang as the
driver tries to access memory region outside of the specified address. Fix
it!

Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: stable@vger.kernel.org # 6.6
Fixes: bb56cff4ac03 ("ARM: dts: qcom-sdx55: switch PCIe QMP PHY to new style of bindings")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20231211172411.141289-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/qcom/qcom-sdx55.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
@@ -436,9 +436,9 @@
 			status = "disabled";
 		};
 
-		pcie_phy: phy@1c07000 {
+		pcie_phy: phy@1c06000 {
 			compatible = "qcom,sdx55-qmp-pcie-phy";
-			reg = <0x01c07000 0x2000>;
+			reg = <0x01c06000 0x2000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
 			ranges;


