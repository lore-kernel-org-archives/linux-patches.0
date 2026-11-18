Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017700;
	b=SVdLI8nU3tEMxlv1iZVrwCtUmlSQeDM6ox2bjUULUNjikZCK161LhEUwwA/XDlWhciTV
	 3W1V+JFAoe/kC2Ire4XCoUApsPsbEH5o4mRAF79DS4zrCgpbjzTwjEmEd/EuDbBiE1Slg
	 3qd07u5x09c91tOxuHTj1IPXM9SAIpYOpCypNiFLS3ptuy8pAKGLI3G2WfEkVYIXh8xoz
	 gEJj13GhIkogTn6I56vHTt/H5bCSMDwJCdDuj2Ac11SJWu1i6t72S09aYUCnckowk8Glk
	 5QI1j9j4x5ptqXkRVdqr+zfIeDbSazWcbVj1FU9kWOs0CTsnRT2ifigFM/XJEEUqAqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kqNnNWJI+44YLQ3oQNjsKQ2ydIvhKlWnOAahQFGDsX4=;
	b=RDLlvjfPXyzNJQAnmnyX4oyhxL4WVK3e7mc1ZVqBjnBeUNY+LBr4M03ed1iwIyg8lznP
	 cEybC2+49prY+jBQLm94W8bT2AejlNOhYsCsaC66Da3Qyh6989ToXgfa0PCSBLdkP9H3Q
	 QcA3cgMcuKYJ48dOHWoZ7xsfsB3kACnJlg+64uAkquS1IibocdKZvUkg5UiDz4V0z8uMg
	 O/yTfQ3TuO6OJk8JnKrNckX5bo1cP5eFb6227AhWnTPaJIgTjpTp0MrAIATCndU08hPGt
	 8++dpnYg+ys8vVBlycDlxTzKQC3krqQCkm4H3rA5pxd0atQe8gpw2VE8Sd92FmT6iZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="aQZ/4X6T";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1ED606A31C;
	Wed, 18 Nov 2026 16:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aQZ/4X6T
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75DC1F000C4;
	Wed, 18 Nov 2026 16:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017700;
	bh=kqNnNWJI+44YLQ3oQNjsKQ2ydIvhKlWnOAahQFGDsX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQZ/4X6T1wpolkaiYy+kyDyWCFQrI6irOVcEV8exGl1hTvepIGLB0yJRXe3d/gCaq
	 LvGgb++MCnollLIhBG/pCPUAzeskBBYFJNV4Zl2oVVrSkfRphioeDUb0fPkhA3roAd
	 tBkf6vWPrmomfWDu/GRSpQ1g/yQSI14D1+dhX95k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0978/2651] arm64: dts: ti: k3-am62-verdin-zinnia: Fix main_gpio0/main_gpio1 line names size
Date: Wed, 18 Nov 2026 15:36:58 +0100
Message-ID: <20261118150323.108801708@linuxfoundation.org>
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

[ Upstream commit 9dd7a67b29e0d49c66c4785014ac3befb086fbfc ]

zinnia redefines gpio-line-names for main_gpio0/main_gpio1, sized
87/88 entries instead of the SoC's actual 92/52 ti,ngpio. Resize both
arrays to match, keeping every existing label at its original index.

Fixes: 4abc2f22e469 ("arm64: dts: ti: k3-am62-verdin: Add Zinnia")
Assisted-by: LLM
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Link: https://patch.msgid.link/20260922152551.270845-3-francesco@dolcini.it
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/ti/k3-am62-verdin-zinnia.dtsi    | 41 +++----------------
 1 file changed, 5 insertions(+), 36 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-verdin-zinnia.dtsi b/arch/arm64/boot/dts/ti/k3-am62-verdin-zinnia.dtsi
index 0ce8357797ed7..f399764b05cf1 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin-zinnia.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin-zinnia.dtsi
@@ -274,6 +274,11 @@ &main_gpio0 {
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
 
@@ -330,42 +335,6 @@ &main_gpio1 {
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



