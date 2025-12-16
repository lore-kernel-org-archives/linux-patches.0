Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2C1341645;
	Tue, 16 Dec 2025 11:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884192; cv=none; b=O5vQyUaqF+J1E/lHadiWi2DQlSVhSWxwOf7LTmjKKIBwf1puSOvn2UnTBckUJ5Y++rxbnmGaktFrwTAHel44TBdPdytgggWAI/xPRD8ViaNY9bjUY9S1v2zTXCA3Y71v2JH/21VrfhfV+KG1DJ2hWEvShvPXGduLcZ+AIt37Q4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884192; c=relaxed/simple;
	bh=lKXSLTgqfl7cx4hsY+zttnqVnDhGmZQTcZAt35X+PtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrFOee1eyR0btaoA/iM9amQFO7/5Dt6ssvdaiWPR+d2kSIx6HeNAKmahRm/vLmLE06f+NYcT4cxHF6GMsMDqc5OZrOQ6s717wwEAzp5C1lOSHoFylJ+ywRwW0f2AWqYbY/OsgevccVmL0z46ps/NwR/hTG7QYtVU5F0e+9MjT/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kwDzfvAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kwDzfvAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AE8C4CEF1;
	Tue, 16 Dec 2025 11:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884191;
	bh=lKXSLTgqfl7cx4hsY+zttnqVnDhGmZQTcZAt35X+PtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kwDzfvAyzrKq6vQkTnzkAeKF7FEuoxHLC7H8py7UKvVSWGmTzqDRf4r8VquDdK2Y6
	 frwQrQKTwJBwIqkO+tLTlcVIX7mHDvledZ4CQ7QusekfZrsX/IGK7+EUp6SGc82Jo0
	 2E9T+vttHNsRqlX4ZN6mfWrED+o7Q1XWwJ1UO8ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yegor Yefremov <yegorslists@googlemail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 119/354] ARM: dts: am335x-netcom-plus-2xx: add missing GPIO labels
Date: Tue, 16 Dec 2025 12:11:26 +0100
Message-ID: <20251216111325.236966136@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Yegor Yefremov <yegorslists@googlemail.com>

[ Upstream commit d0c4b1723c419a18cb434903c7754954ecb51d35 ]

Fixes: 8e9d75fd2ec2 ("ARM: dts: am335x-netcom: add GPIO names for NetCom Plus 2-port devices")

Signed-off-by: Yegor Yefremov <yegorslists@googlemail.com>
Link: https://lore.kernel.org/r/20251007103851.3765678-1-yegorslists@googlemail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts b/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts
index f66d57bb685ee..f0519ab301416 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-netcom-plus-2xx.dts
@@ -222,10 +222,10 @@ &gpio3 {
 		"ModeA1",
 		"ModeA2",
 		"ModeA3",
-		"NC",
-		"NC",
-		"NC",
-		"NC",
+		"ModeB0",
+		"ModeB1",
+		"ModeB2",
+		"ModeB3",
 		"NC",
 		"NC",
 		"NC",
-- 
2.51.0



