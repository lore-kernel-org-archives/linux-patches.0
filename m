Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA091324B2C;
	Thu, 28 May 2026 20:22:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999731; cv=none; b=PJiHh03Slk9bmEUHvwlZJL/FQi6324BBarGLveRjXWhUZvpCP/alJ48Ls8yGzKZg0KR4zAq5v49uhyPqIMJmFClrPjoGE0l0JSFekMpBkIl3KErWQSb+BeB4J3AVtk8rzJ8rnvg9+7xLKV/aXqeiIPqXl48EHIEU909ip1sZ87U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999731; c=relaxed/simple;
	bh=nfTWjgukfUtGvYDhqO4akyow4WDKTRhDa+DSAdcz38Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hW0z4XKTVophxb2p4j9R7pqUDH3M3ucnGx71UU3BZslkA9xRkgsjGUdoojcymt3TuoE5f826wabDCcOUe+X19ToRl9mrWpaVqzSDyljNLBUTXPV5NkcWmbwmGzSVtorkvI80mDOgmoPozwWB40QKsX4dI/pKEUHljt1DgvotIEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mc5rMrb3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mc5rMrb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 531A91F00A3A;
	Thu, 28 May 2026 20:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999730;
	bh=2Fe+0yt1q6uX4qwrOzn8YJrR0kqW1tn2hhaLaspM+qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mc5rMrb3w8S1ckgwWjj9jnSZLHJby9e1sI9FSB3lA1KbfzHeSjBBHplOYtIBHRzub
	 bJw5nEDMlHSRJEBc0ZiWk1Xt8Yq+NVhZqG+MHhPPAZo1TRtqWKXt2xIgvcCxq6+GFl
	 h6GlksGVaBM3oDgmHU/elV7v0uydw7/WAKVGpAfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 171/377] ARM: dts: renesas: genmai: Drop superfluous cells
Date: Thu, 28 May 2026 21:46:49 +0200
Message-ID: <20260528194643.384597667@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 714e1d6bba0e0abe5c87c8e189a35fa690540df4 ]

Drop superfluous address-cells and size-cells to fix DTC W=1 warning:

    arch/arm/boot/dts/renesas/r7s72100-genmai.dts:28.17-55.4: Warning (avoid_unnecessary_addr_size): /flash@18000000: unnecessary #address-cells/#size-cells without "ranges", "dma-ranges" or child "reg" or "ranges" property

Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Fixes: 30e0a8cf886cb459 ("ARM: dts: renesas: genmai: Add FLASH nodes")
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260327234244.91707-6-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/renesas/r7s72100-genmai.dts | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm/boot/dts/renesas/r7s72100-genmai.dts b/arch/arm/boot/dts/renesas/r7s72100-genmai.dts
index 3c37565097145..da552a66615e0 100644
--- a/arch/arm/boot/dts/renesas/r7s72100-genmai.dts
+++ b/arch/arm/boot/dts/renesas/r7s72100-genmai.dts
@@ -34,9 +34,6 @@ flash@18000000 {
 		clocks = <&mstp9_clks R7S72100_CLK_SPIBSC0>;
 		power-domains = <&cpg_clocks>;
 
-		#address-cells = <1>;
-		#size-cells = <1>;
-
 		partitions {
 			compatible = "fixed-partitions";
 			#address-cells = <1>;
-- 
2.53.0



