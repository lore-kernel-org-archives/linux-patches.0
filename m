Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6B06FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:39:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843ECC433EF;
	Mon, 16 Jan 2023 16:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887166;
	bh=HUf9MG2SfcBunpcTtBkx/jnbFRtfDyIu7IDdNiW7qcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19nW3ntge0QTqpLxJdKOE9X+EqEUxyBqAKQyTt6WeoF2IaqXdf8tOTjHscGW171hp
	 2sYfmDRP6kX0S/tACG53JDrL7tQIHvkz4rSBWF9GK7ZPIMOMYNY1wkvZ0Nfiea8fa4
	 6SbxlBkwgzdsvsrkoBiJrqUUAXFazl/zBTVzih3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/521] ARM: dts: turris-omnia: Add switch port 6 node
Date: Mon, 16 Jan 2023 16:45:01 +0100
Message-Id: <20230116154849.038884394@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit f87db2005f73876602211af0ee156817019b6bda ]

Switch port 6 is connected to eth0, so add appropriate device tree node for it.

Fixes: 26ca8b52d6e1 ("ARM: dts: add support for Turris Omnia")
Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-385-turris-omnia.dts | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index c0a026ac7be8..320c759b4090 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -297,7 +297,17 @@ fixed-link {
 				};
 			};
 
-			/* port 6 is connected to eth0 */
+			ports@6 {
+				reg = <6>;
+				label = "cpu";
+				ethernet = <&eth0>;
+				phy-mode = "rgmii-id";
+
+				fixed-link {
+					speed = <1000>;
+					full-duplex;
+				};
+			};
 		};
 	};
 };
-- 
2.35.1



