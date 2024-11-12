Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8492309AE;
	Tue, 12 Nov 2024 10:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408052; cv=none; b=BUfnvaXdJKYxc30Mow6q0ryk4oaYQ4NEQpzukpWWurnzXcQ1DYkbQN+TP0auJK1G2+le0gbH2nIDJFBpMlU7L5ECypPckfBgaCpZa/6bXpLA498u6hfl5MhILgdvCgiIa0+HA/fjwX7ZmZ1U8WboKPSnt7uxTryOEV0kEes1kdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408052; c=relaxed/simple;
	bh=fgjZlizKwtBsnod+5vS72iVtx0SdivMqUxINbS9sHnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fam9f7KOD1XS4K5ZR1NaX3QbSuhbe6ySACV/GRcetYAdtmmbJouKl2ylxAGBn51Y3CFVwJMxln3F7cAQkmZOhBlBiD358iC76rrJhU669F0Asjewoa7cUMUcq5GKP5eoOgEP+rjGWH2dwHtKT78h9ZmULLjoMbN1nJYPX3DEe90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+QCpvKK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+QCpvKK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A65CAC4CECD;
	Tue, 12 Nov 2024 10:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408052;
	bh=fgjZlizKwtBsnod+5vS72iVtx0SdivMqUxINbS9sHnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1+QCpvKKjFXKSCUMZINJvclkFHhEHj1oc5Iw26PgeFuyNc5/1Hfe7KAa+SCJTnLcQ
	 ukJz8PvZ5UPo1QzycpUR6peG4MpGF/9eoBYO5Eu0n6jYDJYEo5ucgkd7hGwKZDTGYe
	 lA+PNhwJyfTvhWt/2rHgCQyyLnqM3Jk/J+rEJeF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 027/184] ARM: dts: rockchip: fix rk3036 acodec node
Date: Tue, 12 Nov 2024 11:19:45 +0100
Message-ID: <20241112101901.909975235@linuxfoundation.org>
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

[ Upstream commit c7206853cd7d31c52575fb1dc7616b4398f3bc8f ]

The acodec node is not conformant to the binding.

Set the correct nodename, use the correct compatible, add the needed
#sound-dai-cells and sort the rockchip,grf below clocks properties
as expected.

Fixes: faea098e1808 ("ARM: dts: rockchip: add core rk3036 dtsi")
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://lore.kernel.org/r/20241008203940.2573684-12-heiko@sntech.de
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rockchip/rk3036.dtsi | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rockchip/rk3036.dtsi b/arch/arm/boot/dts/rockchip/rk3036.dtsi
index 96279d1e02fec..37369538483f7 100644
--- a/arch/arm/boot/dts/rockchip/rk3036.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3036.dtsi
@@ -384,12 +384,13 @@
 		};
 	};
 
-	acodec: acodec-ana@20030000 {
-		compatible = "rk3036-codec";
+	acodec: audio-codec@20030000 {
+		compatible = "rockchip,rk3036-codec";
 		reg = <0x20030000 0x4000>;
-		rockchip,grf = <&grf>;
 		clock-names = "acodec_pclk";
 		clocks = <&cru PCLK_ACODEC>;
+		rockchip,grf = <&grf>;
+		#sound-dai-cells = <0>;
 		status = "disabled";
 	};
 
-- 
2.43.0



