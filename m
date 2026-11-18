Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017698;
	b=z/VpfJHaobWztInSIPujtFEnNwbcFFnhxCNaTkyFFeOcG/ZDJ9x/RWfNhwplEJG4yU/L
	 ZC+DKnztSFFr5o4688neRusvcNYKepM9o+lQYRmo9R49hU7OES9+VC0BgvvWse72hQyZQ
	 F+rzJADeda9YA309JvEOQ+xZudFsbhpHpJgqxEKnx3XgzpWhsT7VuniZrAO268QAf82om
	 TWcRuYj6WkXTG+0f11iR6Sg1rLmJeORpXy1DlvGfougAkHe++lR4kAO+vCEOfaFS+kru9
	 yqfXyc+cHWAAfrtjjVBnaGLwUKAJCl4G+etPymRG9WnNwJjOwmtxwG2vPffTVWVtp8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017698;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nucU/FmhaoxvFfepQSAb5GttFUE99QtLj572N1hx9G0=;
	b=dkBdafSgfdxh04WxrnQfD/p3aZyCPTo+gs0pvH+RotU4UCcb9WZAZ5GULbooZIV37dxA
	 q3fEapV1/+J4fh0Mmgsf1eQufcqpEVPpoA+8fmNDAG+LBsGfO8kwvrIgs+AxomWu1deh0
	 q1+SP3Cxyb0n5HaBPe0zGHmcGoosZNwAmJlvpkdt6Om8blCIhx9Hcd4bUSwG1l+go8rBz
	 elbC4ON7LmdiXFDlQg/blobAIabLm2x58NhPCiHCLSE5ZtNcOBj9rolpgd7GO5RFxbslO
	 wy2knXQZLtGHyPfTdC/vv74e/lAB3+KpEGHFjWHYGON6mVJFoOLWStYRSwR6qz7xbfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aITRuXr0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D20606A32F;
	Wed, 18 Nov 2026 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aITRuXr0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FA9D1F000C4;
	Wed, 18 Nov 2026 16:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017697;
	bh=nucU/FmhaoxvFfepQSAb5GttFUE99QtLj572N1hx9G0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aITRuXr0Y/QDEfxU9XG3kV3L+2XSHsiJLVWQFdksStNAgw4LBhlG27DdMwHGAVSaC
	 9DvEzK4R11FqRYa8tYNg+B9YqBJI4qyVZVveL319kkkSgmJXiLoJtpShjMmW/qnZCs
	 bGLATmfYd3ZKssTds+fnefX6BfDtjiFKwg4+6PEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0977/2651] arm64: dts: ti: k3-am62-verdin-ivy: Fix main_gpio0/main_gpio1 line names size
Date: Wed, 18 Nov 2026 15:36:57 +0100
Message-ID: <20261118150323.073840028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit a74db73609d6e307bfcb6ef8073be2c47fb5bd9e ]

ivy redefines gpio-line-names for main_gpio0/main_gpio1, sized 87/88
entries instead of the SoC's actual 92/52 ti,ngpio. Resize both
arrays to match, keeping every existing label at its original index.

Fixes: 881f5e9d8082 ("arm64: dts: ti: k3-am62-verdin: Add Ivy carrier board")
Assisted-by: LLM
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260922152551.270845-2-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../arm64/boot/dts/ti/k3-am62-verdin-ivy.dtsi | 41 +++----------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-verdin-ivy.dtsi b/arch/arm64/boot/dts/ti/k3-am62-verdin-ivy.dtsi
index 844f59f772e18..c99076109a9b6 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin-ivy.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin-ivy.dtsi
@@ -367,6 +367,11 @@ &main_gpio0 {
 		"",
 		"",
 		"",
+		"",
+		"",
+		"",
+		"",
+		"", /* 90 */
 		"";
 };
 
@@ -425,42 +430,6 @@ &main_gpio1 {
 		"",
 		"",
 		"", /* 50 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"", /* 60 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"", /* 70 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
-		"", /* 80 */
-		"",
-		"",
-		"",
-		"",
-		"",
-		"",
 		"";
 };
 
-- 
2.53.0



