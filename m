Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DD446D0A0;
	Tue, 21 Jul 2026 20:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665677; cv=none; b=J7HZBMNUvdR0ds+iGapWvlgXm5Fyp5w8ops+JfM6MDpaHHBiZefI+uHcIExonHqH/LL2NTA1+7/DkYh0y/RqiXSwK6n2j9GG87S2SPt6uSRMVXQRTGm4p7Z4JoMZfGbBRMqz08KDiMLG8aqKkGhNsWTweKk+59rmT8j9ig0++/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665677; c=relaxed/simple;
	bh=sLWfBEABSeWK4bLAqBZuhtTNOP6LdcTuEsR2ZqB8n2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRaay1PGOwvniwR4KenUHaldB0R2EP1tq/8cg6XHrG3SmN1FvJGxeoyat2fPsCFisoJdi9xIeZIJKaPBdijvdaCrp3zD4NGM3VXCaPcRniwy07uueEYO2KS+B31jscYbNyrFaZ6XBFpub8Q0KLroi76Pwp5EbS+kQJ1hfSsgwjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DxpXWWHY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DxpXWWHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D10D51F000E9;
	Tue, 21 Jul 2026 20:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665676;
	bh=qIhm3o/WhBvwnenvmlGuXXB7/Vsio2PkgJ5CZ7DbIEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxpXWWHY3XmphX+rIvsFLrY4SBduberZ6wi+0xKAIhrklPUIFT41ASe5jMp+JNIm3
	 Kwi+FfiL4AUYpxQsNnPOYayddtIZl5nVAvsSaZEROR0/HXVQv9pUjVhkl0W0oEmqY0
	 nJNZ8CT3b7gMLluqdHCzxcCcu9fmIvEREmEhm3aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0367/1266] arm64: dts: qcom: sdm845-mezzanine: Fix camss ports unit_address_vs_reg warning
Date: Tue, 21 Jul 2026 17:13:24 +0200
Message-ID: <20260721152450.039264881@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 51f1a4883ab8f0..df1907560c525c 100644
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



