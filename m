Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD03424E019;
	Mon, 23 Jun 2025 13:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684599; cv=none; b=PX6/e0Q/WNdRB1u3CvJuzdBKwdMW19m034L1QvcFXKCgbtgCVyy8tCMZh9ElwbGaaNGWtCE1O5irYOXn4NLDOzB7fQnyFExlScz24/8ZNJY7EoSH4YJdqd6RsPA3D3T/wVPypSxpyZVsM4kf4LU2a2JID0Ztu1ksa/hhSteRDjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684599; c=relaxed/simple;
	bh=iTTkp4o6wdRFJm9ExDeDnhgdufGp2/0ZBBvrRZhpCuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b8x0Jwq55u79kr6vGw6DELFvSm/tl3PnpmG5oAKLgEOHRdG75GQ3lk6jMR62FWyLaLFkezOF0zYzrLBoliktlVRHaNWfUhy1LceBfbUl5N2jqNVzPIF7E2k9itsV8SEGQYmFRRClZFq+MylIeJG6de4ZU7pjQTuj6f+tCFzzUOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GCQvH1yk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GCQvH1yk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A07C4CEEA;
	Mon, 23 Jun 2025 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684598;
	bh=iTTkp4o6wdRFJm9ExDeDnhgdufGp2/0ZBBvrRZhpCuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GCQvH1ykFf/58Fbqo4MZVzcYr9PiQzY5WyEPvnibhFYDcic6myOHt22D09K5VWe7G
	 wIv2XOLappRXaEcewl1oM9+Yz7cUAJ6JOZTOqKFtA6+lJXZN60F6XYZPJ4nP4vW5uY
	 gJ4C0N0bPVg5HB+JIpDJyTeXIcoKnvOotm1Lms1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.15 129/592] net: ftgmac100: select FIXED_PHY
Date: Mon, 23 Jun 2025 15:01:27 +0200
Message-ID: <20250623130703.340440423@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

commit ae409629e022fbebbc6d31a1bfeccdbbeee20fd6 upstream.

Depending on e.g. DT configuration this driver uses a fixed link.
So we shouldn't rely on the user to enable FIXED_PHY, select it in
Kconfig instead. We may end up with a non-functional driver otherwise.

Fixes: 38561ded50d0 ("net: ftgmac100: support fixed link")
Cc: stable@vger.kernel.org
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/476bb33b-5584-40f0-826a-7294980f2895@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/faraday/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/faraday/Kconfig
+++ b/drivers/net/ethernet/faraday/Kconfig
@@ -31,6 +31,7 @@ config FTGMAC100
 	depends on ARM || COMPILE_TEST
 	depends on !64BIT || BROKEN
 	select PHYLIB
+	select FIXED_PHY
 	select MDIO_ASPEED if MACH_ASPEED_G6
 	select CRC32
 	help


