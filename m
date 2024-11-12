Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5701E1CBE8F;
	Tue, 12 Nov 2024 10:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407579; cv=none; b=iVr3bjOZ/lishYQ+skbZWOFYd7GMfXP7STCsftX0iK4b5RGbe5+R36gxQVXE1a8T2eeppMpp7sIlD9HdMIOm7vdC6mngRFgemqpgPGc0eFFFGmYWgvmXMc0pnIiIj3Zh5Pyi1lN/twkCS1WducZC7lItr05+2pV/2jtUohoL1B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407579; c=relaxed/simple;
	bh=2zERLNs6/s20NDqnn5ujHdYqMJlDLkAGZtmOSoSjqEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RaPZ/GTfuWgEM2ryvdmkUR3nWPC429NN9QLkKhvRZRpZTKDeBizid2FaQmDMsP2u2TV1zzKYh4E+Q6+9aMDB1brTaVzWJCk76QbTx0UAQpRTqkPO5UorTI8aGsJK5YHlDNYwdLY0rgTNeqNHae4rERJDPh9sH4vq2EM8+k6Xd6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GUi2G5zp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GUi2G5zp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FEFC4CED4;
	Tue, 12 Nov 2024 10:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407579;
	bh=2zERLNs6/s20NDqnn5ujHdYqMJlDLkAGZtmOSoSjqEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GUi2G5zpB5KKOc8NUCwnHPU6NYoNScqItR4KAulJpXOLBWdmJqm373LMAz8cvAGUU
	 FLMlFzZ+63jC0NZu0wLqEMtjRLmcbKytADDHtsj5Rmhyilco8WTmZQMvs/rOFa3UQe
	 hOQ22+bZOz/wA/JJBJ0ioAj4iJ6ucvhuu1Wl9Owc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 019/119] ARM: dts: rockchip: fix rk3036 acodec node
Date: Tue, 12 Nov 2024 11:20:27 +0100
Message-ID: <20241112101849.448009254@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c420c7c642cb0..e6bb1d7a2b4ec 100644
--- a/arch/arm/boot/dts/rockchip/rk3036.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3036.dtsi
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



