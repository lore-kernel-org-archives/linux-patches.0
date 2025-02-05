Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E331519BE;
	Wed,  5 Feb 2025 14:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765295; cv=none; b=d4tCLkjps2o2rUiKnVY+atICKE2LvZiVop+++LPzzhPKosEw0iqRRImwi8M0wP4GKoI+RjG0d5taGwvnUqiut5TjWVySPTXYExOzoXlHD/LrwF06dacz6w/xF6Xce75oyA/Mfr0gKog858697srGDXwKUMtco3qCTyZ++gXuw5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765295; c=relaxed/simple;
	bh=ro0x+kjc90rOVUNwaRsdSSpu/mSNE4mR+OGiFfjz7h4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iF0sxTYByIiVTXs01ZxQneNC8ITuKmcskfTvxO2Jx2pPovrO5vZGcV94ZGJULdsmqmjO1jpBWuyjzYVtAWLkVwpeArkhW9sY/3CBnCR5B9/IQIt2k1T4IHEutMfHCP3CXmls9ON4hfaSvyUOVpQIR5qVylUS8omReovcKudWYSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qb7yvprC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qb7yvprC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B71BEC4CED1;
	Wed,  5 Feb 2025 14:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765295;
	bh=ro0x+kjc90rOVUNwaRsdSSpu/mSNE4mR+OGiFfjz7h4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qb7yvprC5u/j06EO9DIbYt2QfAoK2lsC3VJuznhicmdwRr34I85TdiBpjyeUqIF6b
	 zwhnStVcE8KpOmae8gUtgvrfDZDA2eRBZaiWkkTrPxruFmdu+qG1OaXD6Y1vn/p6pA
	 Qd0HjC86tJgEol92llvSkieXRjVP2JODpitjDCHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/393] arm64: dts: ti: k3-am62: Remove duplicate GICR reg
Date: Wed,  5 Feb 2025 14:42:50 +0100
Message-ID: <20250205134429.909930812@linuxfoundation.org>
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
index a9b47ab92a02c..f156167b4e8a7 100644
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



