Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62F11442F7;
	Thu, 11 Apr 2024 10:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830057; cv=none; b=rnMAV95I0gxp7RC9nUlMFVvCZ9Fcsomuc92PXC9aS14lUkc2IUTT874KIqnl2d2MTML0cyzc56Xb/5zHXQpa9m1s9P4oLe7QPsaCTFLWPT+xcLxpEHM/ME2BuxNJuqzwjWm0EXYneOqd0kDxEW+YiplqlbseJNxmL/me783xSno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830057; c=relaxed/simple;
	bh=kRcudFwZqqVEUzHJUMNCj2Kzx7qD3PdGECklO67Ocy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=azQlHuyxQAIu4QG0mQiyWgzLSlPRJqjOQ30LECNgH95VbImuaKF7QOOvHSm9equoP9QwqeDYE3J14asdCEVIGlZ/sxArEvXE+WHdXWuaLASFaYybPqDWthEUZpimrnd8x9mhilnt0cexqX5CD/breCVZr/8b132hHpcPcbUE7DM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pt0kTykY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pt0kTykY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EBCCC433F1;
	Thu, 11 Apr 2024 10:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830057;
	bh=kRcudFwZqqVEUzHJUMNCj2Kzx7qD3PdGECklO67Ocy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pt0kTykY/qTmIGqWSCBLuHGnN+e7f6Oh852m44WMlftBh/SrFr7HVCjqcwaCEmL51
	 IelTL4huBwzwr/ETDTrdDw4CLg4TSaxal1ae02nuSD26L4kpt+AIUqS8JGWiYnVTXI
	 skwFcM0hdJSkIJj3y7T/fu6VsSP/MK5i9wh7SwwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 021/143] ARM: dts: rockchip: fix rk322x hdmi ports node
Date: Thu, 11 Apr 2024 11:54:49 +0200
Message-ID: <20240411095421.548734900@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 831561fc18146..96421355c2746 100644
--- a/arch/arm/boot/dts/rockchip/rk322x.dtsi
+++ b/arch/arm/boot/dts/rockchip/rk322x.dtsi
@@ -736,14 +736,20 @@ hdmi: hdmi@200a0000 {
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



