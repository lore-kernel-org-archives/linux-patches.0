Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040213;
	b=QU2y+R+wdzUTKCET/kY4mHv1c6WKG1IFnlBUzxR8A1AaQyVHYWZy+qULBwSo/70l+IjS
	 7oonuNBiI6NaK8NwMP2aRmIsFlh2rUj1WMClA6QvJYRP2k1KT9Nsudz0Yy3Jvqhq6MVVA
	 zYJOp0H6OOP07pwKfFjpYOxLcqKGlcoZ4X2PbZi5kzUkU1zpxNPxPbx9ltcgFAk5DClIX
	 WIdaYpJAxbNzNphkd81hxZ/WVc9XxoKAdNLUhH/yXcCnNsyxYiXLEvEGEkF3aIiU5cpUJ
	 +1tua7zAXdY/oxUAzcJ30n1MGqc3dwZZNRL16wg/9nbLxtGQspVTnwC+tovyAjrVSzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6qZZNHacPpX1n0BIyZYNftTVWud2yK4Rw168gM3TkpU=;
	b=dXCOGtEYmDsCE53+dh+zSTl+lRBHwPF5dvc9T+uGZ6XTdBDlqxwlRko+Hak2SA3dzvzH
	 jOLM4gB6+EJftRb2v6sEc4v51qiMTzZVFJKnl3ERFNXZTXX0s/Un6YXBH9ZUUjJoFSO/U
	 crnpmilpr7uxgidu8CjnZKs8SDraYoGPCzwUWNcC8fZG5N1fxJgwe7dSw11m2BDB91w/4
	 ALV2duJtLslba/ltFCamstZ7xMQII8i3cIozMXIk5UmlbZUjF+WX8x0wWcjxMO5c7Q8iY
	 3ZisWMiG/HsLsP1uI39sqbZarsc4IkCeykbRYrcJ/IyBomqX8Lv4JWnO9ZpWrjXRw7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vHI/OuiG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61783606A325;
	Wed, 18 Nov 2026 22:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vHI/OuiG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DF51F000C4;
	Wed, 18 Nov 2026 22:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040213;
	bh=6qZZNHacPpX1n0BIyZYNftTVWud2yK4Rw168gM3TkpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vHI/OuiG9WL6PWtyNV0knCJN2wKLdGIei7ZsN3ydn/FcKPhBI+BjSEBT/vC5jFy9z
	 AhwLRGTD4aMdpICPEETqba9iKgUjixtP6DEwPdqoS0zPiiQL73y4mU867YIcg3U1BC
	 Bkfy0eno2sae+boSna+dm+4RBb6/x9BoGjJu2UC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2378/3318] arm64: dts: qcom: lemans-ride-common: fix SerDes PHY regulator supplies
Date: Wed, 18 Nov 2026 15:50:00 +0100
Message-ID: <20261118150432.885573589@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 864ad109371ca..8cb23f4f4a20b 100644
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



