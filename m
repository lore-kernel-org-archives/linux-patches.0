Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0651DE4CC;
	Wed, 19 Feb 2025 09:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956394; cv=none; b=IDwQhXmYtmeG3u6uULQXZMtBqWWBWUDoy95osRZUsbbLsJtYSDC79MDWT9wa67DRHW6pzEgYIcdblx8smSQREY09ZFQPNYsXCxHiE4Fs1T/mmemAj74y9QdpSY2dggSy7aUoCtdkgx9neSJnnErwJnfosHl/VxQ6t4zSMn0QHzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956394; c=relaxed/simple;
	bh=4Txlr3tBOqJpUT2aADvm7PrJFngdkhdPIw/4Eb4rnis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mwNLTVc3Gq4SEQWSb6jLXjFNdfzkIUAiZp+SH4sHhojZD6xtJ3UfRIUV713G1lrUvivTYodYJwFbC6AcuN9epUi5ypx5lCR+zEQCjDvtqjuyLevuIBvw+Nsltjyru9QDV0X51UVETeZZShcoMj5GwyXQoLFn7a4/2XlGaZm5yP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nEFSum91; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nEFSum91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33756C4CED1;
	Wed, 19 Feb 2025 09:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956394;
	bh=4Txlr3tBOqJpUT2aADvm7PrJFngdkhdPIw/4Eb4rnis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nEFSum9148NOmwU/09pgWBNPPhyoQUvnkHOBcM+/wrD9BVuBq9PEvQ1M2ZXUcDktc
	 R8/44RxIqI4SEXNwitfvSp7zaHb3Ab+okb2az6al3y420LMdujYMdiipq5GUOj3hDH
	 o0Yqrx5aU726dVZGxiu+v6S3eCK3ohvTpPc2uHl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bin Liu <b-liu@ti.com>,
	Bryan Brattlof <bb@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/578] arm64: dts: ti: k3-am62: Remove duplicate GICR reg
Date: Wed, 19 Feb 2025 09:22:48 +0100
Message-ID: <20250219082659.420011039@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eb8690a6be168..04222028e53e2 100644
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



