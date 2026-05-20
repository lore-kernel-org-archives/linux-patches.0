Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA3431F9BE;
	Wed, 20 May 2026 16:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295599; cv=none; b=exU86a1fk0/zrdtwBEeKoRJZyplLLff62sFvQ5CJUG5pz6BXrZmMb6lHpj1Cdjupr/hcDsnCYXX7L1Yeu8e/usHhtgrO1UBXQmC4rdkmHRxvegfegaWnx5E81PVGrHJe5vxoQff65XwNwSCNDT+pWk1f2QJTfmna5Z+UKFTIFU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295599; c=relaxed/simple;
	bh=oMGjPdSgxUkGGyVaH0QMA9hIH1ZUFDKXBVRqdsJde7E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9k9P2Zc+bLN03YL3alHrwpU160+SsLeZuiLRNOQ7xjnzGsZ+kJL54Zuoyv6XPle4ZAmj0zgnLWq/FquJamUvU9l59MH1Fy4KVtJfNEPH6SCbG1/d6Z7x8dTd6rjulYN1Cbu/bxi9Mqm7XKgULj/BaGN2+RJs4XsJ+3gl1ClVdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZ2cY8hA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZ2cY8hA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394481F000E9;
	Wed, 20 May 2026 16:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295597;
	bh=PzkmxkvEYHp+kIpaClo5Cw2Blz37yJv1KU5TeC7c7fM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZ2cY8hA05Meb4nejTTK9C6rNcWfH/7l+EjcMJxQN557uDLjMw4wG5uOkjjBUbKFv
	 /2pG63iJH14h/75ENLF75TM7PIYD3fEb7+iKAjFFI/xSeCes777qAyOq/FPVbx+Oqk
	 MmvSIXPLYIAxEjVIewZS0bdYOaxK4K5ohLX3+NLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Hongyang Zhao <hongyang.zhao@thundersoft.com>,
	Roger Shimizu <rosh@debian.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0481/1146] arm64: dts: qcom: qcs6490-rubikpi3: Use lt9611 DSI Port B
Date: Wed, 20 May 2026 18:12:11 +0200
Message-ID: <20260520162159.077165494@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hongyang Zhao <hongyang.zhao@thundersoft.com>

[ Upstream commit ebcf2240a2494faf202ce5ec80ef159a38b1e542 ]

The LT9611 HDMI bridge on RubikPi3 has DSI physically connected to
Port B. Update the devicetree to use port@1 which corresponds to
Port B input on the LT9611.

Fixes: f055a39f6874 ("arm64: dts: qcom: Add qcs6490-rubikpi3 board dts")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Hongyang Zhao <hongyang.zhao@thundersoft.com>
Reviewed-by: Roger Shimizu <rosh@debian.org>
Tested-by: Roger Shimizu <rosh@debian.org>
Link: https://lore.kernel.org/r/20260207-rubikpi-next-20260116-v3-3-23b9aa189a3a@thundersoft.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts b/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts
index 0b64a0b912021..f47efca42d48d 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-rubikpi3.dts
@@ -755,10 +755,10 @@ ports {
 			#address-cells = <1>;
 			#size-cells = <0>;
 
-			port@0 {
-				reg = <0>;
+			port@1 {
+				reg = <1>;
 
-				lt9611_a: endpoint {
+				lt9611_b: endpoint {
 					remote-endpoint = <&mdss_dsi0_out>;
 				};
 			};
@@ -801,7 +801,7 @@ &mdss_dsi {
 };
 
 &mdss_dsi0_out {
-	remote-endpoint = <&lt9611_a>;
+	remote-endpoint = <&lt9611_b>;
 	data-lanes = <0 1 2 3>;
 };
 
-- 
2.53.0



