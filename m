Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5BC12D214;
	Tue, 30 Apr 2024 11:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476400; cv=none; b=QQ4aVYcMx3WQc2Ly4BmPNa2hrAKL+h0eE5iS5VWj1Zrw2w7U1s/5d5k4wTfvcsgMp4KbSe6jrP2kZ2NaijdLgHwL5hdOUI2yV/z8r7EpVS74LBOAIB2jMr+WAq5D6H1RUnevBi15zcWCSc0CGPEu3EBv0PH9l4/BaD11MGUE+zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476400; c=relaxed/simple;
	bh=fnv2EZLOzolKi6nvWfI0dZCb+IRdZYfwLQiMU9DsUio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXDXMK3kfknAY4UUnj1xNPyddDYYooALXFI/Sy1Su3c5Azq6VwwlDtiDuc5Jt+o6+4jp6b2JXDNk2kQwKFyjKKO4eJEy/Yec6N5H7rbWSejOqbCXWc5OWEmpxR33D4DwSH1U4Tm95oQnf+AfSH1cKTQmdmADt1Xu9DSlqHP+nlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ai9dElZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ai9dElZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F75DC2BBFC;
	Tue, 30 Apr 2024 11:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476399;
	bh=fnv2EZLOzolKi6nvWfI0dZCb+IRdZYfwLQiMU9DsUio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ai9dElZH9xBHcErlfNGr/Yux9kshaMtlEszYjTyHQnVCofyyYTaQrtZ0XI685vT5h
	 R/eUG4YtNk0tmpZC2A9KF+Bf/Uu2hPvDXwgJ1HBpMdgFpOGQicVvgJy1c6cFuubaIw
	 WfDydwDSRUqgAFPnX8Luk7kcLF72Xpid7y9ogo+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/110] arm64: dts: rockchip: regulator for sd needs to be always on for BPI-R2Pro
Date: Tue, 30 Apr 2024 12:39:50 +0200
Message-ID: <20240430103048.196694452@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit 433d54818f64a2fe0562f8c04c7a81f562368515 ]

With default dts configuration for BPI-R2Pro, the regulator for sd card is
powered off when reboot is commanded, and the only solution to detect the
sd card again, and therefore, allow rebooting from there, is to do a
hardware reset.

Configure the regulator for sd to be always on for BPI-R2Pro in order to
avoid this issue.

Fixes: f901aaadaa2a ("arm64: dts: rockchip: Add Bananapi R2 Pro")
Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Link: https://lore.kernel.org/r/20240305143222.189413-1-jtornosm@redhat.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
index 7952a14314360..856fe4b66a0b9 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-bpi-r2-pro.dts
@@ -412,6 +412,8 @@
 
 			vccio_sd: LDO_REG5 {
 				regulator-name = "vccio_sd";
+				regulator-always-on;
+				regulator-boot-on;
 				regulator-min-microvolt = <1800000>;
 				regulator-max-microvolt = <3300000>;
 
-- 
2.43.0



