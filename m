Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C8B11190;
	Sat,  3 Feb 2024 04:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933798; cv=none; b=mpwI6VM7HUrr77rrygv6OPW0kedoqcTou3kownszcjyh0PIow00emAZDn6JGrL0vF6dpBi4/WkIsmnIAqdxudaAT2KoIjOtjD8cZG4C5Dtl26vbe//BEo0t2d3FQwn/9IjjuIksIF8FWpoVfV1KkZjQAgoFkNmfjnYIDA+szASk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933798; c=relaxed/simple;
	bh=G8xYC+oLsiedvAcF/Ew3WwYE0AbwL/kF18tRYzEcHYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cpPRd6EwQfsXuo5s/Oiko+yzIKgPzzK3wlp+xtxO5P7nLGCmpZqUv4MSamajmi61RrZWbJFh6qMorWiP4+4BviQ2qe0lVIthVxAXsQ5riEcdu8DsckaOeWmpbEOQ/rlVlMje/81g8GGJBY3Zibtjo6FF+iU1baXGSreRL1apTt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G388pNUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G388pNUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5EEC433C7;
	Sat,  3 Feb 2024 04:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933798;
	bh=G8xYC+oLsiedvAcF/Ew3WwYE0AbwL/kF18tRYzEcHYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G388pNUoYoiiVp+3PVcT4ymdaAybJS4//U7zC2h2Q6TUrWcSmiKS6YS60ISCfFUln
	 nGcYlsibDgqzSDDsLG6ZIopG3vJB/+L7tvEs+GAY3v2IfLJTNGdYHP+SUvr51eA3Wy
	 1sVJaO5rF2hTvUH1tAVmXEcBp8gewWU7kAeE+rrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 109/353] ARM: dts: rockchip: fix rk3036 hdmi ports node
Date: Fri,  2 Feb 2024 20:03:47 -0800
Message-ID: <20240203035407.216265323@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 27ded76ef0fcfcf939914532aae575cf23c221b4 ]

Fix hdmi ports node so that it matches the
rockchip,inno-hdmi.yaml binding.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/9a2afac1-ed5c-382d-02b0-b2f5f1af3abb@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rockchip/rk3036.dtsi | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rockchip/rk3036.dtsi b/arch/arm/boot/dts/rockchip/rk3036.dtsi
index 78686fc72ce6..c420c7c642cb 100644
--- a/arch/arm/boot/dts/rockchip/rk3036.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk3036.dtsi
@@ -402,12 +402,20 @@
 		pinctrl-0 = <&hdmi_ctl>;
 		status = "disabled";
 
-		hdmi_in: port {
+		ports {
 			#address-cells = <1>;
 			#size-cells = <0>;
-			hdmi_in_vop: endpoint@0 {
+
+			hdmi_in: port@0 {
 				reg = <0>;
-				remote-endpoint = <&vop_out_hdmi>;
+
+				hdmi_in_vop: endpoint {
+					remote-endpoint = <&vop_out_hdmi>;
+				};
+			};
+
+			hdmi_out: port@1 {
+				reg = <1>;
 			};
 		};
 	};
-- 
2.43.0



