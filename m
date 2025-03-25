Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466DD25C6F8;
	Tue, 25 Mar 2025 12:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906201; cv=none; b=LwqYrblBynyBn2jasSiRzkOpKjf4o/hw+Vm2gJ3R4xfD7AzVntC9fe9ME2kKcSsC52FYYafI+h88LhOJKhuvc5OyJm/iJiCwnKg8Ju8d5sIsJn+0ZcdTVjqQgMinst9uekFkHqvr59QR6Y60V22XmB2PIbdo9iUoSev/ZZCin44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906201; c=relaxed/simple;
	bh=kE43gokTSO6OTTi8qaffz7BJepijtOb9E6B8ysX451M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWMfNtAlTtcPUy72ItL49SJj05y8kM1UGfETeF+p4T1fmqOhL3aSAgj2MxYbA5FSx8h19MMFGwXyqkpTfgpTejQsU14p0VP3aQXvmMf2lxW+CPHnjCuJX30IF9kjrGLEKZNxhtboU8UnaTB4uWr1zIJR8W6K7WFaTczW6Z0vwZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKjvEX49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKjvEX49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E571CC4CEED;
	Tue, 25 Mar 2025 12:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906201;
	bh=kE43gokTSO6OTTi8qaffz7BJepijtOb9E6B8ysX451M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XKjvEX49aLxCI2xCQ64jLQaIJZ9yqc48oMFH2S5Ygdq1Ujy+Tkeo8MCDykoxUUKc0
	 xT9HsSvSxQh+DMiIdshDymFKHSG3Y+616OEjRfMZkG40WgUjWZ7ijDB7VY96y6aJnk
	 Sp3Ssi8TGnrOAOOzvdBWmhgDVH+v/hVnpSwiCp8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 40/77] arm64: dts: freescale: imx8mm-verdin-dahlia: add Microphone Jack to sound card
Date: Tue, 25 Mar 2025 08:22:35 -0400
Message-ID: <20250325122145.399945113@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

commit 2c1092823eb03f8508d6769e2f38eef7e1fe62a0 upstream.

The simple-audio-card's microphone widget currently connects to the
headphone jack. Routing the microphone input to the microphone jack
allows for independent operation of the microphone and headphones.

This resolves the following boot-time kernel log message, which
indicated a conflict when the microphone and headphone functions were
not separated:
  debugfs: File 'Headphone Jack' in directory 'dapm' already present!

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin-dahlia.dtsi
@@ -16,10 +16,10 @@
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
 


