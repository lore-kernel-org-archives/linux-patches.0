Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D7C43BBEB;
	Fri, 15 Nov 2024 06:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652804; cv=none; b=EyxPs6Ppnqo4i45UXJyM8yMHWBNNTDOgW8BSFouMvkW3yuXS/puqkgGiQ00UwDSukclea+1orAyyh+BMMciKl1gcQq/BZW6JClb9uO2QcWuPrQmyDmUXSYliHN1gZJg6vC7UgNFvfK+CAAgtw5WexP+By6uLBRXu001+qnnfleA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652804; c=relaxed/simple;
	bh=rx/vUeSFwimQnh+nOFkRi5d4Tfqt2NIWD7NR0HdDm4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQscki/j9r8C1OWynbnuM/RGq1t7nWjVGTaTTd/z2UkUC2U7U7uwz9yIuBEvvZLaR2PflH12OSNYhFAgK/T9Qi2zQfNYXfksXB3Vg8Crm9sPwOEYlry81IF+4eknuGy61sFXZumKYGnzRr9cTrEbdpXjRta6hecFCErZsIV//l4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NKsTt/r3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NKsTt/r3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B52C4CECF;
	Fri, 15 Nov 2024 06:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652804;
	bh=rx/vUeSFwimQnh+nOFkRi5d4Tfqt2NIWD7NR0HdDm4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NKsTt/r3aNvqpWYx/HjAkwdF3ZoBOWDpK5BfelfwjOnQp/ZV7WB+qTL7cbGrRDWN7
	 fXeJ57QNPiMg5Uk0gTowtGrRgi/1C+9vB8k2DOVdMMhzeDkP2rFlf23qQ3NFZTzfND
	 ANS8RSUJpDAgr+5ZB1uUkEcOPjMW6vu8FPZNodhg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 02/52] ARM: dts: rockchip: fix rk3036 acodec node
Date: Fri, 15 Nov 2024 07:37:15 +0100
Message-ID: <20241115063722.938676739@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
References: <20241115063722.845867306@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/rk3036.dtsi | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index c5144f06c3e70..f7b5853aeb79f 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -316,12 +316,13 @@
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



