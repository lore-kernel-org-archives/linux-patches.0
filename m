Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048891;
	b=bb4jkb0drZZiT3T1nF3xJhMly7idAwbczza8ZfllEcfdb7X9RfM8q8BICFPXtBEUzY/v
	 sCo6E4RcBPbG1gjaKXNpt7/0yoraiOlxbFxezVN6hkp3fu1PXCyEPW0ITv88KYufpdGkO
	 IFvG5syhmEkele5JayhcHyLUGjVT5VXSJHapv/iKvGoGUHkd6fK34fvJexgT2sK7vG+kO
	 wWR2nXigvg7lJeYfZJgI448Y8636KM8RIA7mDMoi+K3mt75BXfHSp6m7+yl8DL0yTKmLn
	 XmGA0zTLnlwzq9spwDPSsA4Pg+fYk32DV21/+F64M6EE/Dp5ELi1VW3EnhpZU/biiRQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048891;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cPl11l2rxzopNjQ2SAaS75uik1Vs3pnQyOaG4XRwln4=;
	b=RCU3yKmIP4j3Sr0MtrQp7oKoAJB9dHqBZlHkTBM9mBE81XB+HVoWArepTjH8fCCEX9JF
	 f0eDt6bipHYB5SYPuJxvBjLOmT9TGmLh2H2CZ//Q8CLxOr8m6oKyRns4mTZfdGsr5pMRB
	 c5yE7NA1zCNJJ/ED93qIWWPo3LXY/IP2ibEHSOErMwMuG1r+IIaBcQs48rfEbMb1cfd3n
	 YFqkQ/MUpQqZBEfGw782XsqlbClbLpgGCJYGjiId+kk2bzgi4bgTWZKXruvR9RKr4BkYr
	 a2IC0uLmvr4TbBLDts+XQmjpSm+4R6IrKD1nU7RjNJ8zRxk295Nf8hSMR3Thrcl7rSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VH4H+N3l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2482F606A31C;
	Thu, 19 Nov 2026 00:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VH4H+N3l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F74F1F000C4;
	Thu, 19 Nov 2026 00:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048891;
	bh=cPl11l2rxzopNjQ2SAaS75uik1Vs3pnQyOaG4XRwln4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VH4H+N3lLviIgWMnpM/wgKUMReav8zqYKjSijP2/iH+Ozb388C5pXJQoSuCf9qOjx
	 WDbYyWagdYDHn15iF9PfZq9AFX7FC60CtnVJofxMr0KpZSLO0w0phi0SO1VjIkezH3
	 Rcd45AwvNrw0kF4+7bP40W7RPA/BSucOByyzW9ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2155/2857] dt-bindings: display/msm: hdmi: Correct name of disallowed supplies
Date: Wed, 18 Nov 2026 15:53:09 +0100
Message-ID: <20261118150318.987237949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>

[ Upstream commit 3309f5c888602c647f50c1921c9b60759fa86c21 ]

There are no properties in DTS or Linux drivers called
"core-vcc-supplies" or "hdmi-mux-supplies", so the binding probably
wanted "-supply" properties instead (which are defined in the top-level
properties of the binding).

Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Fixes: 2f14bc38d88a ("dt-bindings: display/msm: hdmi: split and convert to yaml")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/752661/
Link: https://lore.kernel.org/r/20260911-drm-msm-hdmi-fixes-before-eliza-v4-7-87bdb9f1987f@oss.qualcomm.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/display/msm/hdmi.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/display/msm/hdmi.yaml b/Documentation/devicetree/bindings/display/msm/hdmi.yaml
index 47e97669821c3..80c642e05cf91 100644
--- a/Documentation/devicetree/bindings/display/msm/hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/msm/hdmi.yaml
@@ -127,7 +127,7 @@ allOf:
             - const: core
             - const: master_iface
             - const: slave_iface
-        core-vcc-supplies: false
+        core-vcc-supply: false
 
   - if:
       properties:
@@ -149,7 +149,7 @@ allOf:
             - const: core
             - const: alt_iface
             - const: extp
-        hdmi-mux-supplies: false
+        hdmi-mux-supply: false
 
 additionalProperties: false
 
-- 
2.53.0



