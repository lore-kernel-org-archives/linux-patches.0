Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024741;
	b=ULC1lnzP6aHATkmsiattHyFsOxpFPFx8t2f1Ip1TZOP9v4w+Fo7uJrUs94wZMuucOBQX
	 zw0WcbSCaaf34vxF3K+fI/FQcTG3Ojz11u8rdO6LTCYMLWLWNmkzEgbpIpVcmqPVI3u/k
	 4izc6mIHfMeThO+Z+VPcFTg+OoaCEYKYOj1OsFuc/Vam43WcZKrFVB9ePDxTvwPsFGCcP
	 L1p3R5ANfPaJJApa2KcG7MrNrBn1/d2tvbjuUoQvvyo5DVt7n4E+xn0609IKy42bOnGeY
	 VNxfr80IPstgaPv5qmUcQAwK1Pb2nPAmzWxHuW/ah3mHi04eRlwZ/AGCgrxK3V85cmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024741;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mREouZplQNDXaM8iNInduog1djCs2q3ig2htear4SDo=;
	b=HFaBHIUrttPDK30LY36/NgaJcZHcIPwER/CemCbkn3T7yvKMVqdtA+lucbTZtyrjm1PC
	 dyrWwSnqCJhPXPmRY0cUJqMyh/egFOTfdFmROfRW4vJddTPaqCw4XalIUzdmcy2hDQO8U
	 gLUdpuUgmzay7Dwvo7EqOkQWhv0udvwPOKIyyoVWulVbslG9KHOVN/AZJhtrTTWKPn4nP
	 07TLm5fLuMI54xhO/cNGX7yuSVbvHQ/1tbD66sQbAi1L/wOnUv8LTJbaGXSouYlgMSIEP
	 BQidojO//9WW60XAR3bnxLYH9ZX0a2N1GpFF0H8cSSs3goPV4P3sh0Z9/i9I+AuQU0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tv+fbKWU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7ED606A33E;
	Wed, 18 Nov 2026 17:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tv+fbKWU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43231F000C5;
	Wed, 18 Nov 2026 17:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024741;
	bh=mREouZplQNDXaM8iNInduog1djCs2q3ig2htear4SDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tv+fbKWUPfoJXdzH4nSh75cumPd2isaR887i83vGQfr8qICFRvUuVh9OnkE9cakba
	 Z/pSxdxRFeFQEP59LgIfafY/ptBq6vmDvQWYUomP0+ir8MUSUu3tgmKsxm7Wo+MmRY
	 zLWpzseMZPRAUZURsayh90lLScnvV4tERlvTk06E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0834/2151] arm64: dts: ti: k3-am62-verdin-ivy: Fix main_gpio0/main_gpio1 line names size
Date: Wed, 18 Nov 2026 15:42:49 +0100
Message-ID: <20261118150152.590410241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 71c29eab0eee7..a07d37b87ecbe 100644
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



