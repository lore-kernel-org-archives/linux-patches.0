Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97486604B5;
	Tue, 23 Jan 2024 01:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974701; cv=none; b=kWPcmoqYfdeN39dllCEN9QTsx+wuRoGuehVUjnu/e+IFoiHIUrTbYMdPQT7nULV563fPvucjo4nt2qPVen5dGmpE+pv1HvU01KDrldxEeZC2s0x/9pAnMf7sChvv+riN3N3pe2AhuCHLS9yLgKBhxaLRm1c3s6OVmwsiGSPE6vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974701; c=relaxed/simple;
	bh=rK96Vhz1x4dbFJK0v139ZCWNU4iTs0RD6P8Sl/RLTQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ckJBuQxNQFqum6mKdRY+zY+GsIHTC34IImwB5Sxm8zkkZz1HfTXRdPlI0uzBDcNMUkljHjGcbqNOd+2KX9b4SNej9ZLzd2xYi/4hs1MmZCCJC3ZjzYchww/rUzIvAAWI7nrhSIFDgu5PJHh2TwVMLosa8MZJlPFz/Fngk0PTuWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tCsky05n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tCsky05n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E63DC433F1;
	Tue, 23 Jan 2024 01:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974701;
	bh=rK96Vhz1x4dbFJK0v139ZCWNU4iTs0RD6P8Sl/RLTQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tCsky05n4CU+POHZIjRtt4f3YbZr57hZYY7GmYGzygtAJf4kxb/7ZWGr/2sPh/h0y
	 5KnnblqDU/TzQ46A3QYRnEGSfdWPH8L1dKw7cT9TvA2kqbb5VgecJ7pzeOsHmxz0en
	 jhIGv16fJtEsJT+EZeyyFx6PwUyNytt2uNgaESOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 105/583] ARM: dts: qcom: sdx65: correct SPMI node name
Date: Mon, 22 Jan 2024 15:52:36 -0800
Message-ID: <20240122235815.382006727@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit a900ad783f507cb396e402827052e70c0c565ae9 ]

Node names should not have vendor prefixes:

  qcom-sdx65-mtp.dtb: qcom,spmi@c440000: $nodename:0: 'qcom,spmi@c440000' does not match '^spmi@.*

Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://lore.kernel.org/r/20230924183103.49487-3-krzysztof.kozlowski@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/qcom/qcom-sdx65.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi b/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi
index 35a887176b3c..271899c861c0 100644
--- a/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-sdx65.dtsi
@@ -530,7 +530,7 @@ restart@c264000 {
 			reg = <0x0c264000 0x1000>;
 		};
 
-		spmi_bus: qcom,spmi@c440000 {
+		spmi_bus: spmi@c440000 {
 			compatible = "qcom,spmi-pmic-arb";
 			reg = <0xc440000 0xd00>,
 				<0xc600000 0x2000000>,
-- 
2.43.0



