Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA4DA1BA866;
	Tue, 30 Jul 2024 15:57:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355054; cv=none; b=aQNGwWUlLb654sXZugo0WdOb1hPCCN6fg0gQocuGLd0UDU9OocNeHeSBM3DpcvPEjBNQmtHc4PJTv91g5JtCd5i4VIX73/mmu0aAsxdbPSiuQ7w2VMmbRZLny/yEDVrdNbllomx3L3l8cBy3ieQs+Pt7Gz8/0Vh7VIXKL4LUsxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355054; c=relaxed/simple;
	bh=Rjxyerh2vMce9RsaffOLfMQ7UyKXmnW3UiDPdjju+bs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jouajNFN7NTVWRY3i/OOwueKDTFiKW8jcGmT/SvcVA7opKiW4wXui7iVMG9rJWt4eCmiITbtEMuTk460h2iy6NHS2sPzOdpR2ggQeZDreuozD4LcatiWnAL8llA9vKAAbERgRI/ddiWOKyWKIAz8H2NVAIh1CT4WnrRZWcxEhUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myDEkZYU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myDEkZYU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EB6C4AF0C;
	Tue, 30 Jul 2024 15:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355054;
	bh=Rjxyerh2vMce9RsaffOLfMQ7UyKXmnW3UiDPdjju+bs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myDEkZYUKEqBZC2Lc1vgnpvE1bLxDnUbNTRrI0/RGmzh5Yd7J6XzcRHgirqwv6Zwb
	 X/DMnM9qUnNkpM2+NEwfiPrRhpPDSVJdk9yMWdJILCrcTXrlL+Dqb7kWnqYvUknCp7
	 XAhyKUnenrjAhYY0NiQp40zlUEuwXbnClgFgvTcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/440] ARM: dts: imx6qdl-kontron-samx6i: fix board reset
Date: Tue, 30 Jul 2024 17:44:47 +0200
Message-ID: <20240730151617.879736352@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit b972d6b3b46345023aee56a95df8e2c137aa4ee4 ]

On i.MX6 the board is reset by the watchdog. But in turn to do a
complete board reset, we have to assert the WDOG_B output which is
routed also to the CPLD which then do a complete power-cycle of the
board.

Fixes: 2125212785c9 ("ARM: dts: imx6qdl-kontron-samx6i: add Kontron SMARC SoM Support")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
index d6c049b9a9c69..700780bf64f58 100644
--- a/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-kontron-samx6i.dtsi
@@ -817,5 +817,6 @@ &wdog1 {
 	/* CPLD is feeded by watchdog (hardwired) */
 	pinctrl-names = "default";
 	pinctrl-0 = <&pinctrl_wdog1>;
+	fsl,ext-reset-output;
 	status = "okay";
 };
-- 
2.43.0



