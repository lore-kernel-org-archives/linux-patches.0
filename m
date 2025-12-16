Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BA5368291;
	Tue, 16 Dec 2025 12:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887378; cv=none; b=E2zHMcGLeYU8pOYfobei1RlKueqMugbcYfMLj6JpzyDa8O7r4/Mx6JyDszXZz/blya8vYChtV6DqHHA99R1NvM84OGPaI7yt4LPNnIRLb73ILO11GL4gYDrrw3kN8Ef8KWjf+qXegO2Qbl2r6tBh8VQzIxjBC9RSue5X4mLFXHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887378; c=relaxed/simple;
	bh=Z8hZupS7JlbXHqJl5q/g9KkRKnuhY4q5PbLo9Gd8F1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BJ82FH5jzpRNwhkvdjJWJZtHYrhkBYozkcE93QuZ0k6+Y5B+abWrsq7fdvyce38S24aL95dF5Z05Pc8HinqrsQoBxFY06I0ZjLS6lVacBnmg6eOa+kwJX9s45yjV7xR8aq8RoIxQRQOQOeH7DTqv2ng0HNHcuzMOXE2AOeYn9Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3wdOkMh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3wdOkMh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79B47C4CEF1;
	Tue, 16 Dec 2025 12:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887377;
	bh=Z8hZupS7JlbXHqJl5q/g9KkRKnuhY4q5PbLo9Gd8F1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3wdOkMhuqs02PoxVIhhrh/+tllXQ/Xwl/FiY52b9ur96WFSoqL3EjboeuJrexbwt
	 rstFvmFfulZFwwe6YL7UkuZwg0Q2mslftdE2qZd03ICyt5lSsAU274zvRaTYl1uLIN
	 wxH1wghA4BvveY2ATs2WWNdYPM3SsywdL9iOhzgg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yegor Yefremov <yegorslists@googlemail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 204/614] ARM: dts: am335x-netcom-plus-2xx: add missing GPIO labels
Date: Tue, 16 Dec 2025 12:09:31 +0100
Message-ID: <20251216111408.769185006@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



