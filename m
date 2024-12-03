Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7D61F9EC0;
	Tue,  3 Dec 2024 15:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240555; cv=none; b=nhShDTMpO7PsacVUH4ZqrkMTRoS+omdzXe52thZLN+tKxz/tKqS+nhO9df7NyNDmbR7ObFRXjBxjALWs5EyYWhq0S0Ajc8bpVcqyiJcWaEo4SUPyqmddwcNpOdhCbzGG8d5CKfyEafTn6SdWmarEH2nK84wkgx2JENU+jhYS5YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240555; c=relaxed/simple;
	bh=jALyPhGBf1evH2hk7wHB1nJfxUGOoGDXviABKEdt0kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKSTSBopMkuVfk2CvoRvppzqqYddfYLwoVWA5Xm/KFEw/sG220f/U6BgqUj96veuNpgFragYhiK2sceB+vG4/5EHqX2AvId2L551bUqIIrOMqVS2MquxKno88eVdiBFT7+L3GRW7ELKy20KAMHCiYkAeQ+Bg4DS5J166zBJtzZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTiVSA19; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTiVSA19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB661C4CECF;
	Tue,  3 Dec 2024 15:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240555;
	bh=jALyPhGBf1evH2hk7wHB1nJfxUGOoGDXviABKEdt0kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTiVSA1992ecjK5e/3/2TF39WcwMFdyTOfVn/vuv6s9I8MBoYNfHgF37F8hTVhYJ+
	 wzFEs9GnB4sdS2kOU97CkOgw28EmBcMunXlWVbPGF6GMoSF+mGprBYJMR+ycVKRw30
	 xBDHQky2a5iS8znTbx+l+ztcG34e7f9CtVEHP++A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Tomasz Maciej Nowak <tmn505@gmail.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/826] arm64: tegra: p2180: Add mandatory compatible for WiFi node
Date: Tue,  3 Dec 2024 15:37:46 +0100
Message-ID: <20241203144749.164322702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomasz Maciej Nowak <tmn505@gmail.com>

[ Upstream commit 2e57d3dc7bff60b9fb05eaaf4ebad87cd3651068 ]

The dtschema requires to specify common ancestor which all SDIO chips are
derived from, so add accordingly.

Fixes: a50d5dcd2815 ("arm64: tegra: Wire up WiFi on Jetson TX1 module")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202409030438.8tumAnp1-lkp@intel.com
Signed-off-by: Tomasz Maciej Nowak <tmn505@gmail.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
index c00db75e39105..1c53ccc5e3cbf 100644
--- a/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra210-p2180.dtsi
@@ -351,7 +351,7 @@ mmc@700b0200 {
 		#size-cells = <0>;
 
 		wifi@1 {
-			compatible = "brcm,bcm4354-fmac";
+			compatible = "brcm,bcm4354-fmac", "brcm,bcm4329-fmac";
 			reg = <1>;
 			interrupt-parent = <&gpio>;
 			interrupts = <TEGRA_GPIO(H, 2) IRQ_TYPE_LEVEL_HIGH>;
-- 
2.43.0



