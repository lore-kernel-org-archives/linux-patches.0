Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27B7212634;
	Tue, 12 Nov 2024 10:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407029; cv=none; b=B9ZS3NIVyzPqzsQgI8u+YvYJ0OwlbyI5KA51LigC/LSnirXHptSktzH1OTjFP6/lrp8Yi+Ga5KpPqfBryWUvA/QtemYdSE9RuW6TNJosLVG7YP6grcceEF7L/asvOmUs4Un15FjptZFFG6z3UaNlnFjb6hFviko/ZU2/kzUwTEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407029; c=relaxed/simple;
	bh=1aldq+zaIw0BXeAvCMboRO/Hp0Tep7rS1hnyIA1/lZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scwCygycwRP04zk/xg12G6XLzB5QWUckFiNUJZH99bH5zJCGgdB3ncwfNFpre7BLseBsRC2pT24nV42DRDRIMIcfAsdBGZgM37QX1NxjgSeqGO+Ns8tIA5+pxLlnAOpVJ1T8ddchRkiiXV1tIzGpPqS65wjY8Tyjrgu8fDOJfMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbC9CRwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbC9CRwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E337C4CECD;
	Tue, 12 Nov 2024 10:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407028;
	bh=1aldq+zaIw0BXeAvCMboRO/Hp0Tep7rS1hnyIA1/lZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbC9CRwjMNE50UG2kHL/Ivc68/rOCN+2Auc530vaDMGaUKDZWEJwXnVtlpfXxLJQb
	 JK3n4g7jiFz6YguXCN2r9AysqJywrCJM44rvH5B+rlJdPQzTw5quJvsYaZ3UvSbH8c
	 fvkdKaKNKvRKx8TscghHGjROP768ThLOStE61H6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 07/76] ARM: dts: rockchip: fix rk3036 acodec node
Date: Tue, 12 Nov 2024 11:20:32 +0100
Message-ID: <20241112101840.062822549@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0af1a86f9dc45..4db4e19b22a1e 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -382,12 +382,13 @@
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



