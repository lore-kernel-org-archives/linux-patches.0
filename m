Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F78CBA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2205C433A0;
	Tue,  7 Mar 2023 18:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212073;
	bh=R1/unQV/H/gt2kwnoeyRaXnV71mwM9QAP+KQryADqDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NALZ3nFV7qd5+95sPay4eHKNAO2vj5wlLlX4BxkyYlzN3JDr0QwxYRfIqKnxa95Kj
	 3D7L0ZnMIxPPKXXf9xz0UhGcdFYk++i1QW4v5AOZylKeGpn4oyay3N4G0FKsl76aRE
	 m9ouIiTNjHP+GYpG2aa6sR5bVBO/nnmMfwus4xgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/885] arm64: dts: meson: radxa-zero: allow usb otg mode
Date: Tue,  7 Mar 2023 17:50:02 +0100
Message-Id: <20230307170004.733912207@linuxfoundation.org>
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

From: Christian Hewitt <christianshewitt@gmail.com>

[ Upstream commit ce43ea00b927805c1fd0450ccc9b4b6069e292c5 ]

Setting dr_mode to "host" prevents otg which can be useful on a board
with limited connectivity options. So don't force host mode.

Fixes: 26d1400f7457 ("arm64: dts: amlogic: add support for Radxa Zero")
Signed-off-by: Christian Hewitt <christianshewitt@gmail.com>
Acked-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20230127103913.3386435-1-christianshewitt@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dts b/arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dts
index e3bb6df42ff3e..cf0a9be83fc47 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-g12a-radxa-zero.dts
@@ -401,5 +401,4 @@ &uart_AO {
 
 &usb {
 	status = "okay";
-	dr_mode = "host";
 };
-- 
2.39.2



