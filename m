Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064118;
	b=cNoba1aApUncUppK5V6CTXvGphi/kdyTz1EBDvQycKXAqafmW3uoFp9sTBiuaQzUjxad
	 XaKj+4bBIo9XqhtxObT0LclMVm5xn8+g/fsw+N1f4lw3+HFEd9pnY2wLfTv8zq86CWc6i
	 ein0AsnxGuTcR8v2L0T5JcxvFgmKx5LClIaCqytAPS+oVFlJBzdsGTrQeVhHAxHMvxzCV
	 5ngFP95MVB1H/Ye8h15459dVxbeqQEWTU6ryQgp0RBSWld/4M90CPJnulOKB+CdL0Yvpo
	 BSpYVQNfg8XcyyxDHO4jjE9c5ME+dxrS17oZ/8iFj3QPEVxkiHjkfrAPNbEb9lnnE8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064118;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=09J5Ly0IdCRvosKbIdOH11fjGbAJ6Bm16Mj12gIuVYo=;
	b=Q2GHe43n7ld/a1E3YAE9/swAfEcIzl7+FnGuMOT2sd73zDSTRLbIx1P1UAi9uj8GrxDz
	 RaoncgacnVfj4fxuUr5fPXwqJB39ZN5oeEonHIgI/KLmTx0ks+9QHuVr1MHk6Cwa52fzp
	 ehiP6jMvmetNU3A3FqYG6+Fts08XQTO0GYXCaSHDU4D/eZl+y9fOlY8nUgGnoIDxRD8yg
	 opwzuY0VqqncMIkaHz39ogu/0RnKZB4eNve/jYPMGGadyhhOOUybyOj+29+0eQKvOKxMP
	 cqmISD0VfJVuiUoCDaQzte4nKnbUNO0JrBFx40ZwS3p7hDdTvADXCaXi6w2IpQm27rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6bVvaqU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC63606A33E;
	Sat,  7 Nov 2026 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T6bVvaqU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEA21F0089F;
	Sat,  7 Nov 2026 15:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064117;
	bh=09J5Ly0IdCRvosKbIdOH11fjGbAJ6Bm16Mj12gIuVYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T6bVvaqUprsnk8/svwVhqMJCP771hiG5SnMvEXsOBDbVyOLVdtZjd0R4mW8uDoiaV
	 FoGaBEZJCX9mrif3ypMyOQN3THFj+7il/y4bHnGL3SpKnP9hZKdIBszT0r9Kzyf0DJ
	 zF8sJvBbiJx4Y1JKfByoDuINOnC/tCtUA6stLe9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0274/1257] arm64: dts: freescale: imx8mm-verdin-ivy: fix DIGI_1/DIGI_2 gpio-line-names
Date: Sat,  7 Nov 2026 08:42:50 -0500
Message-ID: <20261107134947.051169976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

[ Upstream commit 28cec01a2be2cf1e20aabd435f250f665ce24c8e ]

gpio3's gpio-line-names names the two Ivy digital inputs "DIG_1" and
"DIG_2", while the official Ivy Carrier Board datasheet (Section 2.10,
Table 12) names them DIGI_1 and DIGI_2, matching the
k3-am62-verdin-ivy.dtsi variant for the same carrier board pins.

GPIO line names are meant to be stable across the whole Verdin family
and its carrier boards, so userspace GPIO tooling that looks up a line
by name works the same regardless of which Verdin SoM is fitted on
Ivy.

Fixes: adca46171ff7 ("arm64: dts: freescale: imx8mm-verdin: Add Ivy carrier board")
Cc: stable@vger.kernel.org
Link: https://docs.toradex.com/116799-ivy_carrier_board_datasheet.pdf
Assisted-by: LLM
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin-ivy.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mm-verdin-ivy.dtsi b/arch/arm64/boot/dts/freescale/imx8mm-verdin-ivy.dtsi
index 29075ff5eda63..b64751aa31d50 100644
--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin-ivy.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin-ivy.dtsi
@@ -270,8 +270,8 @@ &gpio3 {
 		"",
 		"",
 		"",
-		"DIG_1", /* SODIMM 56 */
-		"DIG_2", /* SODIMM 58 */
+		"DIGI_1", /* SODIMM 56 */
+		"DIGI_2", /* SODIMM 58 */
 		"REL1",  /* SODIMM 60 */
 		"REL2",  /* SODIMM 62 */
 		"", /* 10 */
-- 
2.53.0



