Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F912D5436;
	Tue, 21 Jul 2026 17:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655629; cv=none; b=Xj3SgugR9doyMbyAk0woVI/SRrWc9ZjcQI/n98zfK9/2ISqFgU8mt5FOPnUwwqaR+nreNiKK2DVrYyvgQCMsabJgDiI17/xlTmjNs4BdmcUBHBTTaQsAKpkh1Sjxa0h7c335f263E4dOLZKx+G+aZ1+0rLk2pfyXLXrZAP+z9BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655629; c=relaxed/simple;
	bh=dj+Pe9tkEbJ12ucIyoI/YHM9TCCmKnw6QV3uRIVVOic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/0m5XfdQrUkGQAFzF5Cemv8EwNvw4kI6z7dXYH7X4AZomARtXTJzkxtYOzqGsbekt1zQGwLRHRhJbiTq5jp/6uX5D3uQ9vuk54NVwG4Xz2qfNQ9tCuKAr0DcP0/DGUJD/NIH4CbUH+s06PIkXU2pKWfihPU9zavRD7kiLghYPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pOsYdzHt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pOsYdzHt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 257B61F000E9;
	Tue, 21 Jul 2026 17:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655628;
	bh=5MyLW9LAzCe0EGeOmDo7gACjQqRXysUICMz6Jf+K8XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pOsYdzHt985UeBxSHpp+IoS86pjrTiTn3F75V4sr8NFTVAc7fmriFyi0R7uckHMK+
	 U9kBkBBc7bK3Uc4CyMzEdLkSWWO/FDFRHMRD1LGowrrxYPwDTJekuD9Ia9jFhpb/Zl
	 UjNd1MuNRvtS1bL+3edarkISV6Y7Se7RN/G2s0U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0080/1611] arm64: dts: qcom: sdm845-mezzanine: Fix camss ports unit_address_vs_reg warning
Date: Tue, 21 Jul 2026 17:03:16 +0200
Message-ID: <20260721152516.642100616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit f20a82aacd7f381084391a8d1f0f58defa91974c ]

Add necessary properties for ports node in SDM845 DB845c Navigation
mezzanine overlay to fix W=1 DTC warning:

sdm845-db845c-navigation-mezzanine.dtso:19.10-24.5: Warning (unit_address_vs_reg): /fragment@0/__overlay__/ports/port@0: node has a unit name, but no reg or ranges property

Fixes: 30df676a31b7 ("arm64: dts: qcom: sdm845-db845c-navigation-mezzanine: Convert mezzanine riser to dtso")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: David Heidelberg <david@ixit.cz>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260405-dts-qcom-w-1-fixes-v2-5-1f2c7b74a93f@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso    | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso b/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
index dbe1911d8e470e..678a17c805f74c 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c-navigation-mezzanine.dtso
@@ -16,7 +16,12 @@
 	status = "okay";
 
 	ports {
+		#address-cells = <1>;
+		#size-cells = <0>;
+
 		port@0 {
+			reg = <0>;
+
 			csiphy0_ep: endpoint {
 				data-lanes = <0 1 2 3>;
 				remote-endpoint = <&ov8856_ep>;
-- 
2.53.0



