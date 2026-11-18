Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017527;
	b=o31rTfw0tOJ/3R+pQegkr/c88Q123Jeo5zlXF/y8k68ceQg1jfIce95lO3GjVY1W4znr
	 lN59R0aiAshCX3d05BbX3fAtv5dDaGkLzvm7T4gkKPInEIvr7lvZMHvG/Gfli/T+KronS
	 YSu+nwUT+RsZlGTBPTmwLAyWJJCclEeSKxCCpdq9zQuxIOV3w8J+zvN371z3Mc9bK+pg7
	 rax/DwLasGz0tefw4kdi4cvcO2cWKN1DrZ8KU6NtpmhjiE8pIrjVlHrpWKVPHtb8NaM7H
	 xxcZLow5R2GxZbJQZ2GVQwvojE2iQUBkEMe2yl95ekkd8zkyV8EKKyN1rgO/QKlw5aA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cmEJpT15hPZoTYHAc5ngozoidJ0ArzN5lDn5bYzwzH4=;
	b=dQiVvolYAvP7bCBfxFE3RjMs/T+zSP2/BCeYyRc1QubwhyBO0v9u4TzXCL1EiJLoAbRM
	 I7an1x7LlF3OMsR/qmxh5tjlyYhhNfKjTBzxK4NB1NPs+5+4NHQUBjg7mjx+VP/+4a/lA
	 86ykJVVIHg2thz9bDhlGj0ZwYqY0RotJ9d6JjidyNukvMJa7QhjvYrz5vdoZrUWo++R8R
	 /jBQkEEhXbqUCwQy983/1jAC4GuDdtaGDdesID7AhnNEIR/Z4/IQL7yNOnqiHuSDB801p
	 rVc7cebo6UVbIFlsVhSQqdbM/goLrixC1PNMPyGrABlc05av6Sx/KIp3JPXhpNzAUaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oKOW6nzI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B996606A31C;
	Wed, 18 Nov 2026 15:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oKOW6nzI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94AF51F000C4;
	Wed, 18 Nov 2026 15:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017527;
	bh=cmEJpT15hPZoTYHAc5ngozoidJ0ArzN5lDn5bYzwzH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKOW6nzIrm8sMGAxs36hx2ijLxsqRJbFjfOVZgDDaaIE3MdSmetIKWExwBKvGOIkX
	 20cV6j41ObSaLEz0DE0EMVYisZGwJJdGo3tyry0dbLQUu5gglEGePA6Pw1KJycLDng
	 pHaPlOFTKUbo9Q7NMB+JqrlEpA0FMW6i7eNm/0bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0875/2651] arm64: dts: qcom: lemans-evk: fix SerDes PHY regulator supplies
Date: Wed, 18 Nov 2026 15:35:15 +0100
Message-ID: <20261118150319.355763643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>

[ Upstream commit 457cf65a7997e398d8d6cef08601b4ea61b58e38 ]

The SerDes PHY nodes were configured with 'phy-supply = <&vreg_l5a>',
which was incorrect on two counts: vreg_l5a is not a supply the PHY
requires, and only one rail was described whereas the hardware needs
two.

The PHY requires vdda-0p9 (vreg_l4a) and vdda-1p2 (vreg_l1c). Replace
the incorrect phy-supply with these two named properties on both the
base EVK node and the IFP mezzanine overlay.

Fixes: 71ee90ed1756 ("arm64: dts: qcom: lemans-evk: Enable 2.5G Ethernet interface")
Signed-off-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Tested-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260804-b4-sgmiieth_serdes_regulator-v2-3-c4bc688177dd@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso | 3 ++-
 arch/arm64/boot/dts/qcom/lemans-evk.dts                | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso b/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso
index e42314c648579..e34639460a966 100644
--- a/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso
+++ b/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso
@@ -283,7 +283,8 @@ dev@0,1 {
 };
 
 &serdes1 {
-	phy-supply = <&vreg_l5a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l1c>;
 
 	status = "okay";
 };
diff --git a/arch/arm64/boot/dts/qcom/lemans-evk.dts b/arch/arm64/boot/dts/qcom/lemans-evk.dts
index a45485b54a5b7..301461e49ffe4 100644
--- a/arch/arm64/boot/dts/qcom/lemans-evk.dts
+++ b/arch/arm64/boot/dts/qcom/lemans-evk.dts
@@ -978,7 +978,8 @@ &sdhc {
 };
 
 &serdes0 {
-	phy-supply = <&vreg_l5a>;
+	vdda-0p9-supply = <&vreg_l4a>;
+	vdda-1p2-supply = <&vreg_l1c>;
 
 	status = "okay";
 };
-- 
2.53.0



