Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E46F332BF40;
	Thu, 27 Nov 2025 14:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255538; cv=none; b=tcpB7cGKIDJrHLO5O+wVhVfYkBFGrlYI0c409Z3Zwsq2eV4+bcpasv1nnrWbWb3nHAZ9h9F0pLt1dhqygSP8u3P1VANssP+QuZQadD+df1RchS60iYoPTcLCftzJ2qV+BwZZh+8JabH3SgYzDXGtMufSJnwNXU4yOFZ/L8o/Grg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255538; c=relaxed/simple;
	bh=W6k4LykrJhDrDX6qeDbD052R7bD34YNUtMy169BOBkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b04OXOEh5PFi6AlkbxCkPriyFOklftFeMSoVUqMtmx4Skh+4tj6HCDHiSRbg+5Wkwd/dTnzrviXrmiOEQcC16Nb08D0N4Ra9xTEXH6Di9JOjB5thC3ZWsH125Qgyaobt3qBCC0O21zH55Am1whpbMwHEzNWeL+3NEmcNXu0QbiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCnvKp3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCnvKp3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F1A7C4CEF8;
	Thu, 27 Nov 2025 14:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255537;
	bh=W6k4LykrJhDrDX6qeDbD052R7bD34YNUtMy169BOBkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCnvKp3XLvJAr4CBGAPFmU2frn5PYGx//j6Qv1WmljbwL2KwChBJn/kCSbKgiVHRF
	 2dpnZCYiXOzGY504y/lDR4cDDjBWeHUIWji5eQ5KlHsDFCHnccUf03SuuiaBw0Y8KD
	 HDVqtUfE4WK0UuTAV7gssJ9JwC1c9cnM/LC3R1BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Diederik de Haas <diederik@cknow-tech.com>,
	Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.17 006/175] arm64: dts: rockchip: Fix vccio4-supply on rk3566-pinetab2
Date: Thu, 27 Nov 2025 15:44:19 +0100
Message-ID: <20251127144043.187270746@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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


