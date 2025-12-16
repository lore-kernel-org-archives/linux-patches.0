Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E4E346790;
	Tue, 16 Dec 2025 12:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887704; cv=none; b=fsOwIzYpFSDDNbrBbsnR48lR8+CwQqOsql3aaHN1iGXrUZj0rGyP1lBXQ1i6FZQHzT88bs60ORJF5rwXmJ05lhPvCqMAf1Q1Xys1C20ma1KjWAt6f4p5y38Op0qNz/MsoqDcKmx+4qygIUQ6addRQCpK7ha7Ng4SyjaDnbzgNA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887704; c=relaxed/simple;
	bh=3dyb/gjf9kcTVsg/+NKA9uUmFqfEAx0/1NsuCP5+8g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoSxeikK9Qr87jzYjekNnqnTqk5ADxrTA2AJR4ns8ZYYtngM+xrfx8DmmauTuEF20um+lZbC06N0qfSFN8Lo141tz0e6LYTWd588r9q+X5BCm8x3fETIlP+nRPTHwfDXOez6GbpQ3c+dBlW9Xf7yzbl3ZSONE4Cjo9hD3m7FOPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ksf9XyNn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ksf9XyNn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE45C4CEF1;
	Tue, 16 Dec 2025 12:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887704;
	bh=3dyb/gjf9kcTVsg/+NKA9uUmFqfEAx0/1NsuCP5+8g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksf9XyNnTj0jw8OJ1KXOveSC+pNXNXXI4lv3oSAQCpPew7bv4QgCy/FnhMz0eCHBY
	 CW1wXKqfLq5+0+bT5H7r/huZklNbbpNTUCX59mYm82cV/7LfakfFSjPKI5PE8cH6eS
	 qWJGXucnSPl/EXlgpLfD8+lfPVK3jZULVzdPe7Rg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUKAUMI Naoki <naoki@radxa.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 279/614] arm64: dts: rockchip: Add eeprom vcc-supply for Radxa ROCK 3C
Date: Tue, 16 Dec 2025 12:10:46 +0100
Message-ID: <20251216111411.483940233@linuxfoundation.org>
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



