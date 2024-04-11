Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3F3E142624;
	Thu, 11 Apr 2024 10:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832322; cv=none; b=ruq2o7h8Tro8KO8Q4XrbG5TdJyIDSStnfyW36EqcOS774qiGEosViZ+wiRacedymXb5pZ624y4MXoSdvH3qi/4yV3ov36cO6yvkAHA/cGZKegjplQ8NLE7W+wwk8d1tK7Ro/b/tWIe6gdUbfqR7NrrAS3qaZD53EOaBZx+lxW9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832322; c=relaxed/simple;
	bh=qf3UrMTxpd7ot6qJlRLwENivF4LmPxNkzuxPiombpWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uXh51rzeY6dRG8wMATU7QljiduQXLMWkGpc2eP0uxBSu09Wa640L722Tk0rlcDPoYZcXQPUAuVBBxXqdVsGlR7AoGbXUmd4lc5ksUMq2CdIsQq9f5SKfKGAq27DwwynepYQv60cTT1zUVRHm0a1J4XFHWF0mi7gKe7kdAjdBkaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1trUjIz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1trUjIz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CD6C433F1;
	Thu, 11 Apr 2024 10:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832321;
	bh=qf3UrMTxpd7ot6qJlRLwENivF4LmPxNkzuxPiombpWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1trUjIz0hUtGNS0JnHkcrSvm95jcZjwddAEpmbUiTAzbTh+QS8ueuuqEISsVtN4K
	 jxpvGvrgNijduFCjaIoGFbY+CTQwOVfeu4r/tb8M4A7RVO+J9IS6ZtKf67cDsJapgh
	 OESv4Q17RaGJYN7M36L7MCPk5yfb5zDlwXzua510=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 10/83] arm64: dts: rockchip: fix rk3328 hdmi ports node
Date: Thu, 11 Apr 2024 11:56:42 +0200
Message-ID: <20240411095412.987405749@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
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
index 905a50aa5dc38..d42846efff2fe 100644
--- a/arch/arm64/boot/dts/rockchip/rk3328.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3328.dtsi
@@ -741,11 +741,20 @@ hdmi: hdmi@ff3c0000 {
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



