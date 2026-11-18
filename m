Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024519;
	b=qGxvS9+FjbLMcMPMRdDpzbulON7UnVub8Eih1BnXxeqaqM08dIBxW+J1CA51al9p8/w4
	 Jxq0KC/F2ACNwJ3vcp7tZ/J6VyZFSOh0W0Hjm0mo2/7/kptvWUZ408LcHAMe1J71BpwJP
	 po00RKFdP0atVDmm8plUcVgPnWNJbRLwoIMCz/HANA4AwRizFLOvIFSFkMP58n8ElgANM
	 W+yb8qxkdu14mjbSTElHjNZsdlrqXm1XmebKcRWbWxCt4Apezy2BwMsteYKlQq+2lehym
	 S5NH4hkZ+mF924hbOAjOvvQKS6k+ilqb2mDp5xyil1GrwO4981XRxQBY0zYlvV5jGyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024519;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CCFvlb9Pvdo3AdX7aNWQwDeBUfFtQ5Pohzy6w5PKoTg=;
	b=m6cHdz51llOhTPMniGGuuhEQoLFOU+1wHs0xezQaNiAdxyJ7AxzAPl/FBL5w8i/kAAGv
	 04qUGArCfdjBCxU6mEGs8loD9jf2dJJmRx6qfMUU7tjbCARzfpmjf8x34mSOKFTF0hXTB
	 4Tj8ERuuGVJ6AVO3096+lU+Dyqjz2qbuduX4Juhlc+o+xVTkHGj7KpeJSX7sWZZFCBm2d
	 xRPavBCcixT+JEVja1fGs2X0VgcaPbZ9O2HHJdtJb4JElNkZprRzDNPWN3zZTzbLRKHlm
	 ueCG6xRzm55fhiqu4U4I//aNZXFiGJwDtKDD3DXVN4hersOt+iSLTiaFLulWvlD36mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2W+KLjuJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3B0606A325;
	Wed, 18 Nov 2026 17:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2W+KLjuJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFA91F000C5;
	Wed, 18 Nov 2026 17:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024519;
	bh=CCFvlb9Pvdo3AdX7aNWQwDeBUfFtQ5Pohzy6w5PKoTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2W+KLjuJ+aj+j27sCB5nt/v7/EsjlTAUv76ACaW0o+4bjF14hJlyM07dzpS/jdoao
	 QQgmKTRyNERlqaPcNSUFioG+uaAhdFcDL49TI7yaTQyIJ1oFC4Mc/JomJMGKm0qPlh
	 I3dkMqONl3Mc1AKWo7iEVvSLdwXFMo/9k1OV/Gnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0754/2151] arm64: dts: qcom: lemans-ride-common: fix SerDes PHY regulator supplies
Date: Wed, 18 Nov 2026 15:41:29 +0100
Message-ID: <20261118150149.518994956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>

[ Upstream commit 0d567fb7def9564d15c334ec0fa5f5f6a0114ffa ]

Both SerDes PHY nodes were configured with 'phy-supply = <&vreg_l5a>',
which was incorrect on two counts: vreg_l5a is not a supply the PHY
requires, and only one rail was described where the hardware needs two.

The PHY requires vdda-0p9 (vreg_l4a) and vdda-1p2 (vreg_l1c). Replace
the incorrect phy-supply with these two named properties on both nodes.

Fixes: 5ef26fb8b3ed ("arm64: dts: qcom: sa8775p-ride: enable the SerDes PHY")
Signed-off-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260804-b4-sgmiieth_serdes_regulator-v2-4-c4bc688177dd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi b/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi
index c69aa2f41ce29..37b140dbb7b23 100644
--- a/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/lemans-ride-common.dtsi
@@ -778,12 +778,16 @@ &qup_uart17_rx {
 };
 
 &serdes0 {
-	phy-supply = <&vreg_l5a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l1c>;
+
 	status = "okay";
 };
 
 &serdes1 {
-	phy-supply = <&vreg_l5a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l1c>;
+
 	status = "okay";
 };
 
-- 
2.53.0



