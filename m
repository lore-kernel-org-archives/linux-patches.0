Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D8D61CF5C6;
	Wed,  2 Oct 2024 13:50:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877030; cv=none; b=AUxf+5gT/b+gzoFWhfDCrx6Ek4Jf+hHKfjToYFgdS2K32UQS4k6W+ZKEPcRGJX+r11rm1qoldQIbao2MQ+Q64Z7f8I9QF/tvOGyulclqL0VAXKoIdbhkiyiFtOwOZWrGwPPSIaKltvyn7IhNCUxJvEGZSE512jYy86J72ko7XZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877030; c=relaxed/simple;
	bh=ehjg21ZMC3q2FjoYc5B5Pv/7dGNJpwguAryZwbazHJE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=moXJdfzoGtb0CzNatlwQgNCZqDcALrR1z2MgWSnsib4pbUkSU5tB5bz/ys4AR/a/TOY7HXQ2r7HSO36UvMI20Ti20gQM/k0NfoqwP/Ik/oUBlggib3vzjwOu4Lhe2ZM4QXjXuyws5WKYw6Pv4ji3QsMrPit1HkwLU9F6DhUFK08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pX4sYDfq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pX4sYDfq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC165C4CEC2;
	Wed,  2 Oct 2024 13:50:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877030;
	bh=ehjg21ZMC3q2FjoYc5B5Pv/7dGNJpwguAryZwbazHJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pX4sYDfqzOq2uoAlq09gXR4r1QiDz4uT/zwL/DBfVEDnHo2InfGaL1IxRcOoxODwp
	 YaQ2Rpl3NhySkv0s4BsFZtlDDCvlqJJtDVxuNvjSCLL+4MvTqLAB0/PnEeFZVnZevE
	 udX+Ord4SYL4FfJGSw8i5KmrjHOJjCnLa65w3F7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Nebi Yasak <alpernebiyasak@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 6.11 641/695] arm64: dts: mediatek: mt8186-corsola: Disable DPI display interface
Date: Wed,  2 Oct 2024 15:00:39 +0200
Message-ID: <20241002125848.104641599@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

commit 3079fb09ddac159bd8bb87f6f15b924e265f8d4d upstream.

The DPI display interface feeds the external display pipeline. However
the pipeline representation is currently incomplete. Efforts are still
under way to come up with a way to represent the "creative" repurposing
of the DP bridge chip's internal output mux, which is meant to support
USB type-C orientation changes, to output to one of two type-C ports.

Until that is finalized, the external display can't be fully described,
and thus won't work. Even worse, the half complete graph potentially
confuses the OS, breaking the internal display as well.

Disable the external display interface across the whole Corsola family
until the DP / USB Type-C muxing graph binding is ready.

Reported-by: Alper Nebi Yasak <alpernebiyasak@gmail.com>
Closes: https://lore.kernel.org/linux-mediatek/38a703a9-6efb-456a-a248-1dd3687e526d@gmail.com/
Fixes: 8855d01fb81f ("arm64: dts: mediatek: Add MT8186 Krabby platform based Tentacruel / Tentacool")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Tested-by: Alper Nebi Yasak <alpernebiyasak@gmail.com>
Reviewed-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20240821042836.2631815-1-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8186-corsola.dtsi
@@ -353,7 +353,8 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&dpi_pins_default>;
 	pinctrl-1 = <&dpi_pins_sleep>;
-	status = "okay";
+	/* TODO Re-enable after DP to Type-C port muxing can be described */
+	status = "disabled";
 };
 
 &dpi_out {


