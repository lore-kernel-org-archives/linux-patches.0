Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836B435502B;
	Tue, 16 Dec 2025 11:50:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885827; cv=none; b=nqxnQC6XhaDlGUdP7GmhmtPqC6kDzDGgf86ZadH+K75LmSywlF9Euqupeb5BeSnLiJ4aEibRvJgkqLaFdSKIrfOBNDrWIF7W12nC6Zndv0EZAmngtD+Iyxy1sKy3jZKe/+BA35H1ShDVWcVB9UB8Tip4N+sdhxzjtf0/AmvyBQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885827; c=relaxed/simple;
	bh=Xm7kZzjPA+glyvNa3Zyc2Gb2U1wWbaFadfCHYE8auL8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qdlS5ilqlMq8GLk6a5fVlqUKpY57QRGapQopov1W5+TT0ZFGMDQcJkkyv509QmDX0Ku3bm2kAfF9thdYgcVYLkvAuRbX4jOoNpQjhEVR815xgBGSzCqLXveSvaFXyigAzAbNBYLIqU6ajD+L8LoCw6B2DQF/96LEPThjaw2kWos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yq2edxsX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yq2edxsX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F12C4CEF1;
	Tue, 16 Dec 2025 11:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885827;
	bh=Xm7kZzjPA+glyvNa3Zyc2Gb2U1wWbaFadfCHYE8auL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yq2edxsXggsut4FP1adiUK+ywPttatY7XWghUGt8WiFgBCI1dhGxchd64zmNdW7k8
	 Vy42qW1VwLyi8SSFdCUU72EVCVJjsE6+cCPRJO3kIG6jKtdso0R3mUGPsw2F5pEUDY
	 HDJSuuVEvf/HOGcVNgX0jdLn69sCWf53ayVddn3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 257/507] arm64: dts: imx95-tqma9596sa: reduce maximum FlexSPI frequency to 66MHz
Date: Tue, 16 Dec 2025 12:11:38 +0100
Message-ID: <20251216111354.800774288@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 461be3802562b2d41250b40868310579a32f32c1 ]

66 MHz is the maximum FlexPI clock frequency in normal/overdrive mode
when RXCLKSRC = 0 (Default)

Fixes: 91d1ff322c47 ("arm64: dt: imx95: Add TQMa95xxSA")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi b/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi
index c3bb61ea67961..16c40d11d3b5d 100644
--- a/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx95-tqma9596sa.dtsi
@@ -115,7 +115,7 @@ &flexspi1 {
 	flash0: flash@0 {
 		compatible = "jedec,spi-nor";
 		reg = <0>;
-		spi-max-frequency = <80000000>;
+		spi-max-frequency = <66000000>;
 		spi-tx-bus-width = <4>;
 		spi-rx-bus-width = <4>;
 		vcc-supply = <&reg_1v8>;
-- 
2.51.0



