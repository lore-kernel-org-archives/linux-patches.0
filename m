Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062962;
	b=Sj1NEl55ZeSHiqlBGi8LqOUzC9cCV/EL/4ovQvgB6500TLFkWgbGPXnnfMqnbE/8q0LQ
	 WYbpMtwAbhRgz+IPdoaItIuO3A7GsNOTqN/0hA2Gw9rvWztM3WPGy28v1UMhCzDqr+uVp
	 0rrcZzf2NXvi1XwifRLGIQ+hC2wyZpt5UqbJNqhk9xCs3FL43UIR5CUzCu8kSFgXNribd
	 MTuYwSSfSmgGYSbgKbX5uEqnLm0W92OLcbfeFo7aj8utLjC7M+mm3rqfn4d6N/GEAZGQT
	 iYuGYH+0jQoU1/lxDDjBTaUUkw1Ratvb6L/Bc1t7FEwRVrXI4phFw8GFkMtgwEayLhA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cm8vcgXtY+hqB686Iqg/RblebZJDaY92rb2wNzCknVo=;
	b=c2NhLaP9fo7qNWL64/RUT2IGHQO5ozrVfd873ao3mXytRbGm92cNKT4feTizNig4kfZA
	 BUct8Q21lEOqLtWVRIJ+WAFQuGOFGgSL6NN2ExDiR3bKKnoKdnyO/9YaZtQOnJH3boqkB
	 rskdFfK9CQfkfCchksB9nrkWW0DjM+FVMEPmiba49Gwkv93yjVN9iU3tOBjL1vzc/qH3B
	 /+LU5Y4NRQwkquSBHfTFkvsAOE2AK894KUA5LBr16c7oDHIDHtaGIO3kLSo20imEodV0O
	 hPeKs+C/0SlGa6I7PSBh9MTStT4xUQ8xzIKrNqDu0HCQ5dpAcvTc9ULriEX95ENwTgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZ0NdCN9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FDC4606A330;
	Sat,  7 Nov 2026 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XZ0NdCN9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A38B01F008A2;
	Sat,  7 Nov 2026 14:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062962;
	bh=cm8vcgXtY+hqB686Iqg/RblebZJDaY92rb2wNzCknVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XZ0NdCN9E9Sisq14KuTRHWUi4zmx52+sbGvVS0IV5XL1tAO/t6yoIaT6qBq5SYaVm
	 M7i2cVPzeYvBFO4bWxQ12CRMR3G7YD0qtPfimVl80MUl2HRN3Gy5Mnv4dXOJSRi4J1
	 YidoqlQnFS4U9+hnJJPuT6uZVJ/xgNhJKBVRmWrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 223/869] arm64: dts: freescale: imx8mp-verdin-ivy: fix DIGI_1/DIGI_2 gpio-line-names
Date: Sat,  7 Nov 2026 08:48:25 -0500
Message-ID: <20261107134859.451079578@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit cb45264c27fad31f7c58fbb1a5c2f7ec16018dae ]

gpio3's gpio-line-names names the two Ivy digital inputs "DIG_1" and
"DIG_2", while the official Ivy Carrier Board datasheet (Section 2.10,
Table 12) names them DIGI_1 and DIGI_2, matching the
k3-am62-verdin-ivy.dtsi variant for the same carrier board pins.

GPIO line names are meant to be stable across the whole Verdin family
and its carrier boards, so userspace GPIO tooling that looks up a line
by name works the same regardless of which Verdin SoM is fitted on
Ivy.

Fixes: b98948b04295 ("arm64: dts: freescale: imx8mp-verdin: Add Ivy carrier board")
Cc: stable@vger.kernel.org
Link: https://docs.toradex.com/116799-ivy_carrier_board_datasheet.pdf
Assisted-by: LLM
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-verdin-ivy.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8mp-verdin-ivy.dtsi b/arch/arm64/boot/dts/freescale/imx8mp-verdin-ivy.dtsi
index db1b4ee7728c0..bf021e85cfc94 100644
--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin-ivy.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin-ivy.dtsi
@@ -333,8 +333,8 @@ &gpio3 {
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



