Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F23913C3F6;
	Wed,  5 Feb 2025 14:21:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765309; cv=none; b=MetIrMb59Joc8GAYHVLrxx6iUGWLKnV9cFZ9OVp+d+2KT8Uk1QS7zmXMEYTK14hCZdllFYl8t0IpE59GXCuAIqIlyzXG4/heilPR89nbwMZGZtoOWvZwv+Udw70PSyocGzxk1COg3N8f5rLEmiMIsZGfpQ2s+7bQivIh8gF62qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765309; c=relaxed/simple;
	bh=OHrrl9wMpa6m6v3cfDRJ46ZZS+BDusO149XBCejwy0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QhpOK81duG/wh52HnhLknca6Z2JGNL4uwyoBYYrP3avteuXn23leO0+5tG5mWCI/zthKzg1oFTDPumDiqvoUoxdV+Qx41HlECoGr3LW9QNmx/v/nJwbHfPLsmuiZsUWa8icBtGIGP2pyRe3XnsytggMYYQKM+xl52vFN4EMyKlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y7YtVONK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y7YtVONK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80872C4CED1;
	Wed,  5 Feb 2025 14:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765309;
	bh=OHrrl9wMpa6m6v3cfDRJ46ZZS+BDusO149XBCejwy0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y7YtVONKdiAW+eSg01cCQYMDjmOoWJqExp/LDH9FxTPXK/NWqz62l/eSQczPT/uIM
	 OXnCw2yiSaLczSxMLKiVg149my30mfSsKJHvgrg3dr3KKai3anr4W96St4JCarPb9t
	 HVzmk4S04uwYutEjs8H7zUsricTAWGyX//Eieeq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/393] arm64: dts: ti: k3-am62a: Remove duplicate GICR reg
Date: Wed,  5 Feb 2025 14:42:51 +0100
Message-ID: <20250205134429.948356723@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Brattlof <bb@ti.com>

[ Upstream commit 6f0232577e260cdbc25508e27bb0b75ade7e7ebc ]

The GIC Redistributor control range is mapped twice. Remove the extra
entry from the reg range.

Fixes: 5fc6b1b62639 ("arm64: dts: ti: Introduce AM62A7 family of SoCs")
Reported-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20241210-am62-gic-fixup-v1-2-758b4d5b4a0a@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a-main.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
index de36abb243f10..1497f7c8adfaf 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-main.dtsi
@@ -18,7 +18,6 @@
 		compatible = "arm,gic-v3";
 		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
 		      <0x00 0x01880000 0x00 0xc0000>,	/* GICR */
-		      <0x00 0x01880000 0x00 0xc0000>,   /* GICR */
 		      <0x01 0x00000000 0x00 0x2000>,    /* GICC */
 		      <0x01 0x00010000 0x00 0x1000>,    /* GICH */
 		      <0x01 0x00020000 0x00 0x2000>;    /* GICV */
-- 
2.39.5



