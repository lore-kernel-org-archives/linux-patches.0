Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A9A7C092;
	Wed, 21 Feb 2024 14:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524125; cv=none; b=BjfqPlNloNx2end9nKIuTnLJluMqcz+2mXugbTnnf+clSUjt/cVNQYY0FNz0NM7+CPxQCoqy/WGnFRuXhsAwrM1YkjI//fs1EQJ/HbzMeJ/vzHxHNModUa53kfmcQ4Rz5xaJwQUIVDJ4eMoLQYCnp+AWj7ZeOKlxTB45iHpzuyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524125; c=relaxed/simple;
	bh=2WXOMHGqWrh/1bCzrzFetrECzgu9GVTk3SZJsvTG4y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WulOEFAFIs54pRCbBIzw3CcgRRTMddRAdPMdcQWPHKfETedsQvGYuLcLr1rhZHRMMwock3WIynNhkqzJwtvMdjv6ks7BP4Dsq/g01Gd1o17VfPHgXfGgBCQIDNtwM2HbAAnEodpczoollD1XAr5unpdOtMxKCc32AQjDu4YiBHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBK2SJNU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBK2SJNU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C857BC43394;
	Wed, 21 Feb 2024 14:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524125;
	bh=2WXOMHGqWrh/1bCzrzFetrECzgu9GVTk3SZJsvTG4y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBK2SJNU7nj27iZjppGGzAWTjHR38sndVEvNtI4Byn0vW2uyDYGTbgCDivXq7QxbG
	 lisIgKynIg9F7Tt9sJ95111pcdJ+7dVGkycmR+AzsjEeLXKa8yYMhRolXAybk4zbMy
	 SrifmROCTm/nkDSAaFt22B6R4U+j7bIYkzdowBQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/379] ARM: dts: rockchip: fix rk3036 hdmi ports node
Date: Wed, 21 Feb 2024 14:05:31 +0100
Message-ID: <20240221125959.417009870@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 27ded76ef0fcfcf939914532aae575cf23c221b4 ]

Fix hdmi ports node so that it matches the
rockchip,inno-hdmi.yaml binding.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/9a2afac1-ed5c-382d-02b0-b2f5f1af3abb@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3036.dtsi | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index 093567022386..5f47b638f532 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -336,12 +336,20 @@
 		pinctrl-0 = <&hdmi_ctl>;
 		status = "disabled";
 
-		hdmi_in: port {
+		ports {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			hdmi_in_vop: endpoint@0 {
+
+			hdmi_in: port@0 {
 				reg = <0>;
-				remote-endpoint = <&vop_out_hdmi>;
+
+				hdmi_in_vop: endpoint {
+					remote-endpoint = <&vop_out_hdmi>;
+				};
+			};
+
+			hdmi_out: port@1 {
+				reg = <1>;
 			};
 		};
 	};
-- 
2.43.0



