Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBDD931076C;
	Mon, 13 Oct 2025 15:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369012; cv=none; b=IpnPpwI/OYBHEnRM+nbScvZgXNcokAle4YEpeKKfqsabrc7I6KfIefkQ4ELs0jTOsW+2KhJPiNVCtnSCtD3kP9q2mweco35onDuv9qJUHMgW3NTwgYnI2D+jmvZ6TKF5OaTqE+7CcSmJbyOPSEUfyTRYy6OjqG0OwETaWQJS7ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369012; c=relaxed/simple;
	bh=qvOeCKUX8a1tDbJq+LoPfe68W55OwdIFfcfv7kt258U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdQgo42pudcFQDoqk/KkZLQLvJ0Pz8A7+CFz/C5k4p+w2ptoeXiRGmV+xEoVPCxAoFsZXXvkHyBye1jr3ktyGNTbNKtvwmBM1vuMgT7RGHsqVZgD9GeYJSCFz3T415Pw67GeTzEGXtbyfyjyPGbGE5uPJ0OTe5CFYotIgFe/PL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3N+nyN0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3N+nyN0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42DBAC4CEE7;
	Mon, 13 Oct 2025 15:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369012;
	bh=qvOeCKUX8a1tDbJq+LoPfe68W55OwdIFfcfv7kt258U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3N+nyN0KtshXomHhOKd++m+/meNo4Fb/nJhG1gyZAhddnicyD0FHAuYh75524eGe
	 fEQdLhal1CKoBOgPj51Ng9hyzO0IkXbXY9khqKx9AQwmve1DFA3QrYs8aKRx3qEC69
	 SwJDQmx/56AS+LEUELEBOR1Bn0OhHsBw7QRXgXXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jihed Chaibi <jihed.chaibi.dev@gmail.com>,
	Kevin Hilman <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 098/563] ARM: dts: omap: am335x-cm-t335: Remove unused mcasp num-serializer property
Date: Mon, 13 Oct 2025 16:39:19 +0200
Message-ID: <20251013144414.845478391@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jihed Chaibi <jihed.chaibi.dev@gmail.com>

[ Upstream commit 27322753c8b913fba05250e7b5abb1da31e6ed23 ]

The dtbs_check validation for am335x-cm-t335.dtb flags an error
for an unevaluated 'num-serializer' property in the mcasp0 node.

This property is obsolete; it is not defined in the davinci-mcasp-audio
schema and is not used by the corresponding (or any) driver.

Remove this unused property to fix the schema validation warning.

Fixes: 48ab364478e77 ("ARM: dts: cm-t335: add audio support")
Signed-off-by: Jihed Chaibi <jihed.chaibi.dev@gmail.com>
Link: https://lore.kernel.org/r/20250830215957.285694-1-jihed.chaibi.dev@gmail.com
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts b/arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts
index 06767ea164b59..ece7f7854f6aa 100644
--- a/arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts
+++ b/arch/arm/boot/dts/ti/omap/am335x-cm-t335.dts
@@ -483,8 +483,6 @@ &mcasp1 {
 
 		op-mode = <0>;          /* MCASP_IIS_MODE */
 		tdm-slots = <2>;
-		/* 16 serializers */
-		num-serializer = <16>;
 		serial-dir = <  /* 0: INACTIVE, 1: TX, 2: RX */
 			0 0 2 1 0 0 0 0 0 0 0 0 0 0 0 0
 		>;
-- 
2.51.0



