Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010711BD031;
	Tue, 12 Nov 2024 10:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407945; cv=none; b=KwdtwLnxzdga1R4YxKxq5FIQD0697nLmJUBTQK0iFPnZXvgVS+pUxfjFKdLnKMOIb6DPQzK/qFuEdxX2FzMLpTa/BMsP2MFH0zs3VSyssvI0cdY3CpOHbB2HyRN03XDEEbzDC62HZWYLMyYfgNXI8dtP5/S78mRDLRjNaU8Dz+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407945; c=relaxed/simple;
	bh=A9PC9nTjifNoDmy6ZIEQuAl5mtGhezq+W/IRswa/KqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6aLw+75sxRXC//76W4E4WDcq8bCu4c63c8QKDFlW1GqFaB/+L86ziIu9Yz2KjR8ZoAOmFa4u9hNmeLhyUDQh427AECbtnw11vZ3jGjRjdcf0m01f6mNtdhJE3nzwACQfvEi7OlZl72Iommlek+grkBOAMIAP8bIotosu3iza88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdhZExGr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdhZExGr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667E8C4CED8;
	Tue, 12 Nov 2024 10:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407944;
	bh=A9PC9nTjifNoDmy6ZIEQuAl5mtGhezq+W/IRswa/KqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdhZExGr/HKa8FoZCWxRZh3Z8z1f3ovamgmVYjHUflM55yBZBmLv3MMSgJmtTMyIY
	 UiB/rVwpvZ0zsJlhj+afFYgDNvgJRIovYlwaudOAGa8+1D8rRG2HZgVezOJV08Ol90
	 edszCH06D/ugLyvcpv4ZTT58jPA8lYqxhqLHOkNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Furkan Kardame <f.kardame@manjaro.org>,
	Elon Zhang <zhangzj@rock-chips.com>,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 012/184] arm64: dts: rockchip: Drop regulator-init-microvolt from two boards
Date: Tue, 12 Nov 2024 11:19:30 +0100
Message-ID: <20241112101901.343575412@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

[ Upstream commit 98c3f4a2d61a29a53244ce45e50655140bd47afb ]

rk3568-roc-pc and rk3588-toybrick-x0 re-introduced this property despite
previous patches removing older instances already.

regulator-init-microvolt is not part of any regulator binding and is
only used in the Rockchip vendor kernel. So drop it.

It is used by u-boot in some places to setup initial regulator-state,
but that should happen in the existing -u-boot devicetree additions.

Fixes: 007b4bb47f44 ("arm64: dts: rockchip: add dts for Firefly Station P2 aka rk3568-roc-pc")
Cc: Furkan Kardame <f.kardame@manjaro.org>
Fixes: 8ffe365f8dc7 ("arm64: dts: rockchip: Add devicetree support for TB-RK3588X board")
Cc: Elon Zhang <zhangzj@rock-chips.com>
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-3-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dts      | 3 ---
 arch/arm64/boot/dts/rockchip/rk3588-toybrick-x0.dts | 1 -
 2 files changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dts b/arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dts
index e333449ead045..2fa89a0eeafcd 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-roc-pc.dts
@@ -272,7 +272,6 @@
 				regulator-name = "vdd_logic";
 				regulator-always-on;
 				regulator-boot-on;
-				regulator-init-microvolt = <900000>;
 				regulator-initial-mode = <0x2>;
 				regulator-min-microvolt = <500000>;
 				regulator-max-microvolt = <1350000>;
@@ -285,7 +284,6 @@
 
 			vdd_gpu: DCDC_REG2 {
 				regulator-name = "vdd_gpu";
-				regulator-init-microvolt = <900000>;
 				regulator-initial-mode = <0x2>;
 				regulator-min-microvolt = <500000>;
 				regulator-max-microvolt = <1350000>;
@@ -309,7 +307,6 @@
 
 			vdd_npu: DCDC_REG4 {
 				regulator-name = "vdd_npu";
-				regulator-init-microvolt = <900000>;
 				regulator-initial-mode = <0x2>;
 				regulator-min-microvolt = <500000>;
 				regulator-max-microvolt = <1350000>;
diff --git a/arch/arm64/boot/dts/rockchip/rk3588-toybrick-x0.dts b/arch/arm64/boot/dts/rockchip/rk3588-toybrick-x0.dts
index d0021524e7f95..328dcb894ccb2 100644
--- a/arch/arm64/boot/dts/rockchip/rk3588-toybrick-x0.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3588-toybrick-x0.dts
@@ -428,7 +428,6 @@
 				regulator-boot-on;
 				regulator-min-microvolt = <550000>;
 				regulator-max-microvolt = <950000>;
-				regulator-init-microvolt = <750000>;
 				regulator-ramp-delay = <12500>;
 
 				regulator-state-mem {
-- 
2.43.0



