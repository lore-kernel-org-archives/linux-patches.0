Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065563EEAC7;
	Tue, 21 Jul 2026 19:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661456; cv=none; b=SYJyWsQDyOsjngbvKNoclPHXsqZs6kyMGsdfVJD9dNEtZVpmiFEVlLgeWv/mFeOqpaYvPKNMFEuvVj49wBXxoyYVk7dVBgCkg87ByYsb06zafsk5Z/pWld1ZyPg5NH6ZwHUN7HceM9DBRlVYcjp816IrY584GkPkIq0PHhv0pxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661456; c=relaxed/simple;
	bh=kHNFUYDliL9gCncmhhlS2M/Aoa+RS8sRR/Ml0wljwdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hyty++UHIw1Ypcb7yXi79Km0JTYHMRO7d0RuRoBmEkGF9J0A5qZ8yBf1B6enNSs1/DSMDSCjGcfOlmDh5IGC31p1Ur/CRvWNmrY9YWJkc2snskWVeJv0I/vtmnsP7ruCPrmH/bHIU/5a1IbWKlwwO+X86UxmsIR9Rkfu0jE8Ygc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qWWL/W1l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qWWL/W1l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6AA1F00A3A;
	Tue, 21 Jul 2026 19:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661454;
	bh=VMYzuYzyG2k80OEQQ4GzFASTOICosOiKbTmSIE4cu9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qWWL/W1lRTjAr+utl2byS/9wmP3qLFf95jglzpKfX/fTufl4CHR0KKT8LO9xzxRfX
	 chEAsjmLcDJEFXG2B/+bfXLPJnUegZ/USMh6t7LxtVl6++lCZHY0uC+PgtWbBBBc3b
	 /dwrKO8K9FjejrxqqH+nitI0isRoivHzp4fxryrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0072/1276] arm64: dts: qcom: sdm845-mezzanine: Fix camss ports unit_address_vs_reg warning
Date: Tue, 21 Jul 2026 17:08:35 +0200
Message-ID: <20260721152447.703743418@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



