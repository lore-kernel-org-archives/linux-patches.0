Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692641F91F6;
	Mon, 23 Mar 2026 14:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274817; cv=none; b=AsTGOF8bzRJDpU9bTZYGdGtxlESd0hxM3rgJ/LJbwiDdxBd9G3JI8FtOCZE5DvUZ0sJyN98bRV3uLgFivSHgCKIPj+Z/mCb7gPREmt6ylqcTrPrB7qLtmOxqQfkwY+JigWaFAv/iS1SlvbGIqJRcDKY4eko0FS3Mo2OYk2L8ogg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274817; c=relaxed/simple;
	bh=28SU7CkmfCX36M+nbNeoMVdZHH+alPU8wkHK9E4BNFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jxw/sWcob96TewIFd+Du9aN1vTjp2f6uNEUqXMq/KU+Q8OV92nf9D3hnHYRgbWODCKkroA56jxk8U31MO3/VRUrhY+HyP1WiBYpYnaXPv3zTRwjrWQ5H4aJ8yKobiSa02wcxFIMjlYq7VJzGdfGDOkrxAIek3J60NGFDlHE52y4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+ZpTguk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+ZpTguk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA15FC4CEF7;
	Mon, 23 Mar 2026 14:06:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274817;
	bh=28SU7CkmfCX36M+nbNeoMVdZHH+alPU8wkHK9E4BNFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o+ZpTguk9bue4srbZZXoCQIL9TWkQN8tlZci1NTNd03zy9iuvJm4xUBU1qlR3NofN
	 gWk9pq+vVqHkOm/0bV02Lu1mVyLufZly1bPOtYt3XClOxY2tgLEu/Lv+vbq+6s2pZt
	 UD3h0HyV5HG1kHraAGhAkOiCEz+cEIESPbhjbARU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/212] arm64: dts: renesas: r9a09g087: Fix CPG register region sizes
Date: Mon, 23 Mar 2026 14:45:38 +0100
Message-ID: <20260323134507.472171257@linuxfoundation.org>
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

[ Upstream commit f459672cf3ffd3c062973838951418271aa2ceef ]

The CPG register regions were incorrectly sized.  Update them to match
the actual hardware specification:
  - First region (0x80280000): 0x1000 -> 0x10000 (64kiB)
  - Second region (0x81280000): 0x9000 -> 0x10000 (64kiB)

Fixes: 4b3d31f0b81fe ("arm64: dts: renesas: Add initial SoC DTSI for the RZ/N2H SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260213131742.3606334-3-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g087.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g087.dtsi b/arch/arm64/boot/dts/renesas/r9a09g087.dtsi
index f06c19c73adb8..6dd80fa2755e8 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g087.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g087.dtsi
@@ -267,8 +267,8 @@ i2c2: i2c@81008000 {
 
 		cpg: clock-controller@80280000 {
 			compatible = "renesas,r9a09g087-cpg-mssr";
-			reg = <0 0x80280000 0 0x1000>,
-			      <0 0x81280000 0 0x9000>;
+			reg = <0 0x80280000 0 0x10000>,
+			      <0 0x81280000 0 0x10000>;
 			clocks = <&extal_clk>;
 			clock-names = "extal";
 			#clock-cells = <2>;
-- 
2.51.0



