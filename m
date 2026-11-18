Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055728;
	b=3j1qv9wqtfa0wuv9OfqVBWstsHZdtVNb0mUtmwsJ58Mx8Ifo6JkznAdlb3hpI8fCt7FH
	 P6I1BssY8kTfYgvjpXPazz0CiSZNgpfjXtkdCJ36Dv/yQqRkurmQ3PanGf+0LH3jEy/Ir
	 PUj5FSTb1U2rmfoSj4l3dyPeKnOyuSSCoVQKRFgfcqMzVNc214JJXyFHcTULH17anj9vi
	 TD1y7/CIw12oA/rO9ht4Hm9GZTsvOE69pjG9iRfW7X5j/bgagLXscCn2UXcs13udUSfpZ
	 NF14YmdRUYUlS67aZDw564yT824UQHSJm9UV/k64Ipvr43zo14ygdcln9hgrKv1qUnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iUw0qj2n1A4gP4JJeW0mHVf0UPw98RBemu7LroXBL6I=;
	b=oF43TcW2fRmhiMBXft1n3tQm5A90emG+tRoQfM+4krFE4rchcwqsuR7/2RWSV4o7cg3v
	 3/ZHaYvfZI9waRrUlQaWadMTy5Qxndl+PYAW2pSdcEyFVxcYT+b2pOCc+1z390NtCY/+M
	 iIgeUdLs7pPeT7/rRITDskGyZsKc5yximy8ZDMKOCTy12MwdnR3KXRjbElIICSRAYSxoz
	 RozZAbqZClbys8F/ZPgBlSPPxXXYAuDAuf4HJSGOhKPpWE3K9W3y1HL2ko+0V6aAQpQ0v
	 VdWwp83WB+EZs/ITs3RdkXlVeKU9X2gVZNQaMAT5HHFFOJOv+RkUg3kRjIJmisUV5Mg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+SGelVi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1E2606A32A;
	Thu, 19 Nov 2026 02:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w+SGelVi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD2C1F000C4;
	Thu, 19 Nov 2026 02:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055728;
	bh=iUw0qj2n1A4gP4JJeW0mHVf0UPw98RBemu7LroXBL6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w+SGelViMejte23G5cJGjwhOsDT+pV+TTTowt2kT/rLjNx+j2Gku1dzw4pJL+YOR0
	 dmNsjq+H7RKEma10Aelz2Gc0BwC1ReclUtqSMgWYaEVKAfWGmCx2a5kKEdOyKzfDCI
	 Uy53ioIQQb8rKHpuWXQuKpg4KnheoSnkYbSC9SGM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1736/2214] ARM: dts: AB8505: Enable charging options
Date: Wed, 18 Nov 2026 15:56:52 +0100
Message-ID: <20261118150121.114448300@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 1afc8a287fbd72b5380ed037ab19fdaf448755ef ]

These are not disabled on the AB8500 and after testing we
see they work fine, so enable them on AB8505 too.

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: ff1501cbb825 ("ARM: dts: ux500: Use AB8505 charger compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ste-ab8505.dtsi | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm/boot/dts/ste-ab8505.dtsi b/arch/arm/boot/dts/ste-ab8505.dtsi
index 8d018701a680c..ad40bd52311f6 100644
--- a/arch/arm/boot/dts/ste-ab8505.dtsi
+++ b/arch/arm/boot/dts/ste-ab8505.dtsi
@@ -98,7 +98,6 @@ ab8500_battery: ab8500_battery {
 				};
 
 				ab8500_fg {
-					status = "disabled";
 					compatible = "stericsson,ab8500-fg";
 					interrupts = <24 IRQ_TYPE_LEVEL_HIGH>,
 						     <8 IRQ_TYPE_LEVEL_HIGH>,
@@ -116,7 +115,6 @@ ab8500_fg {
 				};
 
 				ab8500_btemp {
-					status = "disabled";
 					compatible = "stericsson,ab8500-btemp";
 					interrupts = <20 IRQ_TYPE_LEVEL_HIGH>,
 						     <80 IRQ_TYPE_LEVEL_HIGH>,
@@ -136,7 +134,6 @@ ab8500_btemp {
 				};
 
 				ab8500_charger {
-					status = "disabled";
 					compatible = "stericsson,ab8500-charger";
 					interrupts = <10 IRQ_TYPE_LEVEL_HIGH>,
 						     <11 IRQ_TYPE_LEVEL_HIGH>,
@@ -175,7 +172,6 @@ ab8500_charger {
 				};
 
 				ab8500_chargalg {
-					status = "disabled";
 					compatible = "stericsson,ab8500-chargalg";
 					battery = <&ab8500_battery>;
 				};
-- 
2.53.0



