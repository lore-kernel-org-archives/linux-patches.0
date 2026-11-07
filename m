Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062960;
	b=GqQQkYQL2culpFoO2fhS5ueNeK3fLRRyhB5nHRAa7kp39iN8qHgwjflgARSiLaQhNpqB
	 JPja0zMvi9HsTJU21wnp8+8LaERHceCWmrgMZvtMkKdeS8h+rlpg/IleEQx7T2gRVhG/A
	 kq0k723NoGx/q+xhuasXdR7iZQqq5tWw5EsS6f62SzfZ3eKnRaQNKlQCvR7OhxG/6vHai
	 5oimDGBNuY07c89GebnCCxHJpK0sF18u+xz+xN7lX4+hdBgi+Zt0mRq7kMQ1ZIThXNN5t
	 hJxenY8yZ9nglA4vnPayMGAi6epR70uiAyPS7x8J8y0AQshXbq60R3FhfEiNyZabdpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062960;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JOmGuO4L5CZ3zMB1xOEThjThyiYWcmZKL7OwFL9ca3g=;
	b=ypgTw5/o7Nrk5O8aQ6IXFq/tDmO0N99y+D5tfGi2xad0wXEvG5zgO21F/j7r4R7qXIhs
	 A0cqQv48PCN+UBTM1jPiIgH4CdcAvIFkTzORTmeim2TDCD+Q1nBPu+yb8taJWU+nbNRxk
	 maYsU2pQNc5Wudo8AlS8tVbnFH5/UF5TXTXBLYL62y3e2wTbpw9MqGDw15S3XHm+bm+FA
	 KBJp67CC1pNwmnUEtUhBpiIJZWLmC2AFALUrthLkTUZqpGlDd4rUvTVYxWH5OZsoYAFfV
	 TmnFgg36ohj3W3h9KzhpfK7slWziDL1aKgLZq0ogRTpzoZNMQsP7aOofzJISt424VyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrdLtF0s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97516606A33E;
	Sat,  7 Nov 2026 14:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MrdLtF0s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05FDA1F008A2;
	Sat,  7 Nov 2026 14:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062960;
	bh=JOmGuO4L5CZ3zMB1xOEThjThyiYWcmZKL7OwFL9ca3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MrdLtF0sUcI/ZvVm+fvR3lPQupxbuU0WZSueHdqVIcm+krHkZ1ky38MuPfVo8dTwV
	 QLod8It8kiv0t4pws+MCAKRRlyfS+5QYaKeDRX3zV/OoNgOPVV+02WxwHR620xQcCU
	 1pKDuVlj18dPWyr3zXBagj3N1fagzgRMyT+sSJ/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 222/869] arm64: dts: freescale: imx8mm-verdin-ivy: fix DIGI_1/DIGI_2 gpio-line-names
Date: Sat,  7 Nov 2026 08:48:24 -0500
Message-ID: <20261107134859.423676441@linuxfoundation.org>
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



