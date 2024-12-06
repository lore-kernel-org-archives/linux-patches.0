Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55ECB1DFE1E;
	Fri,  6 Dec 2024 15:21:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498515; cv=none; b=eRdfKn2ltLVHVXVKP0Y5D94V+ZugkmbQcww37n0QUT3Hl7wGhn/Bdll3W2fDh2Tmj49ybyAdmwpjG4MxMujxDVYn0BjWq6i+m0KUkPxD+sgU897klQUzhNonMZxyksDXCMvTVA0BWW1x3W5+W8u/f3PEeh62RhLpQ99mC9InzGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498515; c=relaxed/simple;
	bh=1A5SDqBvpL3MlFzQS4phOh2QvnuHOquWpxGFior6yD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=On36/bf1fxxQeJaWW6u+UV/dQY0KmcFBPH02H7NZCGjlxZOupA4DHH3j5/uHr1E+qlO2w/Sji1avWHwjPtef/jLlGCRga1JWqXYlygrvrKW3+4FYJG9azXgnJIMxq5A+yNfZ9i4lO4whEtTnqvfmRPJBuSvfvBl6tgcH4i+KTcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nepg7Aa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nepg7Aa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B10C9C4CED1;
	Fri,  6 Dec 2024 15:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498515;
	bh=1A5SDqBvpL3MlFzQS4phOh2QvnuHOquWpxGFior6yD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nepg7Aa9QKjiCAoR5kcm35a4QDxFSvuL5coDbZqOoRUsve+TYoEcD3yAfBRzqC3yv
	 fINU7wbfgfgl/awUOyNCHGCnP8NukFLu75NLv4GpDBMJNjvyiZo0SeVmXkCyZTgouI
	 T0DpA5Vmo/v5AK8rFS1aDOmjx1fm8wK0ZxYmMqmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.6 607/676] arm64: dts: freescale: imx8mm-verdin: Fix SD regulator startup delay
Date: Fri,  6 Dec 2024 15:37:06 +0100
Message-ID: <20241206143717.084032651@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 0ca7699c376743b633b6419a42888dba386d5351 upstream.

The power switch used to power the SD card interface might have
more than 2ms turn-on time, increase the startup delay to 20ms to
prevent failures.

Fixes: 6a57f224f734 ("arm64: dts: freescale: add initial support for verdin imx8m mini")
Cc: stable@vger.kernel.org
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8mm-verdin.dtsi
@@ -145,7 +145,7 @@
 		regulator-max-microvolt = <3300000>;
 		regulator-min-microvolt = <3300000>;
 		regulator-name = "+V3.3_SD";
-		startup-delay-us = <2000>;
+		startup-delay-us = <20000>;
 	};
 
 	reserved-memory {


