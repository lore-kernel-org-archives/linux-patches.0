Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140C528ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5795CC433D2;
	Mon, 12 Dec 2022 13:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670853283;
	bh=yH+nIYxhLR6srz2H2nH6u7Et12lm54Uyyxcx45MZ+UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OTs7+X4+UuEfTSin4ifta1W7JeJi9W0LaSblMROViuVgJ+cdOUv/xz1FD/fSFxL8Z
	 y1wFkCqMR/y4nynAoK8gx/FowiYwF0K5UJlKGzqky1GhdTZqLt0w012CCNpJXlrIPm
	 z3zGp4KlOdomQgEor6cGXMkvKOd8MHqXPNmhf358=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 02/31] ARM: dts: rockchip: fix ir-receiver node names
Date: Mon, 12 Dec 2022 14:19:20 +0100
Message-Id: <20221212130910.085852388@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
References: <20221212130909.943483205@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit dd847fe34cdf1e89afed1af24986359f13082bfb ]

Fix ir-receiver node names on Rockchip boards,
so that they match with regex: '^ir(-receiver)?(@[a-f0-9]+)?$'

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/ea5af279-f44c-afea-023d-bb37f5a0d58d@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3188-radxarock.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/rk3188-radxarock.dts b/arch/arm/boot/dts/rk3188-radxarock.dts
index 1da46d138029..54e8e5dca93b 100644
--- a/arch/arm/boot/dts/rk3188-radxarock.dts
+++ b/arch/arm/boot/dts/rk3188-radxarock.dts
@@ -104,7 +104,7 @@
 		#sound-dai-cells = <0>;
 	};
 
-	ir_recv: gpio-ir-receiver {
+	ir_recv: ir-receiver {
 		compatible = "gpio-ir-receiver";
 		gpios = <&gpio0 10 1>;
 		pinctrl-names = "default";
-- 
2.35.1



