Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D71212B8D;
	Sat,  3 Feb 2024 04:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933353; cv=none; b=Ivk/bE6/GcOunNAV/brPKq9Mqh/o98vXPOCxDw+nHg2f5v1SUv6Xt36/NsGkieJ8U4TPKEuJDy/4TELar61nks2dLQKd/MBsaN++NDD9cw1Wc3NnyrUJk+R/EOAUCIE7GcmiioTYznACCCd/yAu9GXRT6FiabuwQuwYpRpV/7E8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933353; c=relaxed/simple;
	bh=dy05Eef2UpUWZYinDW5egm1u8FY/Vd1KD2ISML067b4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=klyip6Kd1DXnlBY0H/BDXfPqJBKn3Aqf5MVRu2lvlXed/rj4LC9IDep5SDP8t5DOTS3jeQGdvBQnoTZKQEOG5XxXq+CznC9zV5UUEMO9vHEugRbrNyVMHzzvPIFLHhpyXJxmJV7e6mKayXeXfRgWtvgVizehQnUQ8r0wbmgaunc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0BLuO7f8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0BLuO7f8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57718C43399;
	Sat,  3 Feb 2024 04:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933353;
	bh=dy05Eef2UpUWZYinDW5egm1u8FY/Vd1KD2ISML067b4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0BLuO7f8hFsnmn2BK8baXatvc6UWmHq+qmvTjNL/1hvmBOtYMP7lTLzMJdfV6sW4i
	 a18lv5UnjQkr0Kk8HZPjxNnm0HdIE9nq1tu4B7XnMdsXVe3DV4EXdecMwmZ/15TCE2
	 mqZr3gfuJdm7u8sEcLGFmkwaBEJLWHaXbDIooKms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/219] ARM: dts: imx7d: Fix coresight funnel ports
Date: Fri,  2 Feb 2024 20:03:51 -0800
Message-ID: <20240203035325.190028016@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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
 arch/arm/boot/dts/imx7d.dtsi | 3 ---
 arch/arm/boot/dts/imx7s.dtsi | 6 +++++-
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/imx7d.dtsi b/arch/arm/boot/dts/imx7d.dtsi
index 7ceb7c09f7ad..7ef685fdda55 100644
--- a/arch/arm/boot/dts/imx7d.dtsi
+++ b/arch/arm/boot/dts/imx7d.dtsi
@@ -208,9 +208,6 @@
 };
 
 &ca_funnel_in_ports {
-	#address-cells = <1>;
-	#size-cells = <0>;
-
 	port@1 {
 		reg = <1>;
 		ca_funnel_in_port1: endpoint {
diff --git a/arch/arm/boot/dts/imx7s.dtsi b/arch/arm/boot/dts/imx7s.dtsi
index 45947707134b..7c153c3e8238 100644
--- a/arch/arm/boot/dts/imx7s.dtsi
+++ b/arch/arm/boot/dts/imx7s.dtsi
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



