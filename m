Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E863526529E;
	Tue, 12 Aug 2025 18:30:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023427; cv=none; b=e5ffxE14oqTBYr0uyStJTP1CEulGXxw+LQ9obNTzfoJeD6SqDgSsAh7yDTGTjLCUjhp9OA3J21U0K0yzS4tou8EymraSM53wJqWT46qngNCAlHGrqLZDP8cxjPAwVHWoptMLEx+SHXahpMrH4lLfwaon9irdVzRitrXgikkTi54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023427; c=relaxed/simple;
	bh=BTDhVnsy0D5bSdenz8sXfz0dfWIQrjbR7ExuDVGr4WM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZzl2v3ZY8B6LLKg9jFuvXR5YXCLScSwdxUAKlPNKQtjR55Zf1FSb0vqQ/TQQXn03bxXyDkhu9S+PGZUoB2wIfeVzfLB+afeD51xz7lFJh6X7p9iCqAtjx54Jj4A1zZDqgXgrSlw7caYd2dPBv3A7nfZK/tdiJ80SLedbp1JWRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9TLgbMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9TLgbMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DEEC4CEF6;
	Tue, 12 Aug 2025 18:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023426;
	bh=BTDhVnsy0D5bSdenz8sXfz0dfWIQrjbR7ExuDVGr4WM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h9TLgbMscvy4CJli31hkgiA7ly8IOVdfc1JLWMUd3KByYtQwDirEo/V6z4L0EsbHe
	 bLt1artmSS3htSbkB7retd9BfQ1yH0ZoqSNmMD8pYfIVzuB+NBvHFdLTHh8d7S1RPQ
	 yotz3tdliXhaV5jO6XC5Xc0lT9a8EmdthMgokF94=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 077/627] arm64: dts: rockchip: Enable eMMC HS200 mode on Radxa E20C
Date: Tue, 12 Aug 2025 19:26:12 +0200
Message-ID: <20250812173422.240915158@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit 6e3071f4e03997ca0e4388ca61aa06df2802dcd1 ]

eMMC HS200 mode (1.8V I/O) is supported by the MMC host controller on
RK3528 and works with the optional on-board eMMC module on Radxa E20C.

Be explicit about HS200 support in the device tree for Radxa E20C.

Fixes: 3a01b5f14a8a ("arm64: dts: rockchip: Enable onboard eMMC on Radxa E20C")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Link: https://lore.kernel.org/r/20250621165832.2226160-1-jonas@kwiboo.se
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dts | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dts b/arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dts
index 9f6ccd9dd1f7..ea722be2acd3 100644
--- a/arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dts
@@ -278,6 +278,7 @@ &saradc {
 &sdhci {
 	bus-width = <8>;
 	cap-mmc-highspeed;
+	mmc-hs200-1_8v;
 	no-sd;
 	no-sdio;
 	non-removable;
-- 
2.39.5



