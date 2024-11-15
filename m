Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498E3154C00;
	Fri, 15 Nov 2024 06:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731652959; cv=none; b=h8jcx3V28hB4OdAkyKgKxC0x/7NwZzMIaWZPW7txm6LHf1btx4EoKNpF0qjsUMy3OAmUosQZxQ6xql0ZKGErPr3HtEkkFA71JUNNyjTVZ4S+o17MpaKyOnRvDp0zjArQ057ycWe9tWkWyUJe+XXrrkJLYL4XAqTCjm+nrr9MMeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731652959; c=relaxed/simple;
	bh=isPitJpzonQlFQp/4hQChCQ6+Bma67Fx6uwCVHoTDxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TaBNYH8fVqt6a1j9rjzVM2BlR4BfgLeO8hRt1s8qacbxn7lIQzGCSxyODYiHcBOiISISarJbhkd/jqBYNFSc5aUGcSio22Ge2REs167Fw5yGsR0XPlDQihznLrFVS+Lov1SnK5DMGajhHIJ1CMuuVG3OJVLIdImYdIrJcaBZQ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yx1Q6KMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yx1Q6KMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA982C4CECF;
	Fri, 15 Nov 2024 06:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731652959;
	bh=isPitJpzonQlFQp/4hQChCQ6+Bma67Fx6uwCVHoTDxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yx1Q6KMl9BRAFxl6azHmWv9b/Ml08nzXvfEwGsJx9Qu4xZq/G3EvaO2JrTLDseqq4
	 1HVZi7vgSs2+g57dWzgqwcDWStz/dmB+tdkHm2FmkAqHvqTUlauDUTxfTs3RLvjs7l
	 7yF9H2rQI27vTuFZI8WGEHCIceZrnP0+FxJp+rMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 05/66] ARM: dts: rockchip: fix rk3036 acodec node
Date: Fri, 15 Nov 2024 07:37:14 +0100
Message-ID: <20241115063723.033766208@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063722.834793938@linuxfoundation.org>
References: <20241115063722.834793938@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index cc2d596da7d4e..69ca841d57e75 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -317,12 +317,13 @@
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



