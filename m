Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064119;
	b=deVxbld+50KHoUE4sEeWrH/WQEpZFSLmUwM8y17J4+NeM5l8eyfCJm1rqozvdSL4gIqn
	 XgeAwO6hGsgi1sXQVnXvxcolts/IZ164EaOrhRoGzeyzHerGtw2tW4P9ccsVVlsUSH+7N
	 cT6CeFhsRkf1CGBUK2aDKOrD9OX57azSy6nW+i1Cv1uBv614zLJpdpyiPlwPNaJWaibRm
	 0hskV5+XcNOWBzu4Itt4in3g8ievMIoWT7vYbCM76fPp36C+o/MrT8tBBiSk+Y4xmvGJG
	 I2/lop+abwcOtUWXkGSDVklBF4SoyD+/kW2YnQY8xzTasr8l1y8dGW6o2BAN39kvTfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IPwHsI894oFKbZkqO8ovSXLaz1aReSSi9/8WgiCojUE=;
	b=SyX6tNQBliMRT7cTMRhfsCJizELeakLMQoYifQMiTNqU/OIeNtvd9d1uS6SNuKiu79KI
	 9Y8CwJbrOpzMQXzQTuoAMKRTLgTL7EOe9wnP+J6fzK0wMSwLJVPv8064S7QM5Pu9Qtpme
	 TbzhryMkD0V9V5ZOM66m04pF5desuVH0IFsZBv34Jl0Vlfrn8iJqi0x0scrR8RCsqj1fn
	 HtbE/sCNVFz6JxelyT5F+/iECbKIOI9isDYmonOow2qK8yp7myE8dEfY0V95a526Onzii
	 Gj/CzaqZahQ6nJK0CMumhU6UiyyxRu1ub5Z5XMKlzlPkeGj+h6AekpaULRU6AnRW1ww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UF7M7SJQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2BA606E8C2;
	Sat,  7 Nov 2026 15:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UF7M7SJQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BAA1F008A3;
	Sat,  7 Nov 2026 15:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064118;
	bh=IPwHsI894oFKbZkqO8ovSXLaz1aReSSi9/8WgiCojUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UF7M7SJQZGcZcpyodm3t3uWvqIAQRYYciwljYMj1qbzmDbOCoWSPnFmReJOKtPDUc
	 xLYGEsmxRtYyHsqE9h/TFm1+6d3VOKI8+lFGYLa2jB4unlWRwMXYXtIn5OfLu8Mmau
	 URSjeAy3YuDwXwKxXI7yUPGX3177zg6cAiL1eu+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0275/1257] arm64: dts: freescale: imx8mp-verdin-ivy: fix DIGI_1/DIGI_2 gpio-line-names
Date: Sat,  7 Nov 2026 08:42:51 -0500
Message-ID: <20261107134947.076567217@linuxfoundation.org>
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



