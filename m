Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846DF18C034;
	Thu, 17 Apr 2025 18:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913433; cv=none; b=sbW52AxvuxRh7msscI2qzdsSiHGvfgLRFj+0lpdwUNJok7kMcmbTvuDKjBRvs1KdCzz3YpXqEvxB9rSDEL5ZMZXiO+rHFQnKJU2Fyuixtsx8uXm89Ur3VzW3wHcVMptsAm8UaLnsDL52d0bukoqZenMNruU9NN3DW/M4h+wVIXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913433; c=relaxed/simple;
	bh=pghpc3BLkKfOVzKB8bG8aM1sYSH69kiMmwJdpsoHZmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WCoCQMkVxwIvT/JzkWq6QtQm2FNYVRtOWYi1TdL4rBjBmF5kfD5Fgb4ldmBP41sajr/9yBIMjayzEL5B7+fjDXAdjxji4WphOTVfaaWLAPoQxfmqvyzn6UyS3zNzOMpTnrAQiG7pNpCa9yz7U+VMk+OiqVWoWsWhttyUgmaADMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sKEE0eXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sKEE0eXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA2CC4CEEA;
	Thu, 17 Apr 2025 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913433;
	bh=pghpc3BLkKfOVzKB8bG8aM1sYSH69kiMmwJdpsoHZmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sKEE0eXojd3uWVQ7nXh5vTHYw0sruMN0dmhV53G0sV6CHnynKDTLVBHLTqtFRS5Dw
	 Jxb8oB3hCjljNmcOuGJXRKF/9mcOAMZnPMVepbn7g8S132OfrgontVsGl4i+2YIQ1k
	 TQ3fk3DcEXBesFh/w84CXi9zyKQdDH5v2fRc7Pqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.14 338/449] arm64: dts: ti: k3-j784s4-j742s2-main-common: Fix serdes_ln_ctrl reg-masks
Date: Thu, 17 Apr 2025 19:50:26 +0200
Message-ID: <20250417175131.796762382@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

commit 38e7f9092efbbf2a4a67e4410b55b797f8d1e184 upstream.

Commit under Fixes added the 'idle-states' property for SERDES4 lane muxes
without defining the corresponding register offsets and masks for it in the
'mux-reg-masks' property within the 'serdes_ln_ctrl' node.

Fix this.

Fixes: 7287d423f138 ("arm64: dts: ti: k3-j784s4-main: Add system controller and SERDES lane mux")
Cc: stable@vger.kernel.org
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Link: https://lore.kernel.org/r/20250228053850.506028-1-s-vadapalli@ti.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-j784s4-j742s2-main-common.dtsi
@@ -84,7 +84,9 @@
 					<0x10 0x3>, <0x14 0x3>, /* SERDES1 lane0/1 select */
 					<0x18 0x3>, <0x1c 0x3>, /* SERDES1 lane2/3 select */
 					<0x20 0x3>, <0x24 0x3>, /* SERDES2 lane0/1 select */
-					<0x28 0x3>, <0x2c 0x3>; /* SERDES2 lane2/3 select */
+					<0x28 0x3>, <0x2c 0x3>, /* SERDES2 lane2/3 select */
+					<0x40 0x3>, <0x44 0x3>, /* SERDES4 lane0/1 select */
+					<0x48 0x3>, <0x4c 0x3>; /* SERDES4 lane2/3 select */
 			idle-states = <J784S4_SERDES0_LANE0_PCIE1_LANE0>,
 				      <J784S4_SERDES0_LANE1_PCIE1_LANE1>,
 				      <J784S4_SERDES0_LANE2_IP3_UNUSED>,


