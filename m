Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 256112837A
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="enXF9QAn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7F20C433C7;
	Wed, 15 Nov 2023 19:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076431;
	bh=i4ehM4MTpXj524plOPc78TA52llK7WSEx0u/Vr6d6Qs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=enXF9QAnfsauW9mNOCijgmpRZ/1JY7NzEaSdkdXTuxCG9Xm2KFIKlS5HH3LVrBfuu
	 p9QeoDFyA30C4sO4/jHWyeG1Q3XX6+Xd9xVZ+kCWdKJYXQoDq/TsjPlRX/Buvd48nc
	 GbZL19R3AdAsBVHGNLfUCXC9idwk/C1bBQfL+e+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 284/550] arm64: dts: ti: k3-am625-beagleplay: Fix typo in ramoops reg
Date: Wed, 15 Nov 2023 14:14:28 -0500
Message-ID: <20231115191620.474244568@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wadim Egorov <w.egorov@phytec.de>

[ Upstream commit 33269ac0b768b07da017df173d52952625c57870 ]

Seems like the address value of the reg property was mistyped.
Update reg to 0x9ca00000 to match node's definition.

Fixes: f5a731f0787f ("arm64: dts: ti: Add k3-am625-beagleplay")
Signed-off-by: Wadim Egorov <w.egorov@phytec.de>
Reviewed-by: Nishanth Menon <nm@ti.com>
Link: https://lore.kernel.org/r/20230925151444.1856852-1-w.egorov@phytec.de
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
index 589bf998bc528..92541e9842a24 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
+++ b/arch/arm64/boot/dts/ti/k3-am625-beagleplay.dts
@@ -58,7 +58,7 @@ reserved-memory {
 
 		ramoops: ramoops@9ca00000 {
 			compatible = "ramoops";
-			reg = <0x00 0x9c700000 0x00 0x00100000>;
+			reg = <0x00 0x9ca00000 0x00 0x00100000>;
 			record-size = <0x8000>;
 			console-size = <0x8000>;
 			ftrace-size = <0x00>;
-- 
2.42.0



