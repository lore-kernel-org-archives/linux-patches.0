Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DC7B184535;
	Tue, 30 Jul 2024 16:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355803; cv=none; b=At3GbPsO1umEobxxcvFSFwftY7/eToL+jUNZ9SQ4FGREfjxJjVldSSixnZnbKZfQ9Fz3Nno3WCbuD8oYNCXQi2YyP8K4OtfdFhpzIKrCcenj4cewixOV5iMsE8GilmPrF2lBdG1NXS1zcRGU3aDdl65JIlSxM/jO203VFnADz9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355803; c=relaxed/simple;
	bh=4mnUT5v9UOp0Als1+snwfqczucg9LZ6AXg77oswU87Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e5I5+CI8SDuN5QrS1L7ck+pHB3WIgCS2gqi6oRZr8ol9UqV2DqO2ZNBFFGsqnkQVFkG5QQJ7grGIpA5GsuNFu8WWy6ln6PhLxBce0XGanE1qHOwvHIce8p9rqe3Esomo9ujI7Xye9m8wOibdxeOh5/44qxdhjpv6YdvEAbjfkP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PSo3wMHp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PSo3wMHp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B53EFC32782;
	Tue, 30 Jul 2024 16:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355803;
	bh=4mnUT5v9UOp0Als1+snwfqczucg9LZ6AXg77oswU87Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PSo3wMHp/ugK9p3o31REjGiLb0ZhzTXhY9Ax6Ox32xJqQEEzv8GMYNUgEsMylqa2J
	 /vB3Lfn5qvoq+whbfEwYpGR2si0yI4/iY8lJCwh7WGu2FdDDXMNh2mjfG4g0S9FohA
	 Jr7ZZBYZD6vLbutHCrLSjYmTy8h7Zv59FN5oMUmU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Udit Kumar <u-kumar1@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 075/809] arm64: dts: ti: k3-am62-main: Fix the reg-range for main_pktdma
Date: Tue, 30 Jul 2024 17:39:11 +0200
Message-ID: <20240730151727.602836591@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit 6edad223553c7f1680fcaca25ded59eba7c6d82d ]

For main_pktdma node, the TX Channel Realtime Register region 'tchanrt'
is 128KB and Ring Realtime Register region 'ringrt' is 2MB as shown in
memory map in the TRM[0] (Table 2-1).
So fix ranges for those register regions.

[0]: <https://www.ti.com/lit/pdf/spruiv7>

Fixes: c37c58fdeb8a ("arm64: dts: ti: k3-am62: Add more peripheral nodes")
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Reviewed-by: Udit Kumar <u-kumar1@ti.com>
Link: https://lore.kernel.org/r/20240430105253.203750-2-j-choudhary@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
index 448a59dc53a77..0f2722c4bcc32 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -141,8 +141,8 @@ main_pktdma: dma-controller@485c0000 {
 			compatible = "ti,am64-dmss-pktdma";
 			reg = <0x00 0x485c0000 0x00 0x100>,
 			      <0x00 0x4a800000 0x00 0x20000>,
-			      <0x00 0x4aa00000 0x00 0x40000>,
-			      <0x00 0x4b800000 0x00 0x400000>,
+			      <0x00 0x4aa00000 0x00 0x20000>,
+			      <0x00 0x4b800000 0x00 0x200000>,
 			      <0x00 0x485e0000 0x00 0x10000>,
 			      <0x00 0x484a0000 0x00 0x2000>,
 			      <0x00 0x484c0000 0x00 0x2000>,
-- 
2.43.0



