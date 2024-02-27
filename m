Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49E0113B2B8;
	Tue, 27 Feb 2024 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043824; cv=none; b=Gb2xibFmNVRvjIjH9wviIleBGm1smdQx/rc145v9xptdq2gmbdXvvK+/lHn9tGTouw/Lh51jblYdj1oOIcAbrGQXI4TTJMalFKB8p+j4T8xSObZ+OUo76YhQnvCn8NZO5rBfZZKa35vls56H7hWaMpDsfIhvZnEsASFZf4vxCkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043824; c=relaxed/simple;
	bh=+9/kufDGxF3wxGRkS/+UFuwliwRV/Q4+9KmT0OkFm3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGmJI0Qv3nHv/VajwZe1cjAUjuKYeudGGGfnlv3nGkHXGElTcQqWCSHVv0JVQtmU62ef3t8sFKZ2mFrQzlEKytKpsnGdaOrs6oXezwfjvPh3/6ck11NRXXC0JDBg+1cmwDjotJaKVYsbBQdwuRkjzTXRdRynuECi4pUpW2XSXzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPFBbFHH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPFBbFHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1316C433F1;
	Tue, 27 Feb 2024 14:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043824;
	bh=+9/kufDGxF3wxGRkS/+UFuwliwRV/Q4+9KmT0OkFm3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LPFBbFHHZMvypadCJ4pVZGyB5NnXPQum7kaVT/01a6c3RWOxtVWgr5etSA8d8QmbW
	 pUhizRlYB782EdA2jqE9/fQ53P9FjQ15V4AZ7uAaTaYmZYuna5+/adQitiRmknLLa+
	 F1El9RiIyXKtC5TafJbWezJM4UTIOhWcBWdkU5zI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sireesh Kodali <sireeshkodali1@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Stephan Gerhold <stephan@gerhold.net>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 50/84] arm64: dts: qcom: msm8916: Fix typo in pronto remoteproc node
Date: Tue, 27 Feb 2024 14:27:17 +0100
Message-ID: <20240227131554.500322618@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

From: Sireesh Kodali <sireeshkodali1@gmail.com>

[ Upstream commit 5458d6f2827cd30218570f266b8d238417461f2f ]

The smem-state properties for the pronto node were incorrectly labelled,
reading `qcom,state*` rather than `qcom,smem-state*`. Fix that, allowing
the stop state to be used.

Fixes: 88106096cbf8 ("ARM: dts: msm8916: Add and enable wcnss node")
Signed-off-by: Sireesh Kodali <sireeshkodali1@gmail.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Stephan Gerhold <stephan@gerhold.net>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220526141740.15834-3-sireeshkodali1@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8916.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8916.dtsi b/arch/arm64/boot/dts/qcom/msm8916.dtsi
index bf40500adef73..e1097ba6c9481 100644
--- a/arch/arm64/boot/dts/qcom/msm8916.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8916.dtsi
@@ -1097,8 +1097,8 @@
 			vddmx-supply = <&pm8916_l3>;
 			vddpx-supply = <&pm8916_l7>;
 
-			qcom,state = <&wcnss_smp2p_out 0>;
-			qcom,state-names = "stop";
+			qcom,smem-states = <&wcnss_smp2p_out 0>;
+			qcom,smem-state-names = "stop";
 
 			pinctrl-names = "default";
 			pinctrl-0 = <&wcnss_pin_a>;
-- 
2.43.0



