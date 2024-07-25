Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA948468;
	Thu, 25 Jul 2024 14:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918781; cv=none; b=Y5Rj9yfx9wTyvtTQNATp8uWFHH/BYNck6r2i613hz89YlMGk5G3R5PQgzbWH+ueOJG7cG2Joe8xtuTtT2oiNKDIFqGh9Ii6/p+IaRUJ1s7zR8OoOF3YEYfg8Wu5vxPVRUF6uh44d9KquwvB/bzqhCL1XWN+DonCG5I+3hEYwEr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918781; c=relaxed/simple;
	bh=c9FQ6p99E8PCQQCJWU5lu4ldRrdMErD37eB2fYVpm9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0BcfVOomXwcR8A6usSvckaXpSzlAfEf6Dh19TsWCcgeZK6TAVXb1u2BRInYUNeuV+5048v36fXFP/Hy+w7D08h+I/3gXjBxR8ovV1ClhXMcXC0IG6KByfwkx7q1FO3bR+ilf4hkMVa55heu43L25DsUAcMLO+bX/Jzh9Cc164c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KSq7wPgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KSq7wPgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01F54C116B1;
	Thu, 25 Jul 2024 14:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918781;
	bh=c9FQ6p99E8PCQQCJWU5lu4ldRrdMErD37eB2fYVpm9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSq7wPgJe8wqBUdSPQGEh/yANEYLoGXoJRC7wR2mWrTGpBVf0BCM4Hl0QZHPUxumd
	 qRMhFBFAXtlk26aDl5UnEb8k7Wl4gasoWW3pldgMUg6xkLaylFmBg+ylrU+s3VXEep
	 Qn9OO3U07et9CFoCoAQ6017vLmNgMXSuk1bHeC8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>
Subject: [PATCH 6.9 16/29] arm64: dts: qcom: x1e80100-crd: Fix the PHY regulator for PCIe 6a
Date: Thu, 25 Jul 2024 16:37:26 +0200
Message-ID: <20240725142732.287364402@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142731.678993846@linuxfoundation.org>
References: <20240725142731.678993846@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@linaro.org>

commit cf7d2157aa87dca6f078a2d4867fd0a9dbc357aa upstream.

The actual PHY regulator is L1d instead of L3j, so fix it accordingly.

Fixes: d7e03cce0400 ("arm64: dts: qcom: x1e80100-crd: Enable more support")
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc: stable@vger.kernel.org      # 6.9
Link: https://lore.kernel.org/r/20240530-x1e80100-dts-pcie6a-v1-1-ee17a9939ba5@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/qcom/x1e80100-crd.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
+++ b/arch/arm64/boot/dts/qcom/x1e80100-crd.dts
@@ -657,7 +657,7 @@
 };
 
 &pcie6a_phy {
-	vdda-phy-supply = <&vreg_l3j_0p8>;
+	vdda-phy-supply = <&vreg_l1d_0p8>;
 	vdda-pll-supply = <&vreg_l2j_1p2>;
 
 	status = "okay";


