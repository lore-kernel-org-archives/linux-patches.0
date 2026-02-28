Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55797341674
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301197; cv=none; b=AnCIJ/Iz85xvpzaoweB6P3dlOqJoVofyBhmP0b3MqLuv2tvgGy0lL1/OrUQMTPwa4W5UuzG8tRc7SdxWNtT2G4s+P1Gj/KXsnkLWWq6UAXnQVRA1S9X0ypw6AFlxC/97qyiVkq+7TwSiMKdP6W3ILhQiL4UUoTkWtiQxkkQL6+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301197; c=relaxed/simple;
	bh=dn1iFD73VMHB/YqmWH1neyVbOGQ8Ue4J3Ro2YMlNY1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gGbWtW5/AqmJc7nIS3E1lQW1q17umYNa778PWjRFJpiL99xpmgzz+EVBUQvXa4t4szjl2dCZW/mXeDLTYo4FNA/7QgSXJ/98I0pDyrzGOk5Vu/lWabUCEq5cXI9Lf0HMpPlM8XgPVIyyNxeRRoywzmHf2UKk2LT5GCpmRgbe8vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vIa9eTCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vIa9eTCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB65DC116D0;
	Sat, 28 Feb 2026 17:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301197;
	bh=dn1iFD73VMHB/YqmWH1neyVbOGQ8Ue4J3Ro2YMlNY1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vIa9eTCeWkKhyfOW/SdDvZ80TRQKs8n1QuTTFoR2gP+CMl27mX/l4Fu8drdEz7mI+
	 2AGy7ABD1g8VZgVgJl1skXKXefseNx6coPuuclvluRqOFq2ZGSN/eJom16G6aINLL4
	 BsV0bUooJzhsMt4nF4elasUpXJFK6rcTRSiaidW9Vq2sT5p5glhvX4/uKSMtj2P+h3
	 R7WE79Bk57Xnv/sfkY9dWDqiGJIhL8n/gMOyQihgFbmNmgWDikK/9VC0zb+qIVJ8AE
	 Kf2EEkI6MlMbAqR41P0nw4/IgHWWoUWhMKMnGxVO6Yx3oV2FhwSvpKu4yfBphZQJE+
	 AQ2lu6n1+kk4A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Weissschuh <thomas.weissschuh@linutronix.de>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 369/752] ARM: 9467/1: mm: Don't use %pK through printk
Date: Sat, 28 Feb 2026 12:41:20 -0500
Message-ID: <20260228174750.1542406-369-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Weissschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 012ea376a5948b025f260aa45d2a6ec5d96674ea ]

Restricted pointers ("%pK") were never meant to be used
through printk(). They can acquire sleeping locks in atomic contexts.

Switch to %px over the more secure %p as this usage is a debugging aid,
gated behind CONFIG_DEBUG_VIRTUAL and used by WARN().

Link: https://lore.kernel.org/lkml/20250113171731-dc10e3c1-da64-4af0-b767-7c7070468023@linutronix.de/
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/physaddr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/physaddr.c b/arch/arm/mm/physaddr.c
index 3f263c840ebc4..1a37ebfacbba9 100644
--- a/arch/arm/mm/physaddr.c
+++ b/arch/arm/mm/physaddr.c
@@ -38,7 +38,7 @@ static inline bool __virt_addr_valid(unsigned long x)
 phys_addr_t __virt_to_phys(unsigned long x)
 {
 	WARN(!__virt_addr_valid(x),
-	     "virt_to_phys used for non-linear address: %pK (%pS)\n",
+	     "virt_to_phys used for non-linear address: %px (%pS)\n",
 	     (void *)x, (void *)x);
 
 	return __virt_to_phys_nodebug(x);
-- 
2.51.0

