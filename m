Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4629BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C10C433D2;
	Tue,  7 Mar 2023 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678211786;
	bh=2JJgs9MSqLa2QW9pGjiGKto7hRoTLiCW0Bm9U7ktLKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAF12j8117MwbGBEXEZpjkjppcqAZ2uLBaGFd6IRtkYN8IRSbgp/8cVzDDV58Tf3a
	 eMyOQVRR2zVtpl5nPGh7U7rvohJlnbR/mV6k8b4CM4qpSnVkAfthvvfOuiElbUdrt2
	 SrZaCUzBFqWAnBGi4IgSFuw2jShqsKXg2nSbY/us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 6.2 0977/1001] MIPS: DTS: CI20: fix otg power gpio
Date: Tue,  7 Mar 2023 18:02:29 +0100
Message-Id: <20230307170104.611811903@linuxfoundation.org>
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

From: H. Nikolaus Schaller <hns@goldelico.com>

commit 0cb4228f6cc9ed0ca2be0d9ddf29168a8e3a3905 upstream.

According to schematics it is PF15 and not PF14 (MIC_SW_EN).
Seems as if it was hidden and not noticed during testing since
there is no sound DT node.

Fixes: 158c774d3c64 ("MIPS: Ingenic: Add missing nodes for Ingenic SoCs and boards.")
Cc: stable@vger.kernel.org
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/boot/dts/ingenic/ci20.dts |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/boot/dts/ingenic/ci20.dts
+++ b/arch/mips/boot/dts/ingenic/ci20.dts
@@ -113,7 +113,7 @@
 		regulator-min-microvolt = <5000000>;
 		regulator-max-microvolt = <5000000>;
 
-		gpio = <&gpf 14 GPIO_ACTIVE_LOW>;
+		gpio = <&gpf 15 GPIO_ACTIVE_LOW>;
 		enable-active-high;
 	};
 };


