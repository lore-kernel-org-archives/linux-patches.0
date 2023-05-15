Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822F5FBE7
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:21:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2B84C433D2;
	Mon, 15 May 2023 17:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684171301;
	bh=EHZdEFikuq5C15kwAohAv2iL7b6AvDtlU+hmCPbmZrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FOWCyPczZ9/awluLd4xdtUYdcjzaeUD8Qzb3PMVubH3KkFiEjc30IcksKGOiavaSK
	 GzDLuBjEdWKA9wummQZ1YxMv04Xs2bhp4Sv2ftq/jXikloY3m3A+tMvKsvzyYfn1A3
	 IlyiRQHlc41Fs4aPUVfhN9m37K68X3sUD6aofAdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zev Weiss <zev@bewilderbeest.net>,
	Joel Stanley <joel@jms.id.au>
Subject: [PATCH 6.2 164/242] ARM: dts: aspeed: asrock: Correct firmware flash SPI clocks
Date: Mon, 15 May 2023 18:28:10 +0200
Message-Id: <20230515161726.803035846@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zev Weiss <zev@bewilderbeest.net>

commit 9dedb724446913ea7b1591b4b3d2e3e909090980 upstream.

While I'm not aware of any problems that have occurred running these
at 100 MHz, the official word from ASRock is that 50 MHz is the
correct speed to use, so let's be safe and use that instead.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Cc: stable@vger.kernel.org
Fixes: 2b81613ce417 ("ARM: dts: aspeed: Add ASRock E3C246D4I BMC")
Fixes: a9a3d60b937a ("ARM: dts: aspeed: Add ASRock ROMED8HM3 BMC")
Link: https://lore.kernel.org/r/20230224000400.12226-4-zev@bewilderbeest.net
Signed-off-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts |    2 +-
 arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-asrock-e3c246d4i.dts
@@ -63,7 +63,7 @@
 		status = "okay";
 		m25p,fast-read;
 		label = "bmc";
-		spi-max-frequency = <100000000>; /* 100 MHz */
+		spi-max-frequency = <50000000>; /* 50 MHz */
 #include "openbmc-flash-layout.dtsi"
 	};
 };
--- a/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts
+++ b/arch/arm/boot/dts/aspeed-bmc-asrock-romed8hm3.dts
@@ -51,7 +51,7 @@
 		status = "okay";
 		m25p,fast-read;
 		label = "bmc";
-		spi-max-frequency = <100000000>; /* 100 MHz */
+		spi-max-frequency = <50000000>; /* 50 MHz */
 #include "openbmc-flash-layout-64.dtsi"
 	};
 };


