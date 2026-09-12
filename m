Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978D83876A7;
	Sat, 12 Sep 2026 07:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199150; cv=none; b=u3FH6hAzkGuyoJ3SAc+AF8cW5nDCzwwR2At27p/hvFGte/MOaNc1izPpZZBsdgBY5fKC54VKPE/PJzZklpbN3Ukr93KbPsq5JS23UdoCrEGqKl0XCgIzmpvskK4NMitqxwNlbdT1qCk0pFix7NeGu3w0ZMd9aWC7nFlBrdRmm1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199150; c=relaxed/simple;
	bh=+9JFEb88etWVw7nlu3ewQdP7j4/2upqIPMd3zmGVP3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tTKcbJWanyTTy/4pP0xj5wx9+xruhv3aFE1dcB/NHymrBjWZNtvQmB393zA1E6nDuFD/RQ7QJTWuN9vKsdz7+HXi+E6nuwQwrqZFEcBJ42ZgZ40MVQJXnhnFlY6c1Z9AwEQ3nj1yp+jA0tBVV3EGVcSDkfbAQz3tRoWqxg+SAxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=piTXfUDa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="piTXfUDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8971F000FF;
	Sat, 12 Sep 2026 07:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199144;
	bh=EumyAzy+lEpRt5hNz7qoQISpspMv2TUgpCEHArt7ALE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=piTXfUDaxKWhEaH3gBGKkUgP7NGUK2KcQuNVtQdu7ioYJHo+DxJnR6GfYhNeeGL25
	 Jp0mipInLZWEZY4sJLPkucg/8dRqJbU+4tvth3c5ixHNWJWdpnpkO04LF+x9W0TV41
	 7iz7+FcqJmrMPXHqrLI5OWyrFERO3OIh71wo5MUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0525/1815] arm64: dts: qcom: glymur: Add CX power domain to GCC
Date: Sat, 12 Sep 2026 08:37:55 +0200
Message-ID: <20260912065701.216249893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abel Vesa <abel.vesa@oss.qualcomm.com>

[ Upstream commit 2edbea82d8edbddb2a235b8f988f17b86f075476 ]

The GCC GDSCs on Glymur are backed by the RPMh CX power domain. Without
describing that parent domain, consumers of GCC-provided GDSCs can enable
their local domain without causing the required CX vote to be held.

Add the CX power-domain reference to the GCC node so votes from GCC GDSC
consumers can propagate to RPMh CX.

Fixes: 41b6e8db400c ("arm64: dts: qcom: Introduce Glymur base dtsi")
Signed-off-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260715-glymur-fix-gcc-cx-scaling-v3-3-72eb5adad156@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 02bd6dcd99579..009424594c947 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -797,6 +797,7 @@ gcc: clock-controller@100000 {
 			#clock-cells = <1>;
 			#reset-cells = <1>;
 			#power-domain-cells = <1>;
+			power-domains = <&rpmhpd RPMHPD_CX>;
 		};
 
 		gpi_dma2: dma-controller@800000 {
-- 
2.53.0



