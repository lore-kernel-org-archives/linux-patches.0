Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A455352926;
	Tue, 16 Dec 2025 11:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885760; cv=none; b=bwRrQt604ckA+7jv1MI0SHyHbjt05aRO0jUyNBYYV9iTQ2MUno5kbB+Sh09D/OY4pC+IvRqNLQzlyH7C2f+boAbFpZZ35lgP7w1FwbJbZ1D5IgB2WXne/TrWZbQvgtVNrajhoBDHvZVyiDA2LSyEVrTWquFcPeUaNHzOwdqoX/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885760; c=relaxed/simple;
	bh=bZuCIEpTWTDL53zxA1UNHsAah/Us6nUybDJGzuZ0R+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ReiA7aqwdofg7y5CYfhQoqbSx7gJc63MUmMjHFCkigTZNEZgmnLDPah0J8LGabkYnLW+07TZyyKudlnd1i2sOoj3OLh9Q8RhZwY1O/kEbEbYMjavqJIPtunQMrRD3IWsj9nDVx2vPegKgpA8n8Da6N/mo+4QYFtvrEJ6bG3GxYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sK7wWt2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sK7wWt2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF329C4CEF1;
	Tue, 16 Dec 2025 11:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885760;
	bh=bZuCIEpTWTDL53zxA1UNHsAah/Us6nUybDJGzuZ0R+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sK7wWt2KuhVPU4musdIW5tEArHgZWb1wF1bnSsqL028qNTARnnejDZjyuTU80bE7Q
	 4BSo3yLiel+e8+GrPNuJqSlb4qAhxLqTg+0re9ElDMitGdM9WsAIUQujY5wXSmKy+z
	 tRVItq7ByeBMvKoWexLREOeicKw1XWtfenbQUGIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 235/507] arm64: dts: rockchip: Add eeprom vcc-supply for Radxa ROCK 3C
Date: Tue, 16 Dec 2025 12:11:16 +0100
Message-ID: <20251216111354.014789541@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUKAUMI Naoki <naoki@radxa.com>

[ Upstream commit 260316d35cf8f8606c5ed7a349cc92e1e71d8150 ]

The VCC supply for the BL24C16 EEPROM chip found on Radxa ROCK 3C is
vcca1v8_pmu. [1] Describe this supply.

[1] https://dl.radxa.com/rock3/docs/hw/3c/v1400/radxa_rock_3c_v1400_schematic.pdf p.13

Fixes: ee219017ddb50 ("arm64: dts: rockchip: Add Radxa ROCK 3C")
Signed-off-by: FUKAUMI Naoki <naoki@radxa.com>
Link: https://patch.msgid.link/20251112035133.28753-4-naoki@radxa.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts b/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
index 6224d72813e59..80ac40555e023 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-rock-3c.dts
@@ -466,6 +466,7 @@ eeprom: eeprom@50 {
 		compatible = "belling,bl24c16a", "atmel,24c16";
 		reg = <0x50>;
 		pagesize = <16>;
+		vcc-supply = <&vcca1v8_pmu>;
 	};
 };
 
-- 
2.51.0



