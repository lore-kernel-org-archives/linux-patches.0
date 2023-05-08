Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF84813ADF
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:01:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 580E0C433EF;
	Mon,  8 May 2023 11:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543701;
	bh=6oXXMw4I2SU38rSDkbt672ZgxnV/Clps40hIg4opPIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ds6R0VbDY+lbEEyatekbAEYtwFB0sju6DLadtENSR0+5iGIYsaEbnJyZMQG65VMYa
	 hm5l+ZgJtE4gQrgn86+nUYaXdJDyiEESGbLfOILv/AaCBQyr9OQm13UItw0IrJ4ccP
	 xSYlvVz/b4BzSYlUQ5RQLsxB1f1M2xhkKIpqs2dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devarsh Thakkar <devarsht@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 172/694] arm64: dts: ti: k3-am62a7-sk: Fix DDR size to full 4GB
Date: Mon,  8 May 2023 11:40:07 +0200
Message-Id: <20230508094437.993476792@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Devarsh Thakkar <devarsht@ti.com>

[ Upstream commit a1bc0d6084dba8a31831c65318a8a8e46f00906f ]

All revisions of AM62A7-SK board have 4GB LPDDR4 Micron
MT53E2G32D4DE-046 AUT:B memory. Commit 38c4a08c820c ("arm64: dts: ti:
Add support for AM62A7-SK") enabled just 2GB due to a schematics error
in early revision of the board. Fix it by enabling full 4GB available on
the platform.

Design docs: https://www.ti.com/lit/zip/sprr459

Fixes: 38c4a08c820c ("arm64: dts: ti: Add support for AM62A7-SK")
Signed-off-by: Devarsh Thakkar <devarsht@ti.com>
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20230314094645.3411599-1-devarsht@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index 5c9012141ee23..f6a67f072dca6 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -27,8 +27,9 @@
 
 	memory@80000000 {
 		device_type = "memory";
-		/* 2G RAM */
-		reg = <0x00000000 0x80000000 0x00000000 0x80000000>;
+		/* 4G RAM */
+		reg = <0x00000000 0x80000000 0x00000000 0x80000000>,
+		      <0x00000008 0x80000000 0x00000000 0x80000000>;
 	};
 
 	reserved-memory {
-- 
2.39.2



