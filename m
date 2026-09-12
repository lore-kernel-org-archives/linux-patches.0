Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D0E73148DA;
	Sat, 12 Sep 2026 07:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199830; cv=none; b=ACCaHcqkHZ6uScIAPkVjS/BCxHFRD5Y9jujpvT7tuJmz36EKjoWFG7FNLWm+vjz5BspI+wM6Tcu4Ip5LuDZjoZkfOIJAg0ueGGzleKoc5rp0nTin4ln6vzk6eT9S5VsUI/E7EiQDO4kqXHJ9BuiaJhlTOA5byUY5muvecClMBTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199830; c=relaxed/simple;
	bh=EOGraD/WzTP4FpgSxSlofu47HumlggasmY4sJN4BMMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S//LYB+RISExnjndTZHyti4Q7XPovnZ+47AQlw8E8EYe99m01dVu3bwMXheUqrdz8v22CBAj3pdDcY6rw91Htx2DQEDjiUdhnGCRwc4KyJPPe4TuSYd8e9iqhLip8GYsS4SrutIrbNW07/rnWR+xeTG3iOD3PHMBjDmnhKVi+xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g0wVg9UU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g0wVg9UU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259521F000FF;
	Sat, 12 Sep 2026 07:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199829;
	bh=XOyrUrHy3+EgShX+f/sZmTp4xr+5hFU0K/hrOYwwYcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g0wVg9UUpibR7VrYPVbVKDdmFzEAfzOQVFryN0Utfamf2nOpAeqHuoBEAamI+rQui
	 eJFOeNchm8gpXIm6eBWrkWFOMRqBzcCm8NXeQX4yphx/rEbaiqUIhWEY31pBsbShbF
	 Yi1HOiGUX/Y6LSPY982cbbZb/fhbG2SVtrhcVjcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Inochi Amaoto <inochiama@gmail.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0665/1815] riscv: dts: spacemit: Fix phy id check for the phy on com260 board
Date: Sat, 12 Sep 2026 08:40:15 +0200
Message-ID: <20260912065704.496935350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Inochi Amaoto <inochiama@gmail.com>

[ Upstream commit 9db839d52ccd9af67d460cb9ac893276a74b88e5 ]

Current phy framework can not re-initialize the phy correctly, as it will
assert the phy reset GPIO so the phy id can not be read. Setting the
phy id of board com260 manually so the phy id dectection can be skipped.

Fixes: cfe5c91cb73c ("riscv: dts: spacemit: k3: Initial support for CoM260-IFX board")
Signed-off-by: Inochi Amaoto <inochiama@gmail.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260725233351.55004-3-inochiama@gmail.com
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k3-com260.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
index b704b537385c7..2a07cd8f2a562 100644
--- a/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
+++ b/arch/riscv/boot/dts/spacemit/k3-com260.dtsi
@@ -174,7 +174,7 @@ &eth1 {
 
 	mdio {
 		phy1: phy@1 {
-			compatible = "ethernet-phy-ieee802.3-c22";
+			compatible = "ethernet-phy-id001c.c916";
 			reg = <1>;
 			reset-gpios = <&gpio 1 5 GPIO_ACTIVE_LOW>;
 			reset-assert-us = <10000>;
-- 
2.53.0



