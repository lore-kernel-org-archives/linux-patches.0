Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D96BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:59:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 546D8C433EF;
	Tue,  7 Mar 2023 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211945;
	bh=KdT5cdtrr7CIf/EfSUMYBfTXiMKM4jDUZ6YwFh2ToIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7e0ftAyOAJ5bbboyzOn094g9M1zgCu2zE9I4xHjcA+/CxhRDQRC3HClatskN8QTl
	 mnos73XcNfE6fzC/wYvf89T6KX982xfC3JJbCEKiegfg1/njBTbTvzJSUxqfOQKRrm
	 JEnLuqaFNS6DSfyX9VAuYRcEWwYbcTBglOXHNLcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/885] arm64: dts: meson-axg: jethub-j1xx: Fix MAC address node names
Date: Tue,  7 Mar 2023 17:49:21 +0100
Message-Id: <20230307170002.835679726@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

[ Upstream commit 2f66eeb06e3e8b1cac9e9093be3baadbac2709eb ]

Node names should use hyphens instead of underscores to not cause
warnings.

Fixes: 59ec069d5055 ("arm64: dts: meson-axg: add support for JetHub D1p (j110)")
Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230111211350.1461860-4-martin.blumenstingl@googlemail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi     | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
index 5836b00309312..22fd43b5fd73c 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg-jethome-jethub-j1xx.dtsi
@@ -168,15 +168,15 @@ sn: sn@32 {
 		reg = <0x32 0x20>;
 	};
 
-	eth_mac: eth_mac@0 {
+	eth_mac: eth-mac@0 {
 		reg = <0x0 0x6>;
 	};
 
-	bt_mac: bt_mac@6 {
+	bt_mac: bt-mac@6 {
 		reg = <0x6 0x6>;
 	};
 
-	wifi_mac: wifi_mac@c {
+	wifi_mac: wifi-mac@c {
 		reg = <0xc 0x6>;
 	};
 
-- 
2.39.2



