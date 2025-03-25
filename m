Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55CBC29B222;
	Tue, 25 Mar 2025 12:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905858; cv=none; b=Np9xNhxCl8ysArmAD5qQ2WU4SiKcOLR9oJb1r9lQMROYHMrpzLGiZsuFR7DnJw8V45SwXJqZGF+BnST4bdzZ7ygcECk5Gt8t7oYQtmS6PbFOK8Z6uRFhWamDW1BormN7OgpgeEegJ/XLBJtg9dLTjr7mfNHvsJQFrDOfOpyIxx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905858; c=relaxed/simple;
	bh=dJdJi1qP8zhOQ21wxXukquza8J1lEq+Om9tx6SbXV+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uq106N2x8W9S0ML0TMCZ+MAORAsNc/XqxjwSjX96TFKOUVWejP5bsLKCfEONCeGlMUXPtksNX1Rv4gRV6x09bT6vo2+uDdsRDLjIHbafqioJ/xxpjCB97Uq3yvH7JmDFYyXojsECmj7Mp73xThzNikyg6PJs2yqUCzIaTO5s86g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quD73EF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quD73EF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F49AC4CEED;
	Tue, 25 Mar 2025 12:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905857;
	bh=dJdJi1qP8zhOQ21wxXukquza8J1lEq+Om9tx6SbXV+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quD73EF5cL83tFEd0nvVolDzz/wkcV/AK92kA0w5GiH021hx8DBO6wKKlNauNxmob
	 fsTFxNcGTWdbMhfIgqzvXGWZl4ti3AQQATgj3di2BlXye0uWEhpKYszHql9vWp5lFS
	 oQMtawawqQQ0qy9kseIvyZ3Zi2gHMeQV7gIzGfsM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.1 174/198] arm64: dts: freescale: imx8mm-verdin-dahlia: add Microphone Jack to sound card
Date: Tue, 25 Mar 2025 08:22:16 -0400
Message-ID: <20250325122201.210988673@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


