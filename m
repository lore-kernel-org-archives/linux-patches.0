Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 066513C07A;
	Mon, 23 Mar 2026 14:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274814; cv=none; b=tJ8WzxFHA8hRqG0YPqH+aO738Q/4LNfHCaF/DYBlJ9+FX1zjnRNZeZxxhFyJXl53B72RqhRFcYoqfu0AiROnf7BJirjXYuZCjK+lmz/6ljlhcDaH81EMVik+z1cAeiJf6/QeMfg8uinWLn4K68u7BO9RDraOqGw+S1/bhMvR4jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274814; c=relaxed/simple;
	bh=D1uUGmtj8V9X+/OWCYLh0/9Wsas++sqwxZHKRejpbBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ox7IJH+MOW0TciqcwC7GKLJWbnvFP10L8R996EtO+0trXqsk60t2iIyNUictJO9LPy5efTuEgH4m9PMYUtwjMzqwCE+UNpYH1xbm5qJhL3s45fAKM5KIRm9BZNaAysZgQYYz03FL2PSu2mNsZyUEMrm6Km4tsIjorPoCxZ3X+qk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uJwBXbtF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uJwBXbtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E447C4CEF7;
	Mon, 23 Mar 2026 14:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274813;
	bh=D1uUGmtj8V9X+/OWCYLh0/9Wsas++sqwxZHKRejpbBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uJwBXbtFb9RKreIGc+68pRfosqZuB3ctA7VsdBhNR/UonfZ6sr65JVBIaQRZBKKj4
	 /KClTDp8HXFGDOmomEQb7MLuNOthZLiTiXg+SCFQ3wKD1A4F4DddVftU5Rd7jtsRow
	 ugaeyhNi4ZJXynQAVQY0X9zbrOfiiq53ZNxIGlSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 116/212] arm64: dts: renesas: r9a09g077: Fix CPG register region sizes
Date: Mon, 23 Mar 2026 14:45:37 +0100
Message-ID: <20260323134507.444769517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134503.770111826@linuxfoundation.org>
References: <20260323134503.770111826@linuxfoundation.org>
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

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit b12985ceca18bcf67f176883175d544daad5e00e ]

The CPG register regions were incorrectly sized.  Update them to match
the actual hardware specification:
  - First region (0x80280000): 0x1000 -> 0x10000 (64kiB)
  - Second region (0x81280000): 0x9000 -> 0x10000 (64kiB)

Fixes: d17b34744f5e4 ("arm64: dts: renesas: Add initial support for the Renesas RZ/T2H SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260213131742.3606334-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g077.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g077.dtsi b/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
index 7f1aca218c9fb..06aae2c635676 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g077.dtsi
@@ -267,8 +267,8 @@ i2c2: i2c@81008000 {
 
 		cpg: clock-controller@80280000 {
 			compatible = "renesas,r9a09g077-cpg-mssr";
-			reg = <0 0x80280000 0 0x1000>,
-			      <0 0x81280000 0 0x9000>;
+			reg = <0 0x80280000 0 0x10000>,
+			      <0 0x81280000 0 0x10000>;
 			clocks = <&extal_clk>;
 			clock-names = "extal";
 			#clock-cells = <2>;
-- 
2.51.0



