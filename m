Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F62F6F06C;
	Mon, 29 Jan 2024 17:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548463; cv=none; b=XSNH1VOYd+frMIQm8fdryvSUDzeSlA9e+YP9yCGLAWCfNiCIV68zooDhEISMdgNT1avPaxgpysU9Dqn9kyFBettJacf67gvrR9ERjR6KaaPEgJXotnfT4uvOUUTdpiEB22K3orBQAxJcGDXedQX1av03oKZsyrSXvEzMxhL8pGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548463; c=relaxed/simple;
	bh=DoaIjSY7sOUWUst9Bh0Cy2tE5KnpPfvYMycyltxSwf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CbRMNWhEBGZDS1HGyaK1/4eBNmB4ucmwrxgl0EQH0gKYPAp1vbR5mz5ppTWBDwvLG2T1s7pM17gei//5lMfnRpuB4arq14yVLXczDU7MaJHWt78nJ8/2SP5uSxVC/ZkHE8PQEUY19MkdKvr5yOXs31RRvubeSiyqvUNw1YGN85M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ANzDtx/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ANzDtx/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAF0DC43390;
	Mon, 29 Jan 2024 17:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548462;
	bh=DoaIjSY7sOUWUst9Bh0Cy2tE5KnpPfvYMycyltxSwf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ANzDtx/qb8HwY7iuah5hcsg4JYbVQz1DlJ6s1s6MRAQ8aS8O6q5eIHhIvFk9hjvw4
	 2D0bbRSR/8H7Rd8Wf5qMLB1cJ7wHEzvviS4q4p832vqzXYma4LkrTIssWQhBN8Yqhi
	 un8vuVY7M9kbKGwq2ztoUOxPa7OTz9g1EQI+inV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <mani@kernel.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.6 076/331] ARM: dts: qcom: sdx55: fix pdc #interrupt-cells
Date: Mon, 29 Jan 2024 09:02:20 -0800
Message-ID: <20240129170017.147552768@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

commit cc25bd06c16aa582596a058d375b2e3133f79b93 upstream.

The Qualcomm PDC interrupt controller binding expects two cells in
interrupt specifiers.

Fixes: 9d038b2e62de ("ARM: dts: qcom: Add SDX55 platform and MTP board support")
Cc: stable@vger.kernel.org      # 5.12
Cc: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20231213173131.29436-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/qcom/qcom-sdx55.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
+++ b/arch/arm/boot/dts/qcom/qcom-sdx55.dtsi
@@ -619,7 +619,7 @@
 			compatible = "qcom,sdx55-pdc", "qcom,pdc";
 			reg = <0x0b210000 0x30000>;
 			qcom,pdc-ranges = <0 179 52>;
-			#interrupt-cells = <3>;
+			#interrupt-cells = <2>;
 			interrupt-parent = <&intc>;
 			interrupt-controller;
 		};


