Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94ECB43F092;
	Mon, 17 Aug 2026 14:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978444; cv=none; b=C0g5kuIsLN2gLEVM2csP46kNIArHaxpqQYtKFL7d2puAJDa18UifiME+YyJN7tDgTmo54AMoUm+LaLxzwWj+rNjLe23so0zKiS1nfy343vnnpr4BxJ9GcuxIQ6fekCibSvVJhHUgJv0W9HIAVXXveEfyOU/TgKyEQ6I5117ukFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978444; c=relaxed/simple;
	bh=fLfxd2ErkZ72fiIv3wM45CrO+hGcgi0octevLxbyesg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTpildKtIHFbbmJhKpwoBEcjsMjpolNod7I9ZgocluPGXvz926PO13+gvhNvVLzefAUOhPUSYpFgeSAWehSE6xIILx6ZGExNCrtWXUppf4BkqJTbjAByed3tfqvkgV41UZtQ/xyt/A2OjaKGkHlLo+3PaywsJBTKvTwV9qbzVrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iYQDGrbU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iYQDGrbU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501C01F000E9;
	Mon, 17 Aug 2026 14:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978441;
	bh=3Ay8lxf3n2fP16o1mtGx1SN9i8ZYyx65BAzkh8JoEUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iYQDGrbUOaRJy+fjPOxZx1u0wY3SW0fqp96KGJqUFxl6K7pVx8q2bE3olmZwwGBwj
	 rXHwbi80YDIwzoUw7rYSuivpkc0BlUpnhAAFpyJlL6SsCOQk1zPEyW1eOjAX4rll8Y
	 3LT85/f8OXsTE2yAbVH/sqdAY0tM8ctY1EU17XXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 006/156] ARM: dts: BCM5301X: fix PCIe controller 2 second interrupt
Date: Mon, 17 Aug 2026 15:32:20 +0200
Message-ID: <20260817132534.905670348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit bab4d538f8485e0d48538fcb82b285df3779278e ]

PCIe controller 2 has interrupts 0-4 mapping to GIC SPI 138-142. The
mapping for interrupt 1 was incorrectly set to 138 due to a copy-paste
error. Fix it to 139.

Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://lore.kernel.org/r/20260725215722.9323-1-rosenp@gmail.com
Fixes: 3b3e35b279be ("ARM: dts: BCM5301X: Relicense AXI interrupts code to the GPL 2.0+ / MIT")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm-ns.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm-ns.dtsi b/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
index 88fda18af1f8e..06acd72f9835a 100644
--- a/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
+++ b/arch/arm/boot/dts/broadcom/bcm-ns.dtsi
@@ -131,7 +131,7 @@ axi@18000000 {
 
 			/* PCIe Controller 2 */
 			<0x00014000 0 &gic GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>,
-			<0x00014000 1 &gic GIC_SPI 138 IRQ_TYPE_LEVEL_HIGH>,
+			<0x00014000 1 &gic GIC_SPI 139 IRQ_TYPE_LEVEL_HIGH>,
 			<0x00014000 2 &gic GIC_SPI 140 IRQ_TYPE_LEVEL_HIGH>,
 			<0x00014000 3 &gic GIC_SPI 141 IRQ_TYPE_LEVEL_HIGH>,
 			<0x00014000 4 &gic GIC_SPI 142 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.53.0



