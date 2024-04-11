Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050ED13FD94;
	Thu, 11 Apr 2024 10:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831123; cv=none; b=V8ptcWVDnWJD0QfoZKfl92NDiYw6/haNK35rZJvpVKDL+v29GTZjavQ5WnBp7WnCNOrDfVx/RYR07zdB7krMLwF/N2L187a40cdQ47+fDe5i+hTAFLS6NuCvWjba3Jnig2okaCfWJdxHypcGMQIZEZTf0EgGwMUprz0sv6qmZtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831123; c=relaxed/simple;
	bh=lvqH8mUMP05H43amM3gIdFtWnj0DOiePv4BNW3a/Uv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MfDk1D7ESJBO1awltMUZddv2cT/bygZP+YfCbmQmMMQwOU53CkDgCnVvQvh/GqAo83yQxN4QP1Bpdw1/HR6Tuxx7SRi8leqmgkMYBR4QsQ6W5glJ2taNwGipAu/7udlBXpSkFKlvPLNMnvamCEeQgiESdyBMuiADAUn7q+a0HSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hhJwIDSp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hhJwIDSp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA57C433F1;
	Thu, 11 Apr 2024 10:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831122;
	bh=lvqH8mUMP05H43amM3gIdFtWnj0DOiePv4BNW3a/Uv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hhJwIDSp3vzYziVCBbVyxT63Cvby4Z0xyeDGkRaVi2HlkklPGwLt/yDHh/PHro4xw
	 6dugtDmPpDtSMQ98gDNeKbhZbCITKns4j8WOKZpjrASiZkOpHfWgAqoF+gnUeyGd9g
	 A9NI3Us7zRYxvYLfb7H+uaXyCF3XEgJEIj4ooXps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 016/114] arm64: dts: rockchip: fix rk3328 hdmi ports node
Date: Thu, 11 Apr 2024 11:55:43 +0200
Message-ID: <20240411095417.359151122@linuxfoundation.org>
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
index cc8209795c3e5..3778fe5c42a4b 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -743,11 +743,20 @@ hdmi: hdmi@ff3c0000 {
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



