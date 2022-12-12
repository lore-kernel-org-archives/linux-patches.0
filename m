Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D96C28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:36:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F099C433EF;
	Mon, 12 Dec 2022 13:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852194;
	bh=uWwzdcPbXOVVbq2pf9Tbn7clwTu6D82OsExTrfO00ZI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OXl3MPsj/fYZb+fBj9rCUfntxs+tGfC4MBZkHOUrPVom7wKLywtpDCCkJtMsFQ4b0
	 EoXLaCz0QMH/5ZathWNvGZtQ353sJG0vsv9HePA5x+9W4vbzWUw/q4dhO4n5sti0pK
	 XH6tDquXn0R+mQNIdV+lfvKwuYJ74sC/vH3SRfiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furkan Kardame <f.kardame@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 004/157] arm64: dts: rockchip: Fix i2c3 pinctrl on rk3566-roc-pc
Date: Mon, 12 Dec 2022 14:15:52 +0100
Message-Id: <20221212130934.566948156@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Furkan Kardame <f.kardame@manjaro.org>

[ Upstream commit 2440ad0d851e404adcd1b9ad758f28bd59365bae ]

As per device schematic i2c3 pinctrl is connected to m0 instead of m1

Signed-off-by: Furkan Kardame <f.kardame@manjaro.org>
Link: https://lore.kernel.org/r/20221010190142.18340-3-f.kardame@manjaro.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
index 8db83088ae4e..b8ed215ab8fb 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-roc-pc.dts
@@ -397,7 +397,7 @@
 
 &i2c3 {
 	pinctrl-names = "default";
-	pinctrl-0 = <&i2c3m1_xfer>;
+	pinctrl-0 = <&i2c3m0_xfer>;
 	status = "okay";
 };
 
-- 
2.35.1



