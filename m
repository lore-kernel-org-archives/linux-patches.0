Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039150;
	b=1LmL+X2QJEgrTOcJtbOu5QN3EikKHTgUjkwlsjgXkrXXf6xKovHXpfi6TBjVj/Vi3bqs
	 3lbMWi1ZH+aN4pGjS3oz0W71uht4VKi6kgVbUCswluQQI1CB541WdNrwd4rIWHrrVoGYE
	 z3bDg9U4DUpfANLXHPF15xs2G2mlgjFGXbyJMxQ5I5hzcy6JwBuwAwDQ/KqCLKulWwSkh
	 l/H0qxD8TrIC0R/nQ+W0L1OwxGOwh1nbAXw7wljM2cjVL7aqR315XcfXdOqa3AKph5cto
	 KSqKFSOpYvX9sTMBD06og79HbwPgD2f2JPLDCCMf4KuR7TlBH9oPgoxW1HViZfd9dzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lEfNUM5qkrATTYyjngKU1iVDKFGW9FgltII1O78uPmM=;
	b=z9LhIiwAvZmr/9ku+qicvWLlaNs6fCU/SOQTR9NjRt8Bft9M15H01jAY/qkWIDbOYiyG
	 e82WfBEGQ5rVFF6ggVKhQ9CmPsWh10bT2pYJJPqdo9eA47wDAJqIsRGywAOQWEuHT8HUV
	 F1zcq0JPYKkmdVDFZGNRp3zL66M0pr4nsEWVZNGn4TX+n2kcp/kxg0ewsDt1HPNFnkFPA
	 EZZII89rE+zq5GKZoW/dQkv3sbx2FRZ013cbpSe0ApyvfEqkNgJ7Tfeedl0OOKgXO08Bb
	 N1REGlFA+vD8GuBb/8+3u8OyI9ZygGp0CfTs1laal8MSIM3B9x2bfLgOfPNR7lrHTWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CNDVTURW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBE1606A31C;
	Wed, 18 Nov 2026 21:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CNDVTURW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D4D1F000C4;
	Wed, 18 Nov 2026 21:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039150;
	bh=lEfNUM5qkrATTYyjngKU1iVDKFGW9FgltII1O78uPmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CNDVTURW9NeOrBWoOWZDI91u0072eVA2XaMPXufkP3BUl2b29A9RyQpGipjpHljWz
	 FzrQd2RhkhS7oHWFAV+20LuLpoKiXTLZgEVhx6KfnukMKDwKLx1athOM9q8uP+684A
	 BbFkeBnwgbrp9FOU4SBGE4CzqpBThsp50ooAt1gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1996/3318] ARM: dts: armada-385-clearfog-gtr: fix vmmc property name
Date: Wed, 18 Nov 2026 15:43:38 +0100
Message-ID: <20261118150421.932278024@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 337d10963f601d5a3dfb4b7aa273ca8c0b4d5172 ]

The SDHCI node references the 3.3V regulator through a bare "vmmc"
property, which is not part of the mmc controller DT binding; the
correct property is "vmmc-supply".

Fixes: aecc313490ae ("ARM: dts: mvebu: add support for SolidRun Clearfog GTR")
Assisted-by: opencode:big-pickle
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi b/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
index d1452a04e9040..0435c9c20ea73 100644
--- a/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
+++ b/arch/arm/boot/dts/marvell/armada-385-clearfog-gtr.dtsi
@@ -202,7 +202,7 @@ sdhci@d8000 {
 				pinctrl-0 = <&cf_gtr_sdhci_pins>;
 				pinctrl-names = "default";
 				status = "okay";
-				vmmc = <&reg_3p3v>;
+				vmmc-supply = <&reg_3p3v>;
 				wp-inverted;
 			};
 
-- 
2.53.0



