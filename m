Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AB3525B68D;
	Tue, 25 Mar 2025 12:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905979; cv=none; b=n9hmJnJufN62+e2ormuEdLygIh6myYWHPAvtskoVOknf+O2IkZB04MQ8a1tMNKi9V6oA6s7Itsi2ymPVyQfM2sATvKwCs3/AzmjUFuh+r2ZWR2wb5wZRME1NlUH2JK0QTjsLlzEy8E8842c2gT49eZddQZV5huxd4LrSQf2SHB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905979; c=relaxed/simple;
	bh=ifYaLnBN53qhqk8v2obPiM+paexPZn1IMWa0NtYimhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MB7UbBumwkPUKELb2H9YMNegZ0ffRlagqTPJXFZEOHz9mYZGbtuOrLDtwz10mrjAS3cleRDIIkO9fSLcNX7rXVZYrF++7zDQlN8MMIsZMeWGBObuKIobFu9W7Plx/KAKlH57k/tDa48PwGaRkvda6MF/o3/judHgZ1gDuRXO/18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDSmzpXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDSmzpXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FC0C4CEE4;
	Tue, 25 Mar 2025 12:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905978;
	bh=ifYaLnBN53qhqk8v2obPiM+paexPZn1IMWa0NtYimhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hDSmzpXyPNCYqd/DGysc8/oA7WYrLXiS20UMGfGcH13vLCsUi23KsQ+wNaJK5WXil
	 BqBOzzYxOrnoXBiLiQsI81Sd/rigddbGidi22CvAXBjBpNS+wuh7wInOPUTtHTcx0a
	 DqREaFWdT/rWBWapi+FZN4B5qHWE4o0ziQtyo53k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.13 069/119] arm64: dts: freescale: imx8mp-verdin-dahlia: add Microphone Jack to sound card
Date: Tue, 25 Mar 2025 08:22:07 -0400
Message-ID: <20250325122150.819779554@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit b0612fdba9afdce261bfb8684e0cece6f2e2b0bb upstream.

The simple-audio-card's microphone widget currently connects to the
headphone jack. Routing the microphone input to the microphone jack
allows for independent operation of the microphone and headphones.

This resolves the following boot-time kernel log message, which
indicated a conflict when the microphone and headphone functions were
not separated:
  debugfs: File 'Headphone Jack' in directory 'dapm' already present!

Fixes: 874958916844 ("arm64: dts: freescale: verdin-imx8mp: dahlia: add sound card")
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mp-verdin-dahlia.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mp-verdin-dahlia.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mp-verdin-dahlia.dtsi
@@ -28,10 +28,10 @@
 			"Headphone Jack", "HPOUTR",
 			"IN2L", "Line In Jack",
 			"IN2R", "Line In Jack",
-			"Headphone Jack", "MICBIAS",
-			"IN1L", "Headphone Jack";
+			"Microphone Jack", "MICBIAS",
+			"IN1L", "Microphone Jack";
 		simple-audio-card,widgets =
-			"Microphone", "Headphone Jack",
+			"Microphone", "Microphone Jack",
 			"Headphone", "Headphone Jack",
 			"Line", "Line In Jack";
 


