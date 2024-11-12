Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665ED20E337;
	Tue, 12 Nov 2024 10:28:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407327; cv=none; b=tn4kQExI7AWIo8A7R6g24mfQensf+hBkXF9irFP0Z6SDNY7NW+l8pfxgknSWimXePvrdkgNV+3qvOIYcZpw1kDaJeXe8vv51jnMort7USCOPlh0XrRXtrYs9xM7rARKk8vLs9n2np1kZ/F3EPvajaboQWCjk9YhtIB3f9tqMI1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407327; c=relaxed/simple;
	bh=CqExKTeRnYxGSO+D1cx8AuD7HUPXFEqGEpXaWJ0rTx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4VElJ60MaMZ0sqpOt5nGna6tazE4Vh5Aq4O3g9z2698rY26ZTgfqVCH7tz07AU4NrpOu5/sMRDAuEv4pu8rX7hXxPJCcoweSGzybwNxD+jRR5+CzJZLhmCzlWQkYDZ4Kl9OavbsAnNRIrZFs97idrrleC4wOulVXEdq0issP5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VzhZpJgB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VzhZpJgB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8284C4CECD;
	Tue, 12 Nov 2024 10:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407327;
	bh=CqExKTeRnYxGSO+D1cx8AuD7HUPXFEqGEpXaWJ0rTx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VzhZpJgBaQUppUS0T6UMB/JKXaSkgZ98IsaUWK49UrI9vnRn3CfXcZcQJyDuwU3g2
	 q06Zxwa7HjAGOEhKU2iAl6ZUoAIZR0kC+Xz3rlDP826iMJSFVKc7ZNqfKURX8m3j3g
	 qPkOijqzuorSR/OvShknVrvrge9BBpEQ4oN5+R8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/98] ARM: dts: rockchip: fix rk3036 acodec node
Date: Tue, 12 Nov 2024 11:20:27 +0100
Message-ID: <20241112101844.738924343@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101844.263449965@linuxfoundation.org>
References: <20241112101844.263449965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c420c7c642cb0..e6bb1d7a2b4ec 100644
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



