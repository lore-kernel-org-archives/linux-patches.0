Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD9579FD;
	Thu, 11 Apr 2024 10:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832596; cv=none; b=SIzhWcGiJK3CJwelWOtEtC3s7CeosMPtF1sB28f5lFkfMTWZqwkOVX2byhvE6r2aAyXlJRu8GRKR/QCz/azsFdpOQGKfMGz4SDEUx60BaTgLcs+x/EYK5N8RX/KO8Adi7lqafenvzGhjiRblfyh12MDnKvMZMzdUCCp61hIuuDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832596; c=relaxed/simple;
	bh=wsGv0jhbcz+z1cHEpGOUkNInNlFd5aHfUicbUGg2Xvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a76WWvlW+98CQiVDcod3O873p7pgDsCYU7hRJapGRdxtJJQrEC5aJRclzhcFKCoPYp+JVlYf0blu2mCkZg7jnOtGMnGB3uZqjHubpYpWKT8Pu/6jUmQkwjgbUSzZhczuVn2AjTZY/UZ93dLvdxuxIN2dr4I1J2TGYdHloR3DGUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fcp3Q4gD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fcp3Q4gD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB4EC433C7;
	Thu, 11 Apr 2024 10:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832596;
	bh=wsGv0jhbcz+z1cHEpGOUkNInNlFd5aHfUicbUGg2Xvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fcp3Q4gDXFfBj+rnuFNoXhdWBXI2VQ9YDPD0vWejk8jtoK3chMkaadAYcZEwIBs/n
	 uMq3pdOgand6Kfio8ZEgpWQL+OW/wn6B4MKGiLSoG/0HXkAw/tzmwfRYGwZ2C2GSyK
	 DbVypzsnqB9O9SodHDpRyevYMaXs5FL3rfz10KQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 08/57] arm64: dts: rockchip: fix rk3328 hdmi ports node
Date: Thu, 11 Apr 2024 11:57:16 +0200
Message-ID: <20240411095408.243834074@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 1d00ba4700d1e0f88ae70d028d2e17e39078fa1c ]

Fix rk3328 hdmi ports node so that it matches the
rockchip,dw-hdmi.yaml binding.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/e5dea3b7-bf84-4474-9530-cc2da3c41104@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3328.dtsi | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3328.dtsi b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
index 3cbe83e6fb9a4..26f02cc70dc5d 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -728,11 +728,20 @@ hdmi: hdmi@ff3c0000 {
 		status = "disabled";
 
 		ports {
-			hdmi_in: port {
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			hdmi_in: port@0 {
+				reg = <0>;
+
 				hdmi_in_vop: endpoint {
 					remote-endpoint = <&vop_out_hdmi>;
 				};
 			};
+
+			hdmi_out: port@1 {
+				reg = <1>;
+			};
 		};
 	};
 
-- 
2.43.0



