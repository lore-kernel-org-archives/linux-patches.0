Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23ED224F6;
	Tue,  8 Apr 2025 11:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110721; cv=none; b=P8swzI/olZa/H0XP4j7nLIxdecKaCPwmDyw7kwGfo9FGBUDY91VIN1EZYdirZrRGFOErpw49G1jg5eoMYPkc8GKhTeQ7tzlvDuv6u94uqV/nzi8C9FlpwQmwIucfOGt3VswystSnLOAONBwbkRdrNDGLHQXEMvTnN9N3Ym0l1Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110721; c=relaxed/simple;
	bh=Cf+4qEFNyXC+O/SxqEV2WugmBNcQkS4+D8K4bzXhChg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cz5LX64IteeVu9wQ7Nv5YLylmLVvOLwypQzGbzfQQVx3GpifD7Tux/QvvaU70XgrlYD4bi6QJ1jRXYAUXh0z9FAaV33iIwbLM4i3qJqLgWWAy9r0k5uLkxZ3tLiVEYzefbExDR2ndnYoHAXGng96/veBPgqO3vXwti6vmV6L6j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q9vOl3qT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q9vOl3qT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E10C4CEE5;
	Tue,  8 Apr 2025 11:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110721;
	bh=Cf+4qEFNyXC+O/SxqEV2WugmBNcQkS4+D8K4bzXhChg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q9vOl3qTzDiYki3ZIOYeNY+rFdQK1jzR44jv3+SvhCTGMeEPuqXOuEk7/ic+F05cq
	 8xE/xxUHNv8Qfo2Gfkbf81/urDQEA5qdAnLPGsSE0RhvZlEpJ4ASwux0U6sT8v0rAV
	 rZtSZx4q6sMMP0ajnrJDsGJ7TcWZmxKsToIw8/uI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Jai Luthra <jai.luthra@linux.dev>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 129/731] arm64: dts: ti: k3-am62-verdin-dahlia: add Microphone Jack to sound card
Date: Tue,  8 Apr 2025 12:40:26 +0200
Message-ID: <20250408104917.280645300@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Eichenberger <stefan.eichenberger@toradex.com>

[ Upstream commit 7139df64e7c13c079b754476355c62b490213055 ]

The simple-audio-card's microphone widget currently connects to the
headphone jack. Routing the microphone input to the microphone jack
allows for independent operation of the microphone and headphones.

This resolves the following boot-time kernel log message, which
indicated a conflict when the microphone and headphone functions were
not separated:
  debugfs: File 'Headphone Jack' in directory 'dapm' already present!

Fixes: f5bf894c865b ("arm64: dts: ti: verdin-am62: dahlia: add sound card")
Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Jai Luthra <jai.luthra@linux.dev>
Link: https://lore.kernel.org/r/20250217144643.178222-1-eichest@gmail.com
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-verdin-dahlia.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-verdin-dahlia.dtsi b/arch/arm64/boot/dts/ti/k3-am62-verdin-dahlia.dtsi
index 9202181fbd652..fcc4cb2e9389b 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-verdin-dahlia.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-verdin-dahlia.dtsi
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
 
-- 
2.39.5



