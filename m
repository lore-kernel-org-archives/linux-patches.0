Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18C63BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705E9C433D2;
	Tue,  7 Mar 2023 17:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209088;
	bh=R1/unQV/H/gt2kwnoeyRaXnV71mwM9QAP+KQryADqDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIPQNcfbHgXUvYpIPG18lVHXrs4wSJVmwcgLhPInBaTIDMltb+0W1fVpTihdBqU6V
	 G+77hjrL8evq0f12B10BQuR3o5RAxuZwJe9zfe5lE/7EeQE3ufNldwgewWhGWJ997/
	 DAqyJS8bT2oLmemcGXW+9kK3mf2VmQR+SI9d1urA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Hewitt <christianshewitt@gmail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0089/1001] arm64: dts: meson: radxa-zero: allow usb otg mode
Date: Tue,  7 Mar 2023 17:47:41 +0100
Message-Id: <20230307170026.020603130@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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



