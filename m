Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D6A21D00A;
	Mon, 23 Mar 2026 13:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274112; cv=none; b=pDcn5SVbUTPTKnRmHqbEmrZn8lcucoxw3B4/CrZ5aiVC2/sBY3HimldAVy2fXKCsvaOXJMHRSQSh+iH1gzsFWeTpNCoD5aDkb/M8jb2IEGo6rqf8KXgfrwMONYj4tKsXqZ2gjgSecNazKKLuBcg3YE55WfITivsTM2A0Bm8DXOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274112; c=relaxed/simple;
	bh=+Le1MsX4y863X0slZHAB3Dj5aQyThl8mWw8BfN2meAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eAqgNlgxWdzeRkquB1vTYqzzBu03vnG6vfhIOylFrqE4uKeHkEA5Fg9Q4mml2ryCxiqJJNxe3K5g+J6/0ii6fnM8kpcE+8QOiqkDdezCFouVrbXyA8b9H4ScsnTmnsf5FW8vir9HpgrmcjCys3McngF3bOJtBVqZZYfwRMo2Y+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2AqKPTiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2AqKPTiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20C76C2BC9E;
	Mon, 23 Mar 2026 13:55:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274112;
	bh=+Le1MsX4y863X0slZHAB3Dj5aQyThl8mWw8BfN2meAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2AqKPTizG1blU+IZappM1RnDAVw+b//Nk56oD0OvCdpgTI4PScKLU1hDTAuEoHhkn
	 jqnsQMjBJvbqrcemWmPRVOSU+49CDdyaWXsSlp8VVKNfEF6nEjbmfg+213bKcr+OUC
	 v8lADohG2XI89U0/lZ5b7O4NrriApov8kiWueCA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 112/220] arm64: dts: renesas: r9a09g087: Fix CPG register region sizes
Date: Mon, 23 Mar 2026 14:44:49 +0100
Message-ID: <20260323134508.137845103@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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
index 361a9235f00d9..46f2b1fd98dc3 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g087.dtsi
+++ b/arch/arm64/boot/dts/renesas/r9a09g087.dtsi
@@ -750,8 +750,8 @@ mii_conv3: mii-conv@3 {
 
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



