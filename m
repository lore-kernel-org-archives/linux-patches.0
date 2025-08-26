Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55EED32144B;
	Tue, 26 Aug 2025 11:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208333; cv=none; b=pG5ie51DAuDjEo9uk3wy/0Q2AsGgiogA+rOH7maZRgHBZZV+rl1DHeCGUy9qRRy0qLhjUPzEU+Uu6MaoG3C2McBy6TvN+RhahaHDuCCYXIupUhEKQ/XVrVJaVFf3EOYMYm0UNs8rkL4g3WWbZfyQZfMzrNmaLzJ7KmOo9VJA5VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208333; c=relaxed/simple;
	bh=n7Xx6eUvvD14cThD+oBujrd+OMuEIDiiFpztLRkwIBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CyKau4SOO24ggBWu2VGUsYEA9WB46rLvs8blA73osw+zeSY8DT800miWLOm7r/Rldepa8SelWeoY8ItEzqew1+tpxuffHg+Bpv8brdFWa0JI3B5ectTswkFgTSM3W5YEHqsIuEs+of3PgDSeh8ue4i+sseca4kOjHqIn0OjkIvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q7Ddohx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q7Ddohx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF26C4CEF1;
	Tue, 26 Aug 2025 11:38:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208333;
	bh=n7Xx6eUvvD14cThD+oBujrd+OMuEIDiiFpztLRkwIBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q7Ddohx8E4txT13gQOoaL9S9+9qRydLTjCz7kgMmvRQZ0O67yxufi+dWg49SqzFmF
	 MmsUjmz+asWBRjOtPT7oBeHAnPtLJS3C+brbJYQcM0SzEt0Evk9h1TF+cdWl+8QtKt
	 4VZhapH59Y/u+DcktSzbo8PkifoIEYQtU+aTS+I0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Vignesh Raghavendra <vigneshr@ti.com>
Subject: [PATCH 6.12 040/322] arm64: dts: ti: k3-pinctrl: Enable Schmitt Trigger by default
Date: Tue, 26 Aug 2025 13:07:35 +0200
Message-ID: <20250826110916.360315497@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

commit 5b272127884bded21576a6ddceca13725a351c63 upstream.

Switch Schmitt Trigger functions for PIN_INPUT* macros by default. This is
HW PoR configuration, the slew rate requirements without ST enabled are
pretty tough for these devices. We've noticed spurious GPIO interrupts even
with noise-free edges but not meeting slew rate requirements (3.3E+6 V/s
for 3.3v LVCMOS).

It's not obvious why one might want to disable the PoR-enabled ST on any
pin. Just enable it by default. As it's not possible to provide OR-able
macros to disable the ST, shall anyone require it, provide a set of
new macros with _NOST suffix.

Fixes: fe49f2d776f7 ("arm64: dts: ti: Use local header for pinctrl register values")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://lore.kernel.org/r/20250701105437.3539924-1-alexander.sverdlin@siemens.com
[vigneshr@ti.com: Add Fixes tag]
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-pinctrl.h |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/ti/k3-pinctrl.h
+++ b/arch/arm64/boot/dts/ti/k3-pinctrl.h
@@ -8,11 +8,16 @@
 #ifndef DTS_ARM64_TI_K3_PINCTRL_H
 #define DTS_ARM64_TI_K3_PINCTRL_H
 
+#define ST_EN_SHIFT		(14)
 #define PULLUDEN_SHIFT		(16)
 #define PULLTYPESEL_SHIFT	(17)
 #define RXACTIVE_SHIFT		(18)
 #define DEBOUNCE_SHIFT		(11)
 
+/* Schmitt trigger configuration */
+#define ST_DISABLE		(0 << ST_EN_SHIFT)
+#define ST_ENABLE		(1 << ST_EN_SHIFT)
+
 #define PULL_DISABLE		(1 << PULLUDEN_SHIFT)
 #define PULL_ENABLE		(0 << PULLUDEN_SHIFT)
 
@@ -26,9 +31,13 @@
 #define PIN_OUTPUT		(INPUT_DISABLE | PULL_DISABLE)
 #define PIN_OUTPUT_PULLUP	(INPUT_DISABLE | PULL_UP)
 #define PIN_OUTPUT_PULLDOWN	(INPUT_DISABLE | PULL_DOWN)
-#define PIN_INPUT		(INPUT_EN | PULL_DISABLE)
-#define PIN_INPUT_PULLUP	(INPUT_EN | PULL_UP)
-#define PIN_INPUT_PULLDOWN	(INPUT_EN | PULL_DOWN)
+#define PIN_INPUT		(INPUT_EN | ST_ENABLE | PULL_DISABLE)
+#define PIN_INPUT_PULLUP	(INPUT_EN | ST_ENABLE | PULL_UP)
+#define PIN_INPUT_PULLDOWN	(INPUT_EN | ST_ENABLE | PULL_DOWN)
+/* Input configurations with Schmitt Trigger disabled */
+#define PIN_INPUT_NOST		(INPUT_EN | PULL_DISABLE)
+#define PIN_INPUT_PULLUP_NOST	(INPUT_EN | PULL_UP)
+#define PIN_INPUT_PULLDOWN_NOST	(INPUT_EN | PULL_DOWN)
 
 #define PIN_DEBOUNCE_DISABLE	(0 << DEBOUNCE_SHIFT)
 #define PIN_DEBOUNCE_CONF1	(1 << DEBOUNCE_SHIFT)


