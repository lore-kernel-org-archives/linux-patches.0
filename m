Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6761DD9D3;
	Tue, 25 Mar 2025 12:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905980; cv=none; b=HW5Z7doafcsAh+SWM5hVxZCROKdk5sfh9t/0gPznbjiYxk6RgWAn938Pf6+bn0Hs+SFonz3t5yka3iWhvofHZQ2jcAbzm142N32rwRaqgDJ42WAirvqAMqE5FLkcNEG40gJxX4b8j0mlbX7Kd/JT3VYeqrsF1egUS+++6TBe7As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905980; c=relaxed/simple;
	bh=VLbOzDZzTPVgfz2E29uPAqj+aYfdM8XGxqbf0rYReuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t85Jjlmdnb8v5GEb2/n112cnTatwMC/Wweww1jQcavUaBqe0o5UgCMNlFPxVYsiVMWOLkhBabQ+aRbHxW1tMoYv0oVtTPTTeiZa28hztn7xoMdu7qQ1gX4VQFt2NwpJZgdxucSW/egNxIsmouqETORsln1wcFLmsgQqqQjJQ/3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQ/4lqvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQ/4lqvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72ED7C4CEE4;
	Tue, 25 Mar 2025 12:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905980;
	bh=VLbOzDZzTPVgfz2E29uPAqj+aYfdM8XGxqbf0rYReuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQ/4lqvFIN2bTFFU1KPK9zc2OVkgdRmYRxvbpxV1BWxzLOS2xgSAoWJmPxd+vhMnl
	 ckZn1RntDDrGr4goLMtE3uQ4gi9d7WUpcRR2VgPyuepilqmQri2ICihN7Wk4HJWsG5
	 YYzS2OiQz2sD40VFkDceQ/OmjJodTaMPqtAp8ZEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Shawn Guo <shawnguo@kernel.org>
Subject: [PATCH 6.13 070/119] arm64: dts: freescale: imx8mm-verdin-dahlia: add Microphone Jack to sound card
Date: Tue, 25 Mar 2025 08:22:08 -0400
Message-ID: <20250325122150.844865379@linuxfoundation.org>
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
 


