Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B760318734F;
	Fri, 15 Nov 2024 06:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652969; cv=none; b=ElWs/ygdC5I0URHMGSjhbJTc5SsnkDuLFyiWn5KyMntXtwai11Zex+a7hWU8DuL6SSTQOjOuAkPd7ME9fMtZKMmAlPxe5EHBkyOrkXR/SpBWOIfS6gD8Rio1RJrzK0OCAWX2ZylyutpWbxZ/0NT7yljq1TboCtviDMRpqIaLW4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652969; c=relaxed/simple;
	bh=s6kvVdLLZu5obgnBPKvIMmVE9FLm3lcWz7o1E3PVfy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQ8j2bjCxDjhWck1RNZdEfELyw+LWQ+7+VN7r/3joiiJfqCyfxR06YRuBdlrQmC/NuPnlNKFeQaAu2QsTeyT19KqP5RkfL4B+TIJdiD8ZjlHRv28XL+HxS+PaAYSulC/aAXLaP0VpQtAQH0H/vUWBSIYM2sASm5gJ9/d8BNejzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NYrB1MSK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NYrB1MSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26839C4CECF;
	Fri, 15 Nov 2024 06:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652969;
	bh=s6kvVdLLZu5obgnBPKvIMmVE9FLm3lcWz7o1E3PVfy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NYrB1MSKq0yZVwrUyJD6nDWFXcAInlk/V+HsXDdPDpnYhBeKnXnuzSuNCBQkk+l+D
	 pq+nyW4av+YEJaTFG2ugmd49dDoGjMoBM0XUWCh7edDM7bMY7See7kWpQ/q3cmEG11
	 O5b343tk6PPvL79V1Qc7I2JgeMhrjlUYPJ46xXjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caesar Wang <wxt@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 08/66] ARM: dts: rockchip: Fix the realtek audio codec on rk3036-kylin
Date: Fri, 15 Nov 2024 07:37:17 +0100
Message-ID: <20241115063723.142246348@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 77a9a7f2d3b94d29d13d71b851114d593a2147cf ]

Both the node name as well as the compatible were not named
according to the binding expectations, fix that.

Fixes: 47bf3a5c9e2a ("ARM: dts: rockchip: add the sound setup for rk3036-kylin board")
Cc: Caesar Wang <wxt@rock-chips.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-15-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rk3036-kylin.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036-kylin.dts b/arch/arm/boot/dts/rk3036-kylin.dts
index 2ef47ebeb0cbe..e5bee30b35581 100644
--- a/arch/arm/boot/dts/rk3036-kylin.dts
+++ b/arch/arm/boot/dts/rk3036-kylin.dts
@@ -300,8 +300,8 @@
 &i2c2 {
 	status = "okay";
 
-	rt5616: rt5616@1b {
-		compatible = "rt5616";
+	rt5616: audio-codec@1b {
+		compatible = "realtek,rt5616";
 		reg = <0x1b>;
 		clocks = <&cru SCLK_I2S_OUT>;
 		clock-names = "mclk";
-- 
2.43.0



