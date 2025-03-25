Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EDF26FD83;
	Tue, 25 Mar 2025 12:40:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906400; cv=none; b=rX1bKfzwlB1Ybd5ftO/3+9GmpS2d7QhImmqxM4bU//4QzlXrlQO/7pL+cxMOqR8as7HR0agvMl0c9S3PiIwc9gCfL+uyBckRlljXzs7PEad6u3k8sT6qvWheekaMlaSCEfblFYvi5Y3XTwFkVUPXPXjxfXH5FZ9eSKe/b0bNasU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906400; c=relaxed/simple;
	bh=us7SxGKFNgpXVge1fR2QZkeVvL8Rv28zUTshUvPtkS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=By9oO7hj6OANViz69cDsKFuPNQ7gLBhOV9BZzuF1jzzKIfw7wZ3PuyGo6AYv5UVgme+tMJHnrvOda+JVWpiLug+T9P4oZQHymqdoDmFlDIfdZJgqxUtDwjH5Uqove9uWF5VTBS+xei4XO+IVDheaR9ljHSedYwKqK8n2tT5vp+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwAtEKyR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwAtEKyR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421E4C4CEE4;
	Tue, 25 Mar 2025 12:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906400;
	bh=us7SxGKFNgpXVge1fR2QZkeVvL8Rv28zUTshUvPtkS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwAtEKyRK5A5G7ujiWbnLtdNMYOukgxnett9uWGnz6FpkO4EB+ruWI64QX/Q5D+2O
	 PPtqzPfxSkM97bUs5JzpXNq6w4C5JdDnvd3os+rCURetp89WG9eJKQKzxlaqQC+nvZ
	 XvUtCYMMipyw+O+QDHJBi9ufpsYsMfjwtdzpNTxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.12 067/116] arm64: dts: freescale: imx8mp-verdin-dahlia: add Microphone Jack to sound card
Date: Tue, 25 Mar 2025 08:22:34 -0400
Message-ID: <20250325122150.922464139@linuxfoundation.org>
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
 


