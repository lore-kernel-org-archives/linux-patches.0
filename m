Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ECEF25BAAD;
	Tue, 25 Mar 2025 12:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906146; cv=none; b=bmpLk78gydgxwyey343wUkLfN82FMCDgqVzbqve1TWk0P5uqjh9Gxvfl/89k3VsXQGprBDEnDRx458xgOtQBaI+5ny9R28stJKtUmvb/6T5HQwWGyXZ8UKG93PItHlbbRn7EPH0/vxsFOofYel5+IJkkYA6mg+pcCceoBVg0QRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906146; c=relaxed/simple;
	bh=1phvZtGy7xjP21mNhPzJlLIF1FLgEhiGfIjQelreaEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5nm95C7SI9ZxiqCRUDqyTXiTTaDj3f9Xhj0TCNVZDHF5c7mgshJ87MTlLx0GUrn89vEkI3ufsQ4ID1mEzs5SnvlwctomgNt39cR3fu9XN6TIavjykp+cFk/XmS8DXNHPQ1vJWvCMImDesY4PHJeMiMCK4vcOmpy3Om22mBDOwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ohbK2B04; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ohbK2B04"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E47B7C4CEE4;
	Tue, 25 Mar 2025 12:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906146;
	bh=1phvZtGy7xjP21mNhPzJlLIF1FLgEhiGfIjQelreaEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ohbK2B04wJm8HUS6UrTGJH2qbfqPea15XpARmSjsF004En97iCIpIPVGwyXWvOTS9
	 PI/wehe+F8NSXXrInf4Ct3fjtA/yORm2jEqWt8bm2H5amXc3SAVGOUBPeV9CCtWW7u
	 Q/Lfvy8DgP2iJHoWiR1Zwj2mWJMqr98vJmtQQM30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yao Zi <ziyao@disroot.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 09/77] arm64: dts: rockchip: Remove undocumented sdmmc property from lubancat-1
Date: Tue, 25 Mar 2025 08:22:04 -0400
Message-ID: <20250325122144.562786354@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c1e611c040a2c..df68a59694fb2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3566-lubancat-1.dts
@@ -513,7 +513,6 @@ &sdhci {
 
 &sdmmc0 {
 	max-frequency = <150000000>;
-	supports-sd;
 	bus-width = <4>;
 	cap-mmc-highspeed;
 	cap-sd-highspeed;
-- 
2.39.5



