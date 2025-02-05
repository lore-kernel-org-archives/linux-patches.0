Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1AA175D5D;
	Wed,  5 Feb 2025 14:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767545; cv=none; b=bdP2ku4tEgAkt2P+HodCg8+Ze9spdnOF6o46YPvcM8xcys0NSFFYhl/Hiz8KNN6XPqZs2e20Y2ST5PNWtKE5pOs7oImzzTZ8r+vDMho6FPzTQ2U+SkUWcWwlXnlRm/bOwynH3cDFzMW2YXMIeiWeSF9CldRk8l87LKPSp03km9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767545; c=relaxed/simple;
	bh=9/EBPWXmzwzmnyj27mA/bWNyRtjTlmNdYDFknIoj93w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8Fu8Cnety3W94gNi4BxboS2xjtu/by1r/kfKPb1A4JJ6eWP5sY9W6olyHPHiMiM07AndWAGQ3ILoE/Nxj2RE8zS0mUCyPyGYXJOVOtBPjhGieoaa5Xluz+DRxKDWFvyJDdvwKbcj+Mc7I5L8JeS3CLJM6qcvlTcTE8lww9X/P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dmOehnpi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dmOehnpi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBA6C4CED1;
	Wed,  5 Feb 2025 14:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767545;
	bh=9/EBPWXmzwzmnyj27mA/bWNyRtjTlmNdYDFknIoj93w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dmOehnpiQL2dbgxP+0IGPV27znIoTifdQm+qS7YsZpRSTjm9MjQnr5v9pV5a0Tb1G
	 JF7KwC0QvEXiAFdD2TGxT92p+T9mRl3yXS2+rNONg8HXuGZ/oNcI2ig1T8zTIXB3Aq
	 5JDYg4qduZx92t4Xhg8822nqPoRAmHRXvd/bDOpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 396/623] arm64: dts: ti: k3-am62: Remove duplicate GICR reg
Date: Wed,  5 Feb 2025 14:42:18 +0100
Message-ID: <20250205134511.371935351@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryan Brattlof <bb@ti.com>

[ Upstream commit 72c691d77ea5d0c4636fd3e9f0ad80d813c7d1a7 ]

The GIC Redistributor control register range is mapped twice. Remove
the extra entry from the reg range.

Fixes: f1d17330a5be ("arm64: dts: ti: Introduce base support for AM62x SoC")
Reported-by: Bin Liu <b-liu@ti.com>
Signed-off-by: Bryan Brattlof <bb@ti.com>
Link: https://lore.kernel.org/r/20241210-am62-gic-fixup-v1-1-758b4d5b4a0a@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-main.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
index 7cd727d10a5f2..7d355aa73ea21 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-main.dtsi
@@ -23,7 +23,6 @@
 		interrupt-controller;
 		reg = <0x00 0x01800000 0x00 0x10000>,	/* GICD */
 		      <0x00 0x01880000 0x00 0xc0000>,	/* GICR */
-		      <0x00 0x01880000 0x00 0xc0000>,   /* GICR */
 		      <0x01 0x00000000 0x00 0x2000>,    /* GICC */
 		      <0x01 0x00010000 0x00 0x1000>,    /* GICH */
 		      <0x01 0x00020000 0x00 0x2000>;    /* GICV */
-- 
2.39.5



