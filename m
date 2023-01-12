Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6243746A
	for <patches@lists.linux.dev>; Thu, 12 Jan 2023 14:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B1BC43396;
	Thu, 12 Jan 2023 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673532051;
	bh=Ij+OaGhY+QY3juU0I3MtVx1XsNjyXj6pw+T9Jld6ZKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L1bWYBeXARHkG7rQOsWMm/5pd6AQzLRnkLzlfPAqDDcP0MqbSQvgz5jFAiGcvIHP2
	 rlNuWDALyfNve4kF1UUTHBIP3X5OGXRRKjtV1gNg+xmSW1RjOpov2KoGP0aB9/vyqV
	 E1EG1xTXIjqOle8LtyZZjSq2bS7QJNDDzqi1wri4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/783] ARM: dts: turris-omnia: Add ethernet aliases
Date: Thu, 12 Jan 2023 14:45:51 +0100
Message-Id: <20230112135525.779391233@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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



