Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C264217AAD
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4722BC433C8;
	Wed,  9 Aug 2023 11:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580816;
	bh=P4yEpatrAFnwbMwNmW7c4ois5O6wN0Ojycd2MqatrVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZD9Udq1lODv8ADKvM8u8OCLfXzFc29xgOAtWL6LzOKhKbLDd5JkrtoUnsCxKGa/N9
	 9qLYtFqmFfblYG4e1kksPbOtliOwdYL4odXxFCV7DMjpa5FF0hsByY2EFsMkahT+38
	 g6501vlpzTKoH0N/J/IydD8P5CCIWxmv3ATWXBeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 150/154] ARM: dts: nxp/imx6sll: fix wrong property name in usbphy node
Date: Wed,  9 Aug 2023 12:43:01 +0200
Message-ID: <20230809103641.809206958@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit ee70b908f77a9d8f689dea986f09e6d7dc481934 ]

Property name "phy-3p0-supply" is used instead of "phy-reg_3p0-supply".

Fixes: 9f30b6b1a957 ("ARM: dts: imx: Add basic dtsi file for imx6sll")
cc: <stable@vger.kernel.org>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6sll.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/imx6sll.dtsi b/arch/arm/boot/dts/imx6sll.dtsi
index e8623d77eb42b..ad3deb82a50ac 100644
--- a/arch/arm/boot/dts/imx6sll.dtsi
+++ b/arch/arm/boot/dts/imx6sll.dtsi
@@ -550,7 +550,7 @@ usbphy2: usb-phy@20ca000 {
 				reg = <0x020ca000 0x1000>;
 				interrupts = <GIC_SPI 41 IRQ_TYPE_LEVEL_HIGH>;
 				clocks = <&clks IMX6SLL_CLK_USBPHY2>;
-				phy-reg_3p0-supply = <&reg_3p0>;
+				phy-3p0-supply = <&reg_3p0>;
 				fsl,anatop = <&anatop>;
 			};
 
-- 
2.40.1



