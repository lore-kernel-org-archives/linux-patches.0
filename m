Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173F613FD94;
	Thu, 11 Apr 2024 10:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831120; cv=none; b=pEdX8yzmSMIYkvceKYZ/QYcqob9NZXsopcPoI3IdEmAaL/ztBmHQDdiayKYhGmfV0VOePDIOuC9N9vlfmyyA1pLwHxqesLo+UqMXc03ieQzB83ySHnnFdUeSt0VraNRVG6/RHo2xgAYYgA1rnO8MxFfjPHD7Da2E1Ao91RKC+nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831120; c=relaxed/simple;
	bh=AQgikI4YWO9xp/ejRHpuwnkdDyUUEfKm5dqJ5DyKB8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCwCttNNih24XTnsqpcyuZxWRGIFFugvBJ1QlQk+7wwTOp5behtFgzqmGX2qw7HkiyhVYySRt+wKOgAy7j/k5EKpZaajSHEebwc8O9IyeS4Iy6YAxGmnU8X3xr3lFiq2uaVvzmLvwfFROl/u26zrFk1smq6A/QIPU1pc9Xs9OEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p1O8/4kR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p1O8/4kR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E951C433C7;
	Thu, 11 Apr 2024 10:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831120;
	bh=AQgikI4YWO9xp/ejRHpuwnkdDyUUEfKm5dqJ5DyKB8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p1O8/4kRMTh9c7v6errFA4hTousY39HBFvQxtQX52L8ml4pzwNcrGaHBoIWU/yV46
	 UzrP65YCOsLRZIc0kyQKPPso8h4/XEswvjlctKuyHPAuYqhYw8nwPRKUAOHg+aT6ss
	 FmB36PMiNfUxqJoOi9tghIZPpLJMWrXj4Bdt9X2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/114] ARM: dts: rockchip: fix rk322x hdmi ports node
Date: Thu, 11 Apr 2024 11:55:42 +0200
Message-ID: <20240411095417.328572346@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

From: Johan Jonker <jbx6244@gmail.com>

[ Upstream commit 15a5ed03000cf61daf87d14628085cb1bc8ae72c ]

Fix rk322x hdmi ports node so that it matches the
rockchip,dw-hdmi.yaml binding.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
Link: https://lore.kernel.org/r/9b84adf0-9312-47fd-becc-cadd06941f70@gmail.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/rockchip/rk322x.dtsi | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/arm/boot/dts/rockchip/rk322x.dtsi b/arch/arm/boot/dts/rockchip/rk322x.dtsi
index ffc16d6b97e1b..03d9baddcbaba 100644
--- a/arch/arm/boot/dts/rockchip/rk322x.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk322x.dtsi
@@ -732,14 +732,20 @@ hdmi: hdmi@200a0000 {
 		status = "disabled";
 
 		ports {
-			hdmi_in: port {
-				#address-cells = <1>;
-				#size-cells = <0>;
-				hdmi_in_vop: endpoint@0 {
-					reg = <0>;
+			#address-cells = <1>;
+			#size-cells = <0>;
+
+			hdmi_in: port@0 {
+				reg = <0>;
+
+				hdmi_in_vop: endpoint {
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



