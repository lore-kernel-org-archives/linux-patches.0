Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5DD030C37A;
	Mon, 13 Oct 2025 15:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368038; cv=none; b=EheaEXhqwahbxpn36JVS6qpPyn0lOL8J8MY/6+0QfP71J15bVHiy1RF6O+QBq/CBPYamggw7E2R4frZ0Myo8kg35BPGVx+Zs2mz09MBBOju+lF6jAU/I/aniYbtaCUFDGpHxhInyUMBc3fYBg75ReOTvM2t/V1hFPsFUOf5bC74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368038; c=relaxed/simple;
	bh=rK7Htv5gUeprbWN6enzdxJVWQx4B+pBk8HSpE6azPjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dm6Uhu54XAx2GXVi3cjkgmsgDKA1Tt9w+QwDnjpIgi0y9RNtpIUk1YTGBbWUczPV38VRjv/Q+MlIl2caTvpFOt/HrFObK+oFXD2DkiBfuFKyaimEptVFWFCM+xr4KwmeYPlUrsrbDYMGChRyfGviwrpB5YzquHsz20JU078i5Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqQTiTP7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqQTiTP7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17567C4CEE7;
	Mon, 13 Oct 2025 15:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368038;
	bh=rK7Htv5gUeprbWN6enzdxJVWQx4B+pBk8HSpE6azPjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqQTiTP7WOxyw1tVYGYSDNJ17F5ZUjD+xG/V+A8gQCZeyFozcUcxzxN5AZhF4AD7A
	 6yrvMt5mqhFE0pneztJM83iOg+otTcz5FnRdS9pFo77qEdt7VKuurPA5AMPUQz5TVZ
	 RGx/3j0kfhch97CNkaTT8UXd3TUUQ/JoqPxHutoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 022/262] ARM: dts: renesas: porter: Fix CAN pin group
Date: Mon, 13 Oct 2025 16:42:44 +0200
Message-ID: <20251013144326.930566283@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 287066b295051729fb08c3cff12ae17c6fe66133 ]

According to the schematics, the CAN transceiver is connected to pins
GP7_3 and GP7_4, which correspond to CAN0 data group B.

Fixes: 0768fbad7fba1d27 ("ARM: shmobile: porter: add CAN0 DT support")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/70ad9bc44d6cea92197c42eedcad6b3d0641d26a.1751032025.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r8a7791-porter.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/renesas/r8a7791-porter.dts b/arch/arm/boot/dts/renesas/r8a7791-porter.dts
index 93c86e9216455..b255eb228dd74 100644
--- a/arch/arm/boot/dts/renesas/r8a7791-porter.dts
+++ b/arch/arm/boot/dts/renesas/r8a7791-porter.dts
@@ -290,7 +290,7 @@ vin0_pins: vin0 {
 	};
 
 	can0_pins: can0 {
-		groups = "can0_data";
+		groups = "can0_data_b";
 		function = "can0";
 	};
 
-- 
2.51.0



