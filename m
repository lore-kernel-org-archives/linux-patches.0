Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015235;
	b=rulafnhDq0aajosi0UVng9K33UqmYGHrSl5TyPHqpdRO+K4xh5XGG53pPfIjRKHEBNBL
	 2amlWJ9is2FMOIi0vbP81lRQ/Yk5if8tXz6PoobXxLgMDedk0/THEq0bh/sK4ti+gI46v
	 +9FWcerYUrU/vql479ddBeR4bjAlqJsDBHsdzDzfttiB3C5tMrvmyCndQDVu32p9KxNtM
	 bq1PoTPLPZhewDbAUqwSCDUWPceywp0vdkdf7lG5bzwK0aYrua63H5zRzFCenZTibWtId
	 0PFRzg5ZhJaspKzHPKUIn5bpB2cYwfqj/SrgjGfGrdkMDyM6jvqC9McWkqlBq5BznCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015235;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=W5BVLk5U3Vls7IIW7xxXQdqAy1bDVr+rR6sayf5Rduk=;
	b=LV+0Jpg0AneJh215Lm0QfxeUIT5OjIMlrjnRCpSMS8zgvpKDYSvs6OMLbhkLJvAy7VPl
	 gfjVKpvPwQlBBR6+HbcCsBvxEkhnRiODAc5YPI9j6a9+KMFmYyz3cIk5PYqpNfWC9s5qJ
	 XDAZ0sRCygJ1E/Gfja4tA71/8uPvnClF07QzduWNUo15veOtjfeHi/rYkL8a2z6FrRei1
	 /hDy7Cm8WrvkFCpqaCRMxxUXCvYWH41H7iDqacgWxCspi0F6L32r5YDsgcdteJAUErrdv
	 OwZ/drMRskNpsxTY+cF24BaFpHMqJq/EZFHS9/Jb0astWiAYoRpANjisTbbSBZnBHzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysgL8Ne6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5078D606A320;
	Wed, 18 Nov 2026 15:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ysgL8Ne6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A45801F000C5;
	Wed, 18 Nov 2026 15:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015235;
	bh=W5BVLk5U3Vls7IIW7xxXQdqAy1bDVr+rR6sayf5Rduk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ysgL8Ne6rBp2mUOopYYAQVzf50ViR1+lSPIkybplDvNH+6FTH6QffHLDOvPJwSZ2B
	 /9l+tjSaQyXMGbEKbmcoAAtJbEC6/lTRl9IApSb1EqDfDO622FrMCY8vXctDP49d0x
	 F2sO6ZN2s7/b5N211gSBbdvWqu1BEbU6MS/sqI0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0100/2651] ARM: dts: armada-395-gp: drop unsupported SDHCI clock-frequency
Date: Wed, 18 Nov 2026 15:22:20 +0100
Message-ID: <20261118150251.494105306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit a56183c7f15215d804290808a2b5a1fa997aa9cd ]

The SDHCI node carries a "clock-frequency" property, but the
marvell,armada-380-sdhci binding does not define it and dtbs_check
rejects the node as a result. No driver consumes it either: only a
few other sdhci-pltfm based drivers (imx, mcf, iproc, arasan,
dwcmshc, xenon) read that property, while sdhci-pxav3 derives the
maximum clock from the io clock rate.

Remove the property.

Fixes: 356645123581 ("ARM: dts: mvebu: armada-395-gp: add support for the Armada 395 GP Board")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-395-gp.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-395-gp.dts b/arch/arm/boot/dts/marvell/armada-395-gp.dts
index 6dd9e9077f842..9ea447cd35a85 100644
--- a/arch/arm/boot/dts/marvell/armada-395-gp.dts
+++ b/arch/arm/boot/dts/marvell/armada-395-gp.dts
@@ -59,7 +59,6 @@ sata@a8000 {
 
 			/* CON18 */
 			sdhci@d8000 {
-				clock-frequency = <200000000>;
 				broken-cd;
 				wp-inverted;
 				bus-width = <8>;
-- 
2.53.0



