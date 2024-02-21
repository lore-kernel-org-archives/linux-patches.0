Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1031B7BB16;
	Wed, 21 Feb 2024 14:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525360; cv=none; b=mGH5Stiq+d5hnhP/XED3cdYYcOWsWoKt4Je7fnVKsRxZPAog5aj5qktVWvapZMfjYpuwzRWPLVVEyYw7SNBff5SGiI+SYreOEIlgvTsLH3TEUK4uK8ATE/RgQw2QBhrecOz2zLinJ+5OUq1sdWLljRFMQUGkNMbTl4SYxDqAekU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525360; c=relaxed/simple;
	bh=8NzoKZPo2u1BiPPA/nsGJ4DcxBiXL0dh05IaQ44RZv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aq1N5gW5VYkz0e4snsGHBjmHHCsJq7MhDHprwC9QKB2P10rp5Ckhyq37ucnQp4TnG6BlGSb1vVd1apNf9/OlB+g0pg1OvOg8tC2tA0cOTW3+Cbvhc4iKvQpGh9k4FgSAxkCWcW/UdfrPK/wOmPoXAkaAyze1fEOPQsrx9UQIbho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cOdYek4r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cOdYek4r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ED6C433C7;
	Wed, 21 Feb 2024 14:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525359;
	bh=8NzoKZPo2u1BiPPA/nsGJ4DcxBiXL0dh05IaQ44RZv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cOdYek4rjiQKx8sC0s3ITcrzZyzqgWhYcu/WNcBAL0o6ySv3zrbgVmEdus6EzDlwZ
	 yuWd+kQLndeWfbVqesla+Xk0i0N5Ar4Jqi03hLra1k+cU4uOZWQk4ufVMWIWsoFU6D
	 4XrFNmLMVvrKAFiw5qR/gqsXLwIEXgojXI+KUaBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 104/267] ARM: dts: rockchip: fix rk3036 hdmi ports node
Date: Wed, 21 Feb 2024 14:07:25 +0100
Message-ID: <20240221125943.202649545@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d282a7b638d8..cc2d596da7d4 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -337,12 +337,20 @@
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



