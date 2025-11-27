Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4FF9322DCB;
	Thu, 27 Nov 2025 14:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255152; cv=none; b=kQCbuMwVq/AZMINC06r1g4wD2wNRok1ISr5koFIxSJZ44QBRl2PN849Eu0d4hjedQQTQxl+EukU5JZMLaHss7GPLJyHmFO1IorSPc2jGTwrPgmCcSopelBX2yyCVf25oAyuvaB1zeo3qDenDKuZPiXpjxIWenul3tHQyFN/tDs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255152; c=relaxed/simple;
	bh=vk6mSw50bEZXnJKWPJu8TQWM/lxO0nCZcadBgouPu2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jt8czzziIfEGC6r7rdiYsOLCRS3hhNnT6WOxvOvBuHswrCbKbi6/4yQBBf++3V7heKVEG02wxGcqeMNQV5p5W5Q/sxqPEJ0hTlMlO0Vc60BGtRpZU2cG0d9tEylk0TKnmRU420uDIjm+yzlqNMSG9R7uBvM+yZVaBUvnSvoptZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=19CNFH3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="19CNFH3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA683C4CEF8;
	Thu, 27 Nov 2025 14:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255152;
	bh=vk6mSw50bEZXnJKWPJu8TQWM/lxO0nCZcadBgouPu2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=19CNFH3CsVU7omZzLVuLyPcGpd6vSeEBTKN0QNOACPqoMccAJ7WcdLXziSEK8467O
	 6ah52+5Oa8wgpuD3kZHc5F/BxMSwf67FGE/XcHt6W5Gb6ZteWsNLKHKN4lz773/N99
	 4eHwjiMrRjLIoiZhM7bwQxjOUc6eGUTGItycVLO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Diederik de Haas <diederik@cknow-tech.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.12 005/112] arm64: dts: rockchip: Fix vccio4-supply on rk3566-pinetab2
Date: Thu, 27 Nov 2025 15:45:07 +0100
Message-ID: <20251127144032.910174745@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144032.705323598@linuxfoundation.org>
References: <20251127144032.705323598@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diederik de Haas <diederik@cknow-tech.com>

commit 03c7e964a02e388ee168c804add7404eda23908c upstream.

Page 13 of the PineTab2 v2 schematic dd 20230417 shows VCCIO4's power
source is VCCIO_WL. Page 19 shows that VCCIO_WL is connected to
VCCA1V8_PMU, so fix the PineTab2 dtsi to reflect that.

Fixes: 1b7e19448f8f ("arm64: dts: rockchip: Add devicetree for Pine64 PineTab2")
Cc: stable@vger.kernel.org
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Diederik de Haas <diederik@cknow-tech.com>
Link: https://patch.msgid.link/20251027155724.138096-1-diederik@cknow-tech.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/rockchip/rk3566-pinetab2.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/rockchip/rk3566-pinetab2.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3566-pinetab2.dtsi
@@ -789,7 +789,7 @@
 	vccio1-supply = <&vccio_acodec>;
 	vccio2-supply = <&vcc_1v8>;
 	vccio3-supply = <&vccio_sd>;
-	vccio4-supply = <&vcc_1v8>;
+	vccio4-supply = <&vcca1v8_pmu>;
 	vccio5-supply = <&vcc_1v8>;
 	vccio6-supply = <&vcc1v8_dvp>;
 	vccio7-supply = <&vcc_3v3>;


