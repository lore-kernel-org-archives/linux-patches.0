Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60BA30FF30;
	Mon, 13 Oct 2025 15:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368995; cv=none; b=rf8aLHY/wF4/yzFy+lyv0ygoYYWBV7MUPsLVXJbqUmTXI80/cm7nTcVPIYfXamgTWVCjoYvzAsnRCFC/cewMLCocye3JSeI/u5DUrHkOAi69GA0vLOP3qm20ox0j5221bnUmMb8r2tt3d5UxOTynacFjlcCvm332xXQdtsWwjTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368995; c=relaxed/simple;
	bh=pPOPGvUKMGz44dYGFNQ8RH42dV2zL5ooMSuTprjkcoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BgxEjHZG/pYEp67E5P72LambfRm795tUbibNkSpbwROyWbK1FtWVtc9mmvOLg2xXd3OrY4PMEmdzYzsyiwbGIX2uXx66EFPV52If4bKvYGcqGKasc8HINWMji9hlIlfjuHKv7lmDHbrBEl2E/LD/ILO4JylQ2u+0F64xUnE2vgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BGAGyAjZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BGAGyAjZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43845C4CEFE;
	Mon, 13 Oct 2025 15:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368995;
	bh=pPOPGvUKMGz44dYGFNQ8RH42dV2zL5ooMSuTprjkcoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BGAGyAjZ6S9iWfGsx58mKNBXwlSIoM5HktPimtyLdc8Qps4wCMKsb3+tK9UsmK+Bv
	 zGqIb3bx7vtrVsOA9KuYKMamHrEKTFhHk/Q+jK6c0GungXSp2NEuVvlVvPDqxSqVEz
	 Fx6qRCs1CR0zoC5TTdYVWk4LEh3fCIvLG3UM2Gjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 058/563] arm64: dts: renesas: sparrow-hawk: Invert microSD voltage selector on EVTB1
Date: Mon, 13 Oct 2025 16:38:39 +0200
Message-ID: <20251013144413.392997651@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit ae95807b00e1639b3f6ab94eb2cd887266e4f766 ]

Invert the polarity of microSD voltage selector on Retronix R-Car V4H
Sparrow Hawk board. The voltage selector was not populated on prototype
EVTA1 boards, and is implemented slightly different on EVTB1 boards. As
the EVTA1 boards are from a limited run and generally not available,
update the DT to make it compatible with EVTB1 microSD voltage selector.

Fixes: a719915e76f2 ("arm64: dts: renesas: r8a779g3: Add Retronix R-Car V4H Sparrow Hawk board support")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250727235905.290427-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts b/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
index 9ba23129e65ec..18411dfb524fd 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
+++ b/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
@@ -185,7 +185,7 @@ vcc_sdhi: regulator-vcc-sdhi {
 		regulator-max-microvolt = <3300000>;
 		gpios = <&gpio8 13 GPIO_ACTIVE_HIGH>;
 		gpios-states = <1>;
-		states = <3300000 0>, <1800000 1>;
+		states = <1800000 0>, <3300000 1>;
 	};
 };
 
-- 
2.51.0



