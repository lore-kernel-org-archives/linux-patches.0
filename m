Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD13669318;
	Wed, 21 Feb 2024 13:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522608; cv=none; b=Mu9xoz7JjLYqj+xlMjsLBtF6wvDsD0mdSWmwU+agyJx7iRra18Exj7qjU55/81AxDQhkhyPCLkMcHc+sWap1c6NZnaCe7ftkn5qV8CtQ/Z+9OukaSUdpkoPJiZgI9+y+hoGXRpS2VbvRUIyy7PM1/TxlsKrgCAQv4fl7ZczpMNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522608; c=relaxed/simple;
	bh=8B+OgOdpXUNwB6UKX2s/2SWWQHr4BuNMS/fUaZcP/Bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gtzU3AbjeTAIYsE3F0V6KGQUWXT24kET0gtHfcndh/KIx/VU/8+QTCiZCuSW+sMnj4Rrm6xzII8Q5KWzqmDrHUkmwkOayIatdCT9YqJGkowshrFyowPIDCGek2PgjWD1YoJbSOhQiIfPlnS/4sF9O8xQ5x799XSCRiKTOp9Ctdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRba+sxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRba+sxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5472BC433C7;
	Wed, 21 Feb 2024 13:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522608;
	bh=8B+OgOdpXUNwB6UKX2s/2SWWQHr4BuNMS/fUaZcP/Bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YRba+sxBYW2uI/e/J09+Ncqg7Q4431vx5FalgmxqZLgraBpXqJHhslsK+r9N1eEIZ
	 iCcEmRYu6iyh/90sZ9DKXXWGUQB1rGEzBauvDF/JKuoep075VvlqmR+wQ0zow7E3YH
	 PiP9pcDwLvMFM86I9oENZ4fj6AXIu20E8dpEX0hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 181/476] ARM: dts: rockchip: fix rk3036 hdmi ports node
Date: Wed, 21 Feb 2024 14:03:52 +0100
Message-ID: <20240221130014.589097203@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ffa9bc7ed3d0..0af1a86f9dc4 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -402,12 +402,20 @@
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



