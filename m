Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC61233FE;
	Tue,  3 Dec 2024 15:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238198; cv=none; b=bphFG4dEoDS3+XpLipxR/dBasv28QvENu2+iNXtedodyilhwngm8DkIQxAWaMIQqkbecmukU6d5iHqmBLEo2SX8fgABIjg3IQE+98CX3codidB6YLLng27Ym7GFe+2mNwk+gF6bx56FpafoPK7yCdgQVnemaTCnvn7992HVqroU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238198; c=relaxed/simple;
	bh=Rc3KydQtoykGm/n2lRNvQXMhMGTd/Cul19dPgtCiwSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QjQzpYqLkWPVZt9oe9Vf4mhdac3NH+KxJtKUcTEH/pER+mUGsz43MhAA63eaQZzxulaVyEY5udiu8y6wLfWBk6oaTbLMhYVgFlVcA3jA7vcNpCHkiPfKrpOuLBZCfJoNimKfusbSRmk8P44USGlYuhqmCQQ+QHjHS3Y1qv88bag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q1A1zg6Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q1A1zg6Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39947C4CECF;
	Tue,  3 Dec 2024 15:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238198;
	bh=Rc3KydQtoykGm/n2lRNvQXMhMGTd/Cul19dPgtCiwSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q1A1zg6YKb/9EH2XrWH+1lveh08mYYMKNHDBFC2KUU4GDKUKDcKnRShrgcd9RzzPV
	 eCZi5fRrQdbzvV5ElhSMc76QJvwdiF7k475TGa1NRopdDV5qEDnOUH3k91Ojev5pKh
	 +7ixocsDa+r5ceC25CWWHsAsITbXUDnGo3SvfYXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 195/817] arm64: dts: renesas: hihope: Drop #sound-dai-cells
Date: Tue,  3 Dec 2024 15:36:07 +0100
Message-ID: <20241203144003.350855838@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 9cc926e3fab42dd292219796cfc94e41f4ab749d ]

"#sound-dai-cells" is required if the board is using "simple-card".
However, the HiHope board uses "audio-graph", thus remove the unneeded
`#sound-dai-cells`.

Commit 9e72606cd2db ("arm64: dts: renesas: #sound-dai-cells is used when
simple-card") updated the comment regarding usage of "#sound-dai-cells"
in the SoC DTSI but missed to remove "#sound-dai-cells" from board DTS
files.

Fixes: 9e72606cd2db ("arm64: dts: renesas: #sound-dai-cells is used when simple-card")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Link: https://lore.kernel.org/20241010135332.710648-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/hihope-rev2.dtsi | 3 ---
 arch/arm64/boot/dts/renesas/hihope-rev4.dtsi | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/hihope-rev2.dtsi b/arch/arm64/boot/dts/renesas/hihope-rev2.dtsi
index 8e2db1d6ca81e..25c55b32aafe5 100644
--- a/arch/arm64/boot/dts/renesas/hihope-rev2.dtsi
+++ b/arch/arm64/boot/dts/renesas/hihope-rev2.dtsi
@@ -69,9 +69,6 @@ &rcar_sound {
 
 	status = "okay";
 
-	/* Single DAI */
-	#sound-dai-cells = <0>;
-
 	rsnd_port: port {
 		rsnd_endpoint: endpoint {
 			remote-endpoint = <&dw_hdmi0_snd_in>;
diff --git a/arch/arm64/boot/dts/renesas/hihope-rev4.dtsi b/arch/arm64/boot/dts/renesas/hihope-rev4.dtsi
index 66f3affe04697..deb69c2727756 100644
--- a/arch/arm64/boot/dts/renesas/hihope-rev4.dtsi
+++ b/arch/arm64/boot/dts/renesas/hihope-rev4.dtsi
@@ -84,9 +84,6 @@ &rcar_sound {
 	pinctrl-names = "default";
 	status = "okay";
 
-	/* Single DAI */
-	#sound-dai-cells = <0>;
-
 	/* audio_clkout0/1/2/3 */
 	#clock-cells = <1>;
 	clock-frequency = <12288000 11289600>;
-- 
2.43.0



