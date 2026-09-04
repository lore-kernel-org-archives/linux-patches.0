Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7174419FB0;
	Fri,  4 Sep 2026 05:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499480; cv=none; b=O/6z+g3qvQupnS78ath4t0wn+HcnWkdDZ3jpN2TvyR6xKwlwygIEaXl7id4FOI7pinYD2lvZiTRuKQVA0QHS4kgrWk11eUrocaGv5lVnuksBhzcDxmnqI5iGWYy4je+4OMfG3ZcEs/A5y1qRAyoefLiBs33Z0KxcInYoUrWY1LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499480; c=relaxed/simple;
	bh=5TcEMd46vcGo9UiZDChTsH8NzybbWY6PcurM93fyE0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZsFtC/NAtrrcQhojVtCnb4D4EJzRCzHqSH6IKDlBaIvYoCizrrzyCw6IuT24iAiOjmnIBot3U6IprUOhoInhIATfG7l4uvwHltoxH9O0i5rLFs1Ch/1KGzgTMlqBJAkTiViPXf6bmosbXag9VG3LD3RR4k5BhfLel5ND/KVzFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cifwxdpN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cifwxdpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2E61F00A3E;
	Fri,  4 Sep 2026 05:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499479;
	bh=3zHeeIErBp9x9svOkpqVKdOckWLz+Dl65GVcZUl5WI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cifwxdpNwzMEn8RB24TIN8LZpVozLxzb/CtT4AxGb9ZaxEbpu2WxDac0nJOTHMN8q
	 juzWOxmpwgYquzvWQ+Na/b8igROuyPu5zQSj/0l2Ldh3LGD96BlwiK4nZKrASCF8BG
	 /yVeZ7heZMdsqNQF2zU5nGj2ZyHrXyMZr0Kb4hBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Yixun Lan <dlan@kernel.org>
Subject: [PATCH 7.2 431/713] riscv: dts: spacemit: k1-bananapi-f3: fix maximum CPU core voltage
Date: Fri,  4 Sep 2026 06:56:39 +0200
Message-ID: <20260904045813.489728145@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Aurelien Jarno <aurelien@aurel32.net>

commit b496282ee4ad07311a13489e15b74fb7078d9a01 upstream.

On the Banana Pi BPI-F3 board, the buck1 and buck2 voltage regulators,
which supply the CPU core voltage, are configured with a maximum output
voltage of 3.45V, while the highest operating point requires only
1.050V. This means that a kernel bug, OPP misconfiguration, or
privileged userspace could request a voltage above the safe operating
limit, causing possible permanent CPU damage.

Set the maximum regulator voltage to 1.050V instead.

Fixes: 09a412d39748 ("riscv: dts: spacemit: define regulator constraints")
Link: https://sashiko.dev/#/message/20260728211020.1248676-2-aurelien%40aurel32.net
Cc: stable@vger.kernel.org
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://patch.msgid.link/20260729150722.1598630-2-aurelien@aurel32.net
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
@@ -204,14 +204,14 @@
 		regulators {
 			buck1 {
 				regulator-min-microvolt = <500000>;
-				regulator-max-microvolt = <3450000>;
+				regulator-max-microvolt = <1050000>;
 				regulator-ramp-delay = <5000>;
 				regulator-always-on;
 			};
 
 			buck2 {
 				regulator-min-microvolt = <500000>;
-				regulator-max-microvolt = <3450000>;
+				regulator-max-microvolt = <1050000>;
 				regulator-ramp-delay = <5000>;
 				regulator-always-on;
 			};


