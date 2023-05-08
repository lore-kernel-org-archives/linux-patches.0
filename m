Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2C9B171A1
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:33:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 309C4C433EF;
	Mon,  8 May 2023 11:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545604;
	bh=+9dbWVpEtpc6z7gs1N0vw4jjp2xoJ9OTc8H7DWiWL8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W0aDU+jjJpj34f45kvbKhY39LKj3b0q1eTjzW1y1JmYF8E5KFHQzJFyngg6IPm/vg
	 8yeevyi+uA1QpPLS8UXY7vxB3vuhD5cPZYqT7LL9rs3RKJswQxLb39QikiXCQkvd1j
	 2ySCBYPpqAZsxSf2lsGNgvNj2xMf98z0h4oWtTM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/371] arm64: dts: broadcom: bcmbca: bcm4908: fix procmon nodename
Date: Mon,  8 May 2023 11:44:54 +0200
Message-Id: <20230508094815.745532848@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>
References: <20230508094811.912279944@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit f16a8294dd7a02c7ad042cd2e3acc5ea06698dc1 ]

This fixes:
arch/arm64/boot/dts/broadcom/bcmbca/bcm94908.dtb: syscon@280000: $nodename:0: 'syscon@280000' does not match '^([a-z][a-z0-9\\-]+-bus|bus|localbus|soc|axi|ahb|apb)(@.+)?$'
        From schema: schemas/simple-bus.yaml

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/all/20230228144400.21689-3-zajec5@gmail.com/
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi b/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi
index 03e27bcc44464..b7db95ce0bbf2 100644
--- a/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi
+++ b/arch/arm64/boot/dts/broadcom/bcmbca/bcm4908.dtsi
@@ -253,7 +253,7 @@
 			};
 		};
 
-		procmon: syscon@280000 {
+		procmon: bus@280000 {
 			compatible = "simple-bus";
 			reg = <0x280000 0x1000>;
 			ranges;
-- 
2.39.2



