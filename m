Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060241;
	b=qVI8mJuZFk4jMyD9J5nbDbxdDUDvhAKDRln+mm248sx/55GW33X/D+xfdMNK2iFkag/G
	 pku2ThkP/bGe3nqCEitt09tzQxuh6CWn0TAmOqXT+yy2eIA4EvVr6JdmqXyykWqO+9Pnd
	 r1ZobdoAz4/oOIjmMXtMzRjIyojd2b4tEme1ZZFPjiZN5WwmmeH6gfBmJdjSXrx6e5Ovk
	 Lw1cqwbGDCA+eMxX1Xu9BSkNDyG9etkjYhhs1wVexoS0JDGCYLL7Qi0gQHq846vR8OCb5
	 6JaHdPgW+BfeujRSpEHG+6Ocln6CWe1FmfRNhRSju6Slq1ZiPISlJ3IFQ+PlSHKPIwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t2MGDGaq7zv8HstyQQDVPCQf/TMnsEGKPVTYbLuFlsE=;
	b=oKmdblHsu/Tgqk1W1uZ4I0x16Jb79PAEzgVEaGf6W6FeZCZLPBVHRP4twcRyNnuuylfd
	 3lSJXsEMW1t705Aq3bG5ve+8UGaInQ6HIuKEKVY87iD79LBxVrTVo1DPId4IaozVlP+pN
	 XWqn9dvmm/1XAlb3B+3UQ5yQL0UR1fdSVlKw7bmWIm0gZWeHcGX1CrhlDVKjO72/27aoZ
	 nrXiW5+Sm+s8Rg1v7S8jL19OBFrrjaqunDCyb1UwS6IUIac4UIYGxXPBDxHlVDrsDWCL/
	 rHNPcZZ+pcs3SDDG5Mf4OBhQbOxuC9mBlWWStCk+skZy4iC8hcLU5nxewJkPhApaJsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=veT7dJFb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A59606A325;
	Thu, 19 Nov 2026 03:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=veT7dJFb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D38651F000C4;
	Thu, 19 Nov 2026 03:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060241;
	bh=t2MGDGaq7zv8HstyQQDVPCQf/TMnsEGKPVTYbLuFlsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veT7dJFbSlKFhjeLjs3qvrfIgcPAKLAzH7HGaxicD0EPYhgaKtbr0ItB3xZun/tnb
	 DzvNSAE0yoCdsH9jB7FG1hW/kpUCMyzZIK+plI/91fFaP3YfXtBVB/qcjcAtSw8uVT
	 vwjs6mSKNHrM1jMCf87XutXoTGgtmt7Czpt5Nm+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1128/1848] ARM: dts: armada-395-gp: drop unsupported SDHCI clock-frequency
Date: Wed, 18 Nov 2026 15:52:46 +0100
Message-ID: <20261118150006.502949907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/armada-395-gp.dts | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm/boot/dts/armada-395-gp.dts b/arch/arm/boot/dts/armada-395-gp.dts
index 6dd9e9077f842..9ea447cd35a85 100644
--- a/arch/arm/boot/dts/armada-395-gp.dts
+++ b/arch/arm/boot/dts/armada-395-gp.dts
@@ -59,7 +59,6 @@ sata@a8000 {
 
 			/* CON18 */
 			sdhci@d8000 {
-				clock-frequency = <200000000>;
 				broken-cd;
 				wp-inverted;
 				bus-width = <8>;
-- 
2.53.0



