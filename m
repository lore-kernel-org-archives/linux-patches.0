Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6587F223DD0;
	Mon, 23 Jun 2025 22:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716899; cv=none; b=OHZX27rpHA5EFo56X3JBNWcXtgYiT117CpZLErCBvueRFMbaLjLUJgmhQjomfiqptnsWoS4974QOMYVWPKyN4+Sh5nv2pV49w2IiMvmei/07fWRVCxbn/LiIt/MsyDLFKoS1FQBQhffW0O6G3S5kb0eShJjWO/Ak+Iv0U3EAWFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716899; c=relaxed/simple;
	bh=b9GmubO9aVRSPKherRcHU4wRwLlnfZeE0gO3Ycud2TQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AchLMzmbhjghvEOFDpWfV0c/mdNyzzCFPjVynDYjRyBCKSfqQO7PhBRWKIrmurFYBZBRKq59PzRQYrRE4MVzWpSxBmMF23IlZfqYfjrE0JrkdhynqJMGVzaIfA6lKm4E7wmkePFL2YuaZBMzfuZJsGiohoI01k32uXZXl2pOqMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWrjRSev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWrjRSev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A96AAC4CEEA;
	Mon, 23 Jun 2025 22:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716899;
	bh=b9GmubO9aVRSPKherRcHU4wRwLlnfZeE0gO3Ycud2TQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWrjRSev8lY5E5FCVlpAcpGghVyh5nJQ7WraS3zfHo0IDykvCDG28U90gXHoKbbXA
	 +Q9zE35mXnz13Ht4xWDwyskxi+SISLagmCNUn0mpSz48ebkC4E99RPlGjZ79Af9Ulf
	 dO4UUymiys8Qy+CJhsbduK3h71gvfLVWmn2uo0W8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 343/508] net: ftgmac100: select FIXED_PHY
Date: Mon, 23 Jun 2025 15:06:28 +0200
Message-ID: <20250623130653.783909754@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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
 drivers/net/ethernet/faraday/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/faraday/Kconfig b/drivers/net/ethernet/faraday/Kconfig
index c699bd6bcbb9..474073c7f94d 100644
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
-- 
2.50.0



