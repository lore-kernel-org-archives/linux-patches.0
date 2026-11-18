Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030169;
	b=BEmONaUgRpcTACr1e8Grsrhse7ix7BDZbSbowrlpa4YS3V1sZN0zfCkZL2eECJoJaVRx
	 BOyqy13/qYyxGm6rEVh5hbEyJMFD76s6FunZLzoIUB96hNeGFXvHbKeFjRHv9IXVomUbY
	 +scqA/NuhHttc/E1QYafbgJcjXH/pMIopOLg3KExZeujfA31ipKmOx50ksU6FDRQ+rzsf
	 PYpdKbvX7eGlb49EUBrbtT6DZPNtrEwvIkflUu7ANZX6vJLAFs8M99qqj+WTaJHVyMq6Y
	 E3svw1odmckjsZk9tJApobMRmzAthk+urTy5qCtstJJNiR2rRBgCd5pUuJMKQrVR+8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AcPA71QwEM/OUB4ZoB2/qDpME3MeJuJSeEgZQUzmztQ=;
	b=DNAiEIRSMDkDCLLPHoLBb1rzLqdYppW6hUIm6I+XtnKQnq3kAepnKIr81POMs2TXNkr3
	 Bnr158FUZFSf4zVXIMIM5s9hRHKQRmwDintUbLPuglQdRIL8U5/NWsmS+NHWR4z2TEMUr
	 UKytk2mTtamfvIEbbSFdfre52BljwiZ8/U0YxdBYdVqgwe/MJ+wK+B1Sgi+Pgqp0JilC7
	 UGWrLt+RljhY3xAOBqzOE1BL3YdmF7Y/flpqHGsCnrLCZ/4bKh6YlaDgus9R2Vba2R2se
	 btXvzXXI/jhS/vSU9LWKv8/75IH9BkMfMToYGEljVUjxY+F8NBQo8HMTK35rwhiDVmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xabp2C7t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEAC606C738;
	Wed, 18 Nov 2026 19:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xabp2C7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25BB1F000C4;
	Wed, 18 Nov 2026 19:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030168;
	bh=AcPA71QwEM/OUB4ZoB2/qDpME3MeJuJSeEgZQUzmztQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xabp2C7tIJImiq6ukPPrjwllU9RbkxS+X0Qu421nMr9RcRdkWloOCF7gXp/EJxia6
	 o9tmGg83lHs2sdlcILnv4o5TjbsDzy8wwfe7iF2+iLZ1FSCJN0vsmmIWxY0JtSsu5X
	 mGf4PQaJzXbATy0lVJixaG+X69T0eQN0RzGp/kfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0602/1756] arm64: dts: qcom: lemans-ride-common: fix SerDes PHY regulator supplies
Date: Wed, 18 Nov 2026 15:45:29 +0100
Message-ID: <20261118150032.931560612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi b/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
index adb71aeff339b..76592e643801e 100644
--- a/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
+++ b/arch/arm64/boot/dts/qcom/sa8775p-ride.dtsi
@@ -507,12 +507,16 @@ &qupv3_id_2 {
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



