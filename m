Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B0B61E89C;
	Wed,  5 Feb 2025 14:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767565; cv=none; b=BDousirUZ9EJEJhvoEE7LT8RxoDJMunv19/wks1CNHCno4F6w/BiTre+HB4wOGjG23Uw/UeZ1piEKpddxpAyUlGUOkjLpYacjRUJh9e7voQI1kO9JqMU2yyXGxiCaPvRhgO5KkYyqtwbNm6b0SmHbppgcp3uZs7XPDippEO1Krk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767565; c=relaxed/simple;
	bh=rnZN/PPYkeSyU2Y3Sr0aqqscC6G49PEsKh7Rw3t9lHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UNnXtdLItIi4mDKJiOj6gXCBj3jRhboNfbtTwC5DGsm+yJBecqJ764gVOWQIa08aHSOC1S/VqPfbF5fPi6P1QUfBw/dDOqSUISvcjRztrs0W5pOVZb8zuKgKYl/3w8I61IsNeqb2plYjRxx3QqXDHds0AT6FVR+CjEfY46gtEtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ukZ41PR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukZ41PR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07455C4CEDD;
	Wed,  5 Feb 2025 14:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767564;
	bh=rnZN/PPYkeSyU2Y3Sr0aqqscC6G49PEsKh7Rw3t9lHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukZ41PR0UNjCPKUUMye5R1IGPsT6o9ZB5vzElXL6hpdzuafe9RlIorKJermzQSAL1
	 KpGSxdMIbY6Hxy46IasoYZKaCdZPiXYf/jDwp4Y1s4sor6eZvZa7R2qiAYIsO13Mql
	 /WCAPZoOCfkzFzKr7UOeqRjpS78PLlqTIYvRwOOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Riesch <michael.riesch@wolfvision.net>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 422/623] arm64: dts: rockchip: fix num-channels property of wolfvision pf5 mic
Date: Wed,  5 Feb 2025 14:42:44 +0100
Message-ID: <20250205134512.370189018@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Riesch <michael.riesch@wolfvision.net>

[ Upstream commit 11d07966c83f5eccf6b927cb32862aef58488e23 ]

The Rockchip RK3568 PDM block always considers stereo inputs. Therefore,
the number of channels must be always an even number, even if a single
mono microphone is attached.

Fixes: 0be29f76633a ("arm64: dts: rockchip: add wolfvision pf5 mainboard")
Signed-off-by: Michael Riesch <michael.riesch@wolfvision.net>
Link: https://lore.kernel.org/r/20241218-b4-wolfvision-pf5-update-v1-1-1d1959858708@wolfvision.net
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dts b/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dts
index e8243c9085427..c6e4137312410 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-wolfvision-pf5.dts
@@ -53,7 +53,7 @@
 
 	pdm_codec: pdm-codec {
 		compatible = "dmic-codec";
-		num-channels = <1>;
+		num-channels = <2>;
 		#sound-dai-cells = <0>;
 	};
 
-- 
2.39.5



