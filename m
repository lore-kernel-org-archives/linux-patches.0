Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A9291FCCE5;
	Fri,  6 Dec 2024 14:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497056; cv=none; b=jNHlR9aGvfzMbPlJCI4SuF8mNUEY5whqBluJ2HkYXJ4wwuSg5wqssoVekLIBbLbKQkJ2odQ/XyIWZ1F1Ld9cTPLMnkXqBdtFEFqFa7bLngpP8qo07CCOexZk7GdZefMAw16yz0sLjzEqCIT0BswZbuvIQ/8TUl95Y3fKusCXklE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497056; c=relaxed/simple;
	bh=Nuim2lq9JfEmfRSyyuhpIAcGMa0xMiqQyg0j9OGQSIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBAmCXxRDeE1SAOmOERxrb857rNVR7uVx/AppMrrO1ZCFbrtnP9go7owQALGr9+0seH5IZR+LcxQzH34m8YQKElhDzJx0DGzWGE0A07iCDErMozZxNlraTNDw3LhfJOiEkyXV52WOg3GpgE+kbUAYp25w5PHw3xDnRY+edlMfkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTT5vY7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTT5vY7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD5AC4CEDC;
	Fri,  6 Dec 2024 14:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497056;
	bh=Nuim2lq9JfEmfRSyyuhpIAcGMa0xMiqQyg0j9OGQSIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTT5vY7x931xG3dnHgtvYRI3fXbWGzlGCEnQJQR8hRToWKZGSNcERu/YPGBHuwkgM
	 HQAplEq1ftZCiMWbgffcCcLVQuPcmidMK5YDS7MeYmICEtJ6jhFNcYSwjfn8if4hu5
	 reRg+qVaTwXRZCLej7pIklVDSjRGDNfEfgBF17lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 150/676] arm64: dts: renesas: hihope: Drop #sound-dai-cells
Date: Fri,  6 Dec 2024 15:29:29 +0100
Message-ID: <20241206143659.209967782@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7fc0339a3ac97..e59191562d06c 100644
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



