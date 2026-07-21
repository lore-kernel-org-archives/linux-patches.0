Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D71446A603;
	Tue, 21 Jul 2026 15:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648919; cv=none; b=eo5Ywno7YB8S3iNUp/eoW1YRLu716ChUWzZNMaWiyRubPiN8nla6beiSi7vgJMhiKgrZUlaZQIT+GEvG3UKxawwTLJ9wdx70I3nU2U1Ll5eMMT0RVfmWrrWGwELFCuicHMzg8jsbUV+JdQmYXmUyNUtk2xwtx1u62Ph2uMnI4YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648919; c=relaxed/simple;
	bh=PlV2Bo8dmXX24zmCE4D5kk7wBuN1Roh8stD5w12XJS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oHWL4zI06w9AYqvDRPyQq3dznkKN4JQKCSrexuC7NFylKxkJYqjALZbWrmJrF4+2OtUNFPip0vKO9wUUPqBDgd964pp+IE6otnZ/NmISLdnwvfCQGKVOnnQxBkuukd56Qsq21qM878Mq++t38Ewf1FrbDM7IGqVe9ccA56+X9Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VNqkac+h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VNqkac+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717161F00A3A;
	Tue, 21 Jul 2026 15:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648917;
	bh=b6szPm88xIaGIQ84drB1egCraW/YsbXwGjAYDBBaXe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNqkac+hHlBHmlGiIh6cIr6l8QE0zEiW5Rv45AZDTgAGi830DFBi3Fd4thPFtMk9t
	 ToYaAVk+URIB7zCgmwBKVpSq2IaFKgGYxOlfnIBSwz+0TnEIAZKuTzkGlIWfAIAW/M
	 ccdCs0Qkgr5VENGH2+6CrDPipwZgkOjd5S5HJKeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinseok Kim <always.starving0@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0381/2077] arm: dts: bcm2711: Fix typo in gpio-line-names
Date: Tue, 21 Jul 2026 17:00:54 +0200
Message-ID: <20260721152601.682615849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinseok Kim <always.starving0@gmail.com>

[ Upstream commit 245552af869d35ae27cac2121696dd630f15b3bf ]

Replace "RGMIO_MDC" with "RGMII_MDC" in gpio-line-names.

Signed-off-by: Jinseok Kim <always.starving0@gmail.com>
Link: https://lore.kernel.org/r/20260527103930.2973-1-always.starving0@gmail.com
Fixes: cd87c180b301 ("ARM: dts: bcm2711-rpi-4-b: Add SoC GPIO labels")
Fixes: ea93ada05c9e ("ARM: dts: Add Raspberry Pi Compute Module 4 IO Board")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm2711-rpi-4-b.dts    | 2 +-
 arch/arm/boot/dts/broadcom/bcm2711-rpi-cm4-io.dts | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm2711-rpi-4-b.dts b/arch/arm/boot/dts/broadcom/bcm2711-rpi-4-b.dts
index 353bb50ce5425c..5469fa663526f7 100644
--- a/arch/arm/boot/dts/broadcom/bcm2711-rpi-4-b.dts
+++ b/arch/arm/boot/dts/broadcom/bcm2711-rpi-4-b.dts
@@ -110,7 +110,7 @@ &gpio {
 			  "GPIO26",
 			  "GPIO27",
 			  "RGMII_MDIO",
-			  "RGMIO_MDC",
+			  "RGMII_MDC",
 			  /* Used by BT module */
 			  "CTS0",		/* 30 */
 			  "RTS0",
diff --git a/arch/arm/boot/dts/broadcom/bcm2711-rpi-cm4-io.dts b/arch/arm/boot/dts/broadcom/bcm2711-rpi-cm4-io.dts
index 6bc77dd48c0d9b..1f4ebec68370c9 100644
--- a/arch/arm/boot/dts/broadcom/bcm2711-rpi-cm4-io.dts
+++ b/arch/arm/boot/dts/broadcom/bcm2711-rpi-cm4-io.dts
@@ -56,7 +56,7 @@ &gpio {
 			  "GPIO26",
 			  "GPIO27",
 			  "RGMII_MDIO",
-			  "RGMIO_MDC",
+			  "RGMII_MDC",
 			  /* Used by BT module */
 			  "CTS0",
 			  "RTS0",
-- 
2.53.0



