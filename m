Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4BE1C1AAA;
	Tue, 12 Aug 2025 19:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025507; cv=none; b=MqdvrF2VBlSKR8gz6HtUJDW8OMvwttizj2P1e4Xe5Q7lrbVq2NJgGl14/VrHN6DhPep+0FjEP0wx5wV2sn+52GTpEdhoN5YlGZ2e1b/azhj/Nu+DitktSqTfaxOqu0wnjL0G8azAqulnqVi0NOV1xayAvAj02sbWjXY1nToVpnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025507; c=relaxed/simple;
	bh=a/jnlTDVzwzzMJmjOo7iPl+tlgww/KAKVAgUEapvz7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2UbtVPzmoIG2mThii4KNZ0hXVnD2XQQdwvHdp6YXdnuyoBooerYN5xYWN0Jy9DZkq3WNK6A4gN5AJGKr62WXMh5E90K+KGhGWtXypnxepjN1pxlpm+X7uPTTQ7PZfc2w9R6o6MqpFJq+lkAe4ajWbxyfQmQIppp9BTNqfMBIjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HkfiR0T0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HkfiR0T0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1FFC4CEF0;
	Tue, 12 Aug 2025 19:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025506;
	bh=a/jnlTDVzwzzMJmjOo7iPl+tlgww/KAKVAgUEapvz7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HkfiR0T0Kufs5akbb0Qeh6Ye4VKrwvNyzCOoztqezWxLp3MMKodRLywTXyRbSmSrk
	 wOy5vQmUqVrRRxZByWTgTLN7xtcTubyoDcCua+9lVLQKMAGB6rQLjnxDjMKO6pb1iy
	 hDa1WG9ctjo+MuNHKXCg4Ti7zFC10fB3/+jxZ4mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 061/480] arm64: dts: rockchip: Enable eMMC HS200 mode on Radxa E20C
Date: Tue, 12 Aug 2025 19:44:29 +0200
Message-ID: <20250812174359.935142990@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 57a446b5cbd6..92bdb66169f2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3528-radxa-e20c.dts
@@ -140,6 +140,7 @@ &saradc {
 &sdhci {
 	bus-width = <8>;
 	cap-mmc-highspeed;
+	mmc-hs200-1_8v;
 	no-sd;
 	no-sdio;
 	non-removable;
-- 
2.39.5



