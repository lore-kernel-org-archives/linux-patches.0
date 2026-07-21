Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3C146AA96;
	Tue, 21 Jul 2026 15:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648258; cv=none; b=iT3sYBSFvHvH2fFi97M9PKP7sN/PrUAtFI736H6WFag7gpNksm45G7x4ZdriZbwAkYBkX2VPoGhIWwNBq661GZhwbmG5MTig4ABuX9IwVtXT5vJ28AQ9xL7QojYanK+B27AfV2ctGf9qgNVQqQj9J6F7ru41HV1980eswyU7++g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648258; c=relaxed/simple;
	bh=xYVLR0OO1pj7hrp1pbfuSdYiEJzkk3Vstpcadsl/A+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tt8owZsxLuRr9hvkKOGa1IqtZX4VK8LTxx5YvN+gFD/4Ygnb95AydHWKEIs1EQ5Aj2mShk8wQcWDH9cjxqDuonBX43nOQZ6BIMmw7UG1u/raiM3JBQo7GwQqjy0qzUD2xoC+Rzsx1QaiUOV63WytjVCFMnYaYgw3QuIVgv9wl8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbF+ZxQF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbF+ZxQF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F6A51F000E9;
	Tue, 21 Jul 2026 15:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648256;
	bh=ddK50lhEkPCWM3ZmKFefwxIN/F3DjKvXvvPSRyxy3Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbF+ZxQFIv7SSglgLo+6k3sjZOhREyPVziMFiDueYEFaCKYxuPoYhm9zztM9C3P7t
	 xtdneRCbmBdYC7vu4vhrEhFzRbZ+7fpAH+E5HKjpB99DrQSmTJ3VQn/ugNsBNQUQHN
	 mpSWWn+lZOR9VzUUk7P8piJhsF1EpB8yQeDDHBe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	David Heidelberg <david@ixit.cz>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0088/2077] arm64: dts: qcom: sdm845-mezzanine: Fix camss ports unit_address_vs_reg warning
Date: Tue, 21 Jul 2026 16:56:01 +0200
Message-ID: <20260721152554.766655165@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



