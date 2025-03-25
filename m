Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0390A25D521;
	Tue, 25 Mar 2025 12:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906244; cv=none; b=OCObs/IaRCKf4lmAuLPr02EGcLXeWmVmFFHikhMuTnEaGFMU77K3mQL8uDrlvns+WCvQvkCB5Z8ZLqw2NWSihkVeiHgJ2t9Dvf8DPKMO4ZLnldaLcPhzUJD6+6Nogkvi/Ytnv3uRibZnlEr4kZ0hUSxGx/Uf1dSF7UwoEQmf7d4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906244; c=relaxed/simple;
	bh=bpQNZWNwKU0trb7YCpk5ctAthT93RxEcb8DNHjcfXxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KZH3mHhehayehINj+mL5gs7hEbANlSy6PejGANDibLSZqGnGKS7+nvPo4y1uz5lwFfFwJl+zlmGH8i06rRGqWIpgWB79H/HGhiAKzX7ROY1zBnROswHmHv/oFkQB7DKoaK0eHhfIGjos8W8B7oLXBhan8wiXXecqcZmEHO3VD8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvUTOVTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvUTOVTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4654AC4CEE4;
	Tue, 25 Mar 2025 12:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906243;
	bh=bpQNZWNwKU0trb7YCpk5ctAthT93RxEcb8DNHjcfXxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvUTOVTxyWUU0DTAhkuDN1nZC9i6bdK0m8oH0LDLbe8WUNTCoi+v8yyue8qS4Wnre
	 UpgUPspek7H5Q6HT1OfyIxiQaNmPGO04PgAnJqVCp9EO3P7VUvO/kgkBm7yKb6tOQr
	 PZXwQkoOaSRSqnxC/KfUqQlVwfbRXZUgkRJx//Ec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/116] arm64: dts: rockchip: Remove undocumented sdmmc property from lubancat-1
Date: Tue, 25 Mar 2025 08:21:41 -0400
Message-ID: <20250325122149.584246580@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yao Zi <ziyao@disroot.org>

[ Upstream commit 43c854c65e47d2f3763345683b06257b4d12e4e3 ]

Property "supports-sd" isn't documented anywhere and is unnecessary for
mainline driver to function. It seems a property used by downstream
kernel was brought into mainline.

This should be reported by dtbs_check, but mmc-controller-common.yaml
defaults additionalProperties to true thus allows it. Remove the
property to clean the devicetree up and avoid possible confusion.

Fixes: 8d94da58de53 ("arm64: dts: rockchip: Add EmbedFire LubanCat 1")
Signed-off-by: Yao Zi <ziyao@disroot.org>
Link: https://lore.kernel.org/r/20250228163117.47318-2-ziyao@disroot.org
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
index 9a2f59a351dee..48ccdd6b47118 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
@@ -512,7 +512,6 @@ &sdhci {
 
 &sdmmc0 {
 	max-frequency = <150000000>;
-	supports-sd;
 	bus-width = <4>;
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
-- 
2.39.5



