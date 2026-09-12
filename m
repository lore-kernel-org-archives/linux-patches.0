Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF44E1A6813;
	Sat, 12 Sep 2026 07:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197571; cv=none; b=WtN75k3X4ezCF3wVGi33nR5H6gj0oY+TZUcWORtluXrze3YrRi1PsacbFOKapnX8T6gSIyyiHiOgbRTdNp5uGb213Py1uHXQYEyL7lj4zz+QePXr24RNWFv2meyR2wjrpSaN58QuCqbCRGuYBjfKvSptfazS9toI+2WghTvCmMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197571; c=relaxed/simple;
	bh=YDBAkP+AoDbmkqqFP09hX2LPAzCE1/Our7nWAN47iXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sIkhKJbZ7CGXPgSIsFsA5G+L/IF6p0XE7DxO3PYOj0hqeH1JOMUPN02jNcfiBj/XCUeAoCI42zv8bQiS3QdKYgPiss7HAlLWK17V0yUthPgXzPbyfF2zW56begjwaBLpu3TD9PGpZUhpqzcijuok7iz77yEaGUh0tZwcXjargzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZWRCJck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZWRCJck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3351F000FF;
	Sat, 12 Sep 2026 07:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197570;
	bh=aFb+8LYLd/Cl+w0A1xdAVcjHuViaCCWw8YWGGXwTBKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZWRCJckHIpB7EFFVZT122e61pAs2qxl3fINEWHCG7ZbBeMqjo6bBKngdRx1QhYgx
	 /L4WuSfk7oC18pEtvtwWhvA3C45v61ifDCDjVyOqSIP/SsUrNv0f7hp6uLOHV8WRm9
	 4s/kY4NefLF5L76LGlhGFoxZVgzRZl9ZlLEn6ogA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0202/1815] arm64: dts: qcom: talos: Fix GMU unit address
Date: Sat, 12 Sep 2026 08:32:32 +0200
Message-ID: <20260912065653.745134939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 34a4ec6910e68ce06eb7201fa36778ca59a1e510 ]

Correct unit address of GMU node to match 'reg' property and fix dtc W=1
warnings like:

  talos.dtsi:2020.20-2055.5: Warning (simple_bus_reg): /soc@0/gmu@506a000: simple-bus unit address format error, expected "506d000"

Fixes: 8de397a5618a ("arm64: dts: qcom: talos: Add gpu and rgmu nodes")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260528120342.46343-2-krzysztof.kozlowski@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/talos.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/talos.dtsi b/arch/arm64/boot/dts/qcom/talos.dtsi
index fb1bbc51bb8a4..70df5db19e9ac 100644
--- a/arch/arm64/boot/dts/qcom/talos.dtsi
+++ b/arch/arm64/boot/dts/qcom/talos.dtsi
@@ -2017,7 +2017,7 @@ opp-435000000 {
 			};
 		};
 
-		gmu: gmu@506a000 {
+		gmu: gmu@506d000 {
 			compatible = "qcom,adreno-rgmu-612.0", "qcom,adreno-rgmu";
 			reg = <0x0 0x0506d000 0x0 0x2c000>;
 
-- 
2.53.0



