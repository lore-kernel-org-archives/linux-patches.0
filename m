Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6270B1BF24;
	Sat,  3 Feb 2024 04:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933800; cv=none; b=oGFwhBEFeiKdHviZPLYHDu9cCgGdH1wH5BxA1dQ72v/d/Fx2gEebZSjqNf4WrIbT/3RQx4rLCD1UEFiptuyAgt5elo5KsiHchg46fAD1WVQNDx7nJp9Y+h1gSdnsN+hwAeBIfSl9saQWZG0kZjJc2+y9eHIus3jxlpHnjNjtAJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933800; c=relaxed/simple;
	bh=gxPRUaO4yGjuE0UtqSdcpsg3b6556wOXpzevGdfIyz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEhSr9XHg3H8aV9J5AtYZY8MayblbuTg8U9sOZNeZjLa3cYguvSjHyYOFZ1QmM0JujHNJfO66TsHjWJDKbLtuwRxFaZ8jNDMIyln/qJmmyBNGfqHpVLuzE2ocvzA1bUIoHrdXmv5Ma/+D+Wn0s1LEd4wt+8Evuv3iA30L0IQmPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JX+CgfR0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JX+CgfR0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CABBC433F1;
	Sat,  3 Feb 2024 04:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933800;
	bh=gxPRUaO4yGjuE0UtqSdcpsg3b6556wOXpzevGdfIyz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JX+CgfR0PcSFnu2HoEcorz7t0RjLR99ai1c5mjN6xyRcrcRUfppAy1YbcuG+OlGDG
	 iiOVczJmv5/2O4NmI16TCuNgS5MtATAFskNiucoE9pF1nAYCT+oIhtFrsRjjD2jf6x
	 GitXZ7OQEDW63E52xgmMP6LXAWk16XkxUOh1GK8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 087/353] ARM: dts: imx7d: Fix coresight funnel ports
Date: Fri,  2 Feb 2024 20:03:25 -0800
Message-ID: <20240203035406.561284070@linuxfoundation.org>
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 0d4ac04fa7c3f6dc263dba6f575a2ec7a2d4eca8 ]

imx7d uses two ports for 'in-ports', so the syntax port@<num> has to
be used. imx7d has both port and port@1 nodes present, raising these
error:
funnel@30041000: in-ports: More than one condition true in oneOf schema
funnel@30041000: Unevaluated properties are not allowed
('in-ports' was unexpected)

Fix this by also using port@0 for imx7s as well.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/nxp/imx/imx7d.dtsi | 3 ---
 arch/arm/boot/dts/nxp/imx/imx7s.dtsi | 6 +++++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/nxp/imx/imx7d.dtsi b/arch/arm/boot/dts/nxp/imx/imx7d.dtsi
index 4b94b8afb55d..0484e349e064 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7d.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7d.dtsi
@@ -217,9 +217,6 @@
 };
 
 &ca_funnel_in_ports {
-	#address-cells = <1>;
-	#size-cells = <0>;
-
 	port@1 {
 		reg = <1>;
 		ca_funnel_in_port1: endpoint {
diff --git a/arch/arm/boot/dts/nxp/imx/imx7s.dtsi b/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
index 5387da8a2a0a..9f216d11a396 100644
--- a/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
+++ b/arch/arm/boot/dts/nxp/imx/imx7s.dtsi
@@ -190,7 +190,11 @@
 			clock-names = "apb_pclk";
 
 			ca_funnel_in_ports: in-ports {
-				port {
+				#address-cells = <1>;
+				#size-cells = <0>;
+
+				port@0 {
+					reg = <0>;
 					ca_funnel_in_port0: endpoint {
 						remote-endpoint = <&etm0_out_port>;
 					};
-- 
2.43.0



