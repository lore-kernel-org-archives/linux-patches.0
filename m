Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E880D1C68C;
	Sun,  1 Sep 2024 16:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208640; cv=none; b=PPXWWLALjS9G2+O6BYusPAkBn3MM87qKEmM9WpPohr/wLocUVwguO2h0KckC5HNmTKzcLAEzpsHYUDE1AxAfUqQ6NKgBqxoIObhDDVyfE5H11QLTIip2Bdkfnlmvl71COfJQdz9m75yAp4qcjWk3tgEDIx9V8ODJBOJCu8LE7wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208640; c=relaxed/simple;
	bh=+l9kL9t/G4Zz8y08EInjIMh23Y/yHOwNdOshJD9QDnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AyECFdw7I+E4p4XxeJWxks452YrMcw2WA+YBGyxov54eNF4DxR0MSbR5yeccOD83sNtOkL3M5xpr/s/C8wZdacksbe9FT6JgeaIaciBwvJ+dSsjfyg0EX1PAmEC3vZDmwa6pyuIKb6eyQbVawRrrN5G10YDQQnoXLmfyN5aWr9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BH14RBDg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BH14RBDg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59369C4CEC3;
	Sun,  1 Sep 2024 16:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208639;
	bh=+l9kL9t/G4Zz8y08EInjIMh23Y/yHOwNdOshJD9QDnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BH14RBDgAJXhHnUIcqdfHYo3MIC8E/4pfLBIKOuNjwJC3fQMTOM/N1iQAczFGySOB
	 PQWOhbvKY7hastpAvZsOVQdL95W/+GJNcaubjC0y11ZTgMOiUORcrJGmZhFr5xyJtG
	 uK5ENxYO0NMVXwQONuvVA1w8oKADrYktddbtXLWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Niebel <Markus.Niebel@ew.tq-group.com>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 144/149] arm64: dts: freescale: imx93-tqma9352: fix CMA alloc-ranges
Date: Sun,  1 Sep 2024 18:17:35 +0200
Message-ID: <20240901160822.861447787@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Markus Niebel <Markus.Niebel@ew.tq-group.com>

[ Upstream commit cd0c6872aab4d2c556a5e953e6926a1b4485e543 ]

DRAM starts at 0x80000000.

Fixes: c982ecfa7992 ("arm64: dts: freescale: add initial device tree for MBa93xxLA SBC board")
Signed-off-by: Markus Niebel <Markus.Niebel@ew.tq-group.com>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi b/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
index 9d2328c185c90..fe951f86a96bd 100644
--- a/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx93-tqma9352.dtsi
@@ -19,7 +19,7 @@
 		linux,cma {
 			compatible = "shared-dma-pool";
 			reusable;
-			alloc-ranges = <0 0x60000000 0 0x40000000>;
+			alloc-ranges = <0 0x80000000 0 0x40000000>;
 			size = <0 0x10000000>;
 			linux,cma-default;
 		};
-- 
2.43.0



