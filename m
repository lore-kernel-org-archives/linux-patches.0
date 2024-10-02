Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99A201D079C;
	Wed,  2 Oct 2024 14:23:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879024; cv=none; b=hXkU//558iqajTHRITDupgkXnCL4LL9Ybe+YSWJ/Hg9a4H5K4PqugsCiClsootTqj3fWLnawPRRNM1OjwFKR+vTixYuuUJ3h3ThD7sPKLUZhtnYVV8fuHhZWeA4l8bnsIN4uujvbMXJ0cEIOTD430dr6NWfbtk75S4ulwOKOLbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879024; c=relaxed/simple;
	bh=JAXvxFK0EP2jGE/+miwJNnZzm48O63gZcAaUvYhNsVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XT/p9XIcUzdd2MmjOQUtyzwpUsUbD/fwmvmfvH1NQv3o/3giXGHi9n9U2GfEvcyZ8CHqowAtGlvt9AeD5rSHuRvOohfCSS7jxg2oo4d8tmfy+zUMa7ttOO9pECHoLehOJCoAm8LWjBvvFJ/2gtJQROk88M/7vbnsZczxKmEX9NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4imTCJF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4imTCJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217D2C4CEC2;
	Wed,  2 Oct 2024 14:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879024;
	bh=JAXvxFK0EP2jGE/+miwJNnZzm48O63gZcAaUvYhNsVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g4imTCJF63y202pkbDQOkuqjiONSJBhLFUSd3/MM+qGWKnMRaxqLarTg4984oPuSM
	 bqtlh7QUporZlfs5zQ+6Jj0mlQj4AbatPQbiBzDyZ1fTpUAN5/jPVenyAAt7++z8xj
	 QYB/N/uDjFf1uKTCKY096UserwpB0YC8XbGrxjeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alper Nebi Yasak <alpernebiyasak@gmail.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>
Subject: [PATCH 6.10 571/634] arm64: dts: mediatek: mt8186-corsola: Disable DPI display interface
Date: Wed,  2 Oct 2024 15:01:11 +0200
Message-ID: <20241002125833.654659162@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -321,7 +321,8 @@
 	pinctrl-names = "default", "sleep";
 	pinctrl-0 = <&dpi_pins_default>;
 	pinctrl-1 = <&dpi_pins_sleep>;
-	status = "okay";
+	/* TODO Re-enable after DP to Type-C port muxing can be described */
+	status = "disabled";
 };
 
 &dpi_out {


