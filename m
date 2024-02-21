Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4339B46B9B;
	Wed, 21 Feb 2024 13:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521445; cv=none; b=Ko9QNsQgtgk1aZ13Sao+pSO5a58p/tmklqsgzCAiDnfYbehl+t/nGK79PIXtvHmeuT0nBjqLbilTveGouhPTRq5eilPOlEeEnojTuSoIFQpbaVRE8IETr6ECWmHGM9CtBJZge+F7isHTc8OMnsWdhEkTV5R49ngXhQOc5sEsIQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521445; c=relaxed/simple;
	bh=0Vz4UBgX4qyK6VSleWbrBM6/OlVRgOPyAMNA6l2xdoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCW1yXkn0HcwBZSUY7dnY3WTkd7ufwu38tuRIeVmBrdjDvAOitG07nfmxCGUM0oksilJWyxen1Z9imnSnMOTX+kU8+D8IIgiWi4ipsahdfSrpBo8h7gITyLtT8og8dLlhjUpbNoI7LakZN1dsWA8t7agWim1J2wgd/bL9lt5xS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PPMi5p5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PPMi5p5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41DDC43390;
	Wed, 21 Feb 2024 13:17:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521445;
	bh=0Vz4UBgX4qyK6VSleWbrBM6/OlVRgOPyAMNA6l2xdoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PPMi5p5uLIDRE+lZRGRFgRQKwSuPYC5YxJI4mQM2FVomwDb8fAsmU87QKBAKmf6IF
	 z07cwW+BqeVhw9Wwo/sip2Zf2676ZhR5KFhgjxg0l6RzsLYbVOrOCGsKvY0zMDKJyZ
	 rwoUJpoQhHGzXNJNcT9CIFu56zbL7IPAAtmn7cGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Jonker <jbx6244@gmail.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 084/202] ARM: dts: rockchip: fix rk3036 hdmi ports node
Date: Wed, 21 Feb 2024 14:06:25 +0100
Message-ID: <20240221125934.509930387@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
 arch/arm/boot/dts/rk3036.dtsi | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/arm/boot/dts/rk3036.dtsi b/arch/arm/boot/dts/rk3036.dtsi
index db612271371b..c5144f06c3e7 100644
--- a/arch/arm/boot/dts/rk3036.dtsi
+++ b/arch/arm/boot/dts/rk3036.dtsi
@@ -336,12 +336,20 @@
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



