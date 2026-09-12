Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632DF367B60;
	Sat, 12 Sep 2026 08:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200813; cv=none; b=MTk7FrjHg67mQHQXovbHBQBNSRFonBbjBhBRwP+TtG+10Iq05sXDNRkD+pmAW0/xEC8mZ/QZhoPwYdXwx6nEXWf6dN1WwXNfEuaTEq+ISeOSKNI8U27ofkau0YBJAJTDx6jQ1S76SHVnYiL6+/wjj507WbcI/nJE/RjaBJ9LgSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200813; c=relaxed/simple;
	bh=Xf3OXB3QRg001hx3jCvMCoJ+sQSs47ifG7RFReWK4FY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PjRWgm2MnzUXOhzBnmU0TeVcXsmHCRebJWS06ewHyfzAW3yo9kvJhESlHKdOuc8zJEwE4AqLyd6mmuQqvk5xeBomM/Cwacw8MlNhUYwzL6wu0L4LGy/9ZnPTss0xF2nUt1xoxLfv6zSSPYiDF0cl22djzO8kSj83mb4Rw/XZHj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CYqp0GS/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CYqp0GS/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31E3D1F000FF;
	Sat, 12 Sep 2026 08:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200812;
	bh=UHEgZaBmpG7NHOQGYq+YMsU2ribgu4FKWptZybMYDsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CYqp0GS/XC2duFhNwzzvrAbmeZ5SswlqgjTYKKfBhDwWjVC9EjCUKCTZ038WT10Fb
	 yp1DpU/Kfd4ZUpmEYwRvTFMXUnycLIqSw0VG+Q3X6/q7OzsjtX48frHuwY8Xi1qst2
	 /m/hesgoemyonaJWpKQHTZgO+ejEbdz+MtDVv9NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0824/1815] arm64: dts: qcom: eliza: Add fallback compatible for ADSP remoteproc
Date: Sat, 12 Sep 2026 08:42:54 +0200
Message-ID: <20260912065708.257575579@linuxfoundation.org>
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

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit b589944ecd95fe4a51bc2aab13ce83b298b7bcc8 ]

The ADSP found on Eliza SoC is actually fully compatible with the ones
from SM8750 class. So add the SM8550 compatible as fallback, just like
the rest from the SM8750 class SoCs.

Fixes: 88ddafb01ec0 ("arm64: dts: qcom: eliza: Describe the ADSP and USB related nodes")
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260722-dts-qcom-eliza-fix-adsp-binding-v2-2-e1e98ae15533@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/eliza.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/eliza.dtsi b/arch/arm64/boot/dts/qcom/eliza.dtsi
index 2e9f5aa092cc2..8fa69be150508 100644
--- a/arch/arm64/boot/dts/qcom/eliza.dtsi
+++ b/arch/arm64/boot/dts/qcom/eliza.dtsi
@@ -1967,7 +1967,7 @@ tcsr: clock-controller@1fbf000 {
 		};
 
 		remoteproc_adsp: remoteproc@3000000 {
-			compatible = "qcom,eliza-adsp-pas";
+			compatible = "qcom,eliza-adsp-pas", "qcom,sm8550-adsp-pas";
 			reg = <0x0 0x03000000 0x0 0x10000>;
 
 			interrupts-extended = <&pdc 6 IRQ_TYPE_EDGE_RISING>,
-- 
2.53.0



