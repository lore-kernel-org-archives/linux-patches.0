Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E9E626FDB5;
	Tue, 25 Mar 2025 12:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906402; cv=none; b=XAY7nzFJ3nf88LToC71Nx92RWaagx77HTEI25kl1Wk1nJ3SGYWAV0DNcoz1CLw9XsZSS4nHtm+OU4AXos1/1RwXpJsWMyGGnTgLNcPXTT3C+WEUDSZ3NnQYOvray2vB9AvtGpjkzyygBYyqyo4nskXJKVongJFRrUBlB74UP1Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906402; c=relaxed/simple;
	bh=8M6mxTrZ5Y2KMvvjbn8ipZ21ihw9FI90Wc+6hvWg07E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aieaQdS0nVXF+i5YHfJNNmdcPigt0Xow5Xk8JFx6DptYthwDWiiq4+GR69tVWiJPH2GCCse7uNpjDoyMUwTWYt84ON2bR4TEnd8o3g8QiYSoBZ6ZdXX5FV972MQSVx8Dz90RCLvUcvoN5uBXt9KtBkhGj+wiabzwnlZk0TZRIck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Npcc8cD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Npcc8cD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12441C4CEE4;
	Tue, 25 Mar 2025 12:40:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906402;
	bh=8M6mxTrZ5Y2KMvvjbn8ipZ21ihw9FI90Wc+6hvWg07E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Npcc8cD0d1SlsjmNIDnMh8/204qCrSDi66p4Z1JGXoQAU3YBHz2LPQS7UmKuef+B9
	 DFgIqGJv8sa7fGhAgDUbMr9KELJQVjCOdiMWE6arym8zLNMax9utYyrFSD3k3dSv1w
	 J2cgLjxwNCZNnLzGhGAulB8SFY3pXxGnlJ2/rWQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 068/116] arm64: dts: freescale: imx8mm-verdin-dahlia: add Microphone Jack to sound card
Date: Tue, 25 Mar 2025 08:22:35 -0400
Message-ID: <20250325122150.947248811@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


