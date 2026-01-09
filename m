Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA4235B15C;
	Fri,  9 Jan 2026 12:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963097; cv=none; b=KvjUBtHe6AHIWYIQsYq3mNArKA7nSXup306VTXItPbYAzurRu8/G0EVBQ8zQFfs66EF0kxuIWC+d8oLbt4FqjJT3PIumbX1CrAnNM0zpaqD5HDVSC93MmGGhXFdz6PyBvdpxtkwm0aeN4XFbXHxwlh12Lo6pN6ZJ+E6Jf3c2M9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963097; c=relaxed/simple;
	bh=ITMhshk5OG+k0abGXk5AyBN8miMd4X9Hr09ggerARPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D9Dh6hYuijndSifKgzB6AiPtaKbrkwV+mSa2YC92o1itnC+GKb5EGN5h6SYQsVZgSSVolxv5xPyRH1bMw6elttnAUkvP+OwxEN4SLhV+hEtDkt4YH+OWgO226Wrqgqr1S6vU2k81Lo+7Sa/Qo2GZDM3lFc4gCOnzxlq/BgVPM+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZB5enH2j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZB5enH2j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5573AC19425;
	Fri,  9 Jan 2026 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963096;
	bh=ITMhshk5OG+k0abGXk5AyBN8miMd4X9Hr09ggerARPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZB5enH2jVJXfmS/0QL0kp3uJmVTFM7qajAbEgZfQXPq1OJRmOtrD2Atc2i4ksfVBJ
	 7+m8MNKBQdPq0irV3y6tgF3ayI0IZn2Vr2Gkj/4DVtRA4GoQ/o8LhPpUXTq7H8fj2A
	 /2WEVeNCs5Eyvp5Il8QJ0OjiC8C8Nv3Vc1nrVurs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 564/634] ARM: dts: microchip: sama7g5: fix uart fifo size to 32
Date: Fri,  9 Jan 2026 12:44:02 +0100
Message-ID: <20260109112138.824970779@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolas Ferre <nicolas.ferre@microchip.com>

[ Upstream commit 5654889a94b0de5ad6ceae3793e7f5e0b61b50b6 ]

On some flexcom nodes related to uart, the fifo sizes were wrong: fix
them to 32 data.

Fixes: 7540629e2fc7 ("ARM: dts: at91: add sama7g5 SoC DT and sama7g5-ek")
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20251114103313.20220-2-nicolas.ferre@microchip.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/sama7g5.dtsi |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm/boot/dts/sama7g5.dtsi
+++ b/arch/arm/boot/dts/sama7g5.dtsi
@@ -706,7 +706,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};
@@ -732,7 +732,7 @@
 				dma-names = "tx", "rx";
 				atmel,use-dma-rx;
 				atmel,use-dma-tx;
-				atmel,fifo-size = <16>;
+				atmel,fifo-size = <32>;
 				status = "disabled";
 			};
 		};


