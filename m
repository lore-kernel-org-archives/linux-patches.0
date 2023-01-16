Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E765246B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69B4FC433D2;
	Mon, 16 Jan 2023 16:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885414;
	bh=Ij+OaGhY+QY3juU0I3MtVx1XsNjyXj6pw+T9Jld6ZKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2dnyug2ZuYUyQjirXke6ZBz89revotEmj9dI+UnR6I5joyleNnvWMO93rP76TCF5
	 a4PBE0C3OBJiGOb8IdY238G6+mI+dHY/fOSYR8Lm89ed/UaJj1zdnOvNCU+GurEEXP
	 AEPW/rMhkzrotpTDpGhJPb1MG/8FKbnTxPokik9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 043/658] ARM: dts: turris-omnia: Add ethernet aliases
Date: Mon, 16 Jan 2023 16:42:11 +0100
Message-Id: <20230116154911.580684979@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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

[ Upstream commit f1f3e530c59a7e8c5f06172f4c28b945a6b4bfb8 ]

This allows bootloader to correctly pass MAC addresses used by bootloader
to individual interfaces into kernel device tree.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 26ca8b52d6e1 ("ARM: dts: add support for Turris Omnia")
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/armada-385-turris-omnia.dts | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm/boot/dts/armada-385-turris-omnia.dts b/arch/arm/boot/dts/armada-385-turris-omnia.dts
index 92e08486ec81..c0a026ac7be8 100644
--- a/arch/arm/boot/dts/armada-385-turris-omnia.dts
+++ b/arch/arm/boot/dts/armada-385-turris-omnia.dts
@@ -22,6 +22,12 @@ chosen {
 		stdout-path = &uart0;
 	};
 
+	aliases {
+		ethernet0 = &eth0;
+		ethernet1 = &eth1;
+		ethernet2 = &eth2;
+	};
+
 	memory {
 		device_type = "memory";
 		reg = <0x00000000 0x40000000>; /* 1024 MB */
-- 
2.35.1



