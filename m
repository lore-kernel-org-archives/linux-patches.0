Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D78562FA645;
	Tue, 17 Jun 2025 16:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178062; cv=none; b=N6NDQ16ZTi1qZ0fGAJYHJz3JWsL1JoA+Jeu7r43Nl5utzzwZMWzi7iR9RGLDYhmpEnTQf+x+zvbYJaMgjglHWRjgSThVckmOdoKbjsfXwf5lH+SNPrcyoYVe6KCX9ZE5lMAm1SrQnJhPrV6X8pZm+qAl4zm4xzMNhIlwg4sWSbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178062; c=relaxed/simple;
	bh=UE3OFZYJkNcyS38Y7uTEMAhB3Shab2mD4CClsCq+JiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzOCG8vR1CGrXDXqBMLVyX326+7AfUC66/0eKCns6poRj3JpeWDSTn27XGWROLc3jLHEY2Z2iuvGUXiC7DeFsoS3mta21MdjqpseUG9kE2jo6K+3VSt3AOSm2PW40KlnR3Pw/1b1SgEgG7eP5mITbt+sniwyXdG13PEi0VzrTMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tIGKP6/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tIGKP6/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A17C4CEE3;
	Tue, 17 Jun 2025 16:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178062;
	bh=UE3OFZYJkNcyS38Y7uTEMAhB3Shab2mD4CClsCq+JiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tIGKP6/4aYM1omivQZnrpnKA9eF1J6Qa9mGtBWN4xOI5WGtllV2D0jOPSvF1fGBfb
	 MulAlCNGqRdZrJNzIb0dhfwKABOS6Kx97lApbsE5gGrtdD9bZ2BLXaD08rwIWTsU1x
	 VOtqe7Fd6dGmRWdIAKieO39vLAsooYTdE8/fFCvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengyu Luo <mitltlatltl@gmail.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 403/780] arm64: dts: qcom: sm8650: add the missing l2 cache node
Date: Tue, 17 Jun 2025 17:21:51 +0200
Message-ID: <20250617152507.866493217@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengyu Luo <mitltlatltl@gmail.com>

[ Upstream commit 4becd72352b6861de0c24074a8502ca85080fd63 ]

Only two little a520s share the same L2, every a720 has their own L2
cache.

Fixes: d2350377997f ("arm64: dts: qcom: add initial SM8650 dtsi")
Signed-off-by: Pengyu Luo <mitltlatltl@gmail.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20250405105529.309711-1-mitltlatltl@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8650.dtsi | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
index bf6590e09a4c4..76acce6754986 100644
--- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
@@ -159,13 +159,20 @@
 			power-domain-names = "psci";
 
 			enable-method = "psci";
-			next-level-cache = <&l2_200>;
+			next-level-cache = <&l2_300>;
 			capacity-dmips-mhz = <1792>;
 			dynamic-power-coefficient = <238>;
 
 			qcom,freq-domain = <&cpufreq_hw 3>;
 
 			#cooling-cells = <2>;
+
+			l2_300: l2-cache {
+				compatible = "cache";
+				cache-level = <2>;
+				cache-unified;
+				next-level-cache = <&l3_0>;
+			};
 		};
 
 		cpu4: cpu@400 {
-- 
2.39.5



