Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A4E2765C8;
	Sun,  7 Sep 2025 20:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277482; cv=none; b=TbGWkWBrQ44BavkUYJEaFEkA6BWJYCKBoL+sdfA/6ZsM3JiyA8Asx1ammqKKOoOuRhrMw/eYC5PC0ZQzhcZcjP3zGwLkoX2uEnK2/9qB8YXmZaCnabEzeeqCYYFB4o73SfpdJS5MdXR68VFIRdFHQvmJxpxCq6wKkwGXL5+5yPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277482; c=relaxed/simple;
	bh=Y1TM7Ft+37fJUezX3v/6cER7wQUq9CprCFwAwp+gydo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMEXX8THzgs/cLJTR4lahC1p91D+sWfXdGzY3rWPALkBFueyenCRT5YwWOVPWHlvBPSGuEZTUpVEsvCnM49D0WDhqtZZvkTcux4iI6vPIvNao/X9QU2gRd/M80tNl5+baSvu0kjpLRMmHVLad5qURndxZwNsf8FlASQps+up2Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQeOYsR3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQeOYsR3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B277DC4CEF0;
	Sun,  7 Sep 2025 20:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277481;
	bh=Y1TM7Ft+37fJUezX3v/6cER7wQUq9CprCFwAwp+gydo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQeOYsR3QDq5G79D7pUF1iOoU4rm6f8VG02ZhvsHHzTrFCRWMNp6NwLS+7yu6zvDJ
	 6ns1SrJxd6Q7tLqFnsW4FddRCk9420cVi08fPfEywd+iGJrNZys/oiIl+cI7jQohCL
	 Yc+ZidD3XpnBaADxJ4PhFJF74Vah403bVBGY0OQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chukun Pan <amadeus@jmu.edu.cn>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 021/183] arm64: dts: rockchip: mark eeprom as read-only for Radxa E52C
Date: Sun,  7 Sep 2025 21:57:28 +0200
Message-ID: <20250907195616.286378139@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chukun Pan <amadeus@jmu.edu.cn>

[ Upstream commit f18c9e79bbe65627805fff6aac3ea96b6b55b53d ]

The eeprom on the Radxa E52C SBC contains manufacturer data
such as the mac address, so it should be marked as read-only.

Fixes: 9be4171219b6 ("arm64: dts: rockchip: Add Radxa E52C")
Signed-off-by: Chukun Pan <amadeus@jmu.edu.cn>
Link: https://lore.kernel.org/r/20250810100020.445053-2-amadeus@jmu.edu.cn
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3582-radxa-e52c.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3582-radxa-e52c.dts b/arch/arm64/boot/dts/rockchip/rk3582-radxa-e52c.dts
index e04f21d8c831e..431ff77d45180 100644
--- a/arch/arm64/boot/dts/rockchip/rk3582-radxa-e52c.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3582-radxa-e52c.dts
@@ -250,6 +250,7 @@ eeprom@50 {
 		compatible = "belling,bl24c16a", "atmel,24c16";
 		reg = <0x50>;
 		pagesize = <16>;
+		read-only;
 		vcc-supply = <&vcc_3v3_pmu>;
 	};
 };
-- 
2.50.1



