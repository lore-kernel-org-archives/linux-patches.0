Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9523502AE;
	Fri, 21 Nov 2025 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733512; cv=none; b=B2PEWHXij7a/DwevPJH2mMMKMAAlgeaKnVprK2WV2lMxX1Ho/Z3BHRNg1AGP8cyz7p0HZUIbUMkAq8ZJxXB153G4ZntLzbQLsJAaUEpcI39gBpagWRII/iO4AdkgYN9s9TaBZF7qT5Tj7AF8zHLBcJXT/qxKfs7FpaNSTx+A1Lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733512; c=relaxed/simple;
	bh=VzfaIz6hOuZ+XS6TsbQFWW18l8Nq5aS0anrXwW61iFE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ky/nASBHOJU8dH7v5xVR07vbDwapjcIHydKlypounNTH7DRf7gjfi+EfjBCQa4Q6c67FfjX/wPhk27ZKn2XEAhlVH7cQXcET0bB7qIyQIPmo9Sm4vUUgnyTLhSmlOvPeVmLExiho8pPpkigKUIgWKQJCHP6p2o9WozFqsdGYKDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFzYdKka; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFzYdKka"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6A2BC4CEF1;
	Fri, 21 Nov 2025 13:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733512;
	bh=VzfaIz6hOuZ+XS6TsbQFWW18l8Nq5aS0anrXwW61iFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFzYdKkaTDXnZ1JH4uZHM+1Tvg2QB34rd4aQcrNhNABGakY0umMzxVM7ukwRnSk6b
	 zIAZmVlSFCjAw0odTKTMVpNEBY+7JLg7PqF0lDDUCSrSJqp0gCzMjI3pntsL4e5U7J
	 3zsb/8RNsvaRXS4mi87mc6euHbXtdHnkvusi0zKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 460/529] ARM: dts: BCM53573: Fix address of Luxul XAP-1440s Ethernet PHY
Date: Fri, 21 Nov 2025 14:12:39 +0100
Message-ID: <20251121130247.377855912@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 3d1c795bdef43363ed1ff71e3f476d86c22e059b ]

Luxul XAP-1440 has BCM54210E PHY at address 25.

Fixes: 44ad82078069 ("ARM: dts: BCM53573: Fix Ethernet info for Luxul devices")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20251002194852.13929-1-zajec5@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts b/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
index ac44c745bdf8e..a39a021a39107 100644
--- a/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
+++ b/arch/arm/boot/dts/broadcom/bcm47189-luxul-xap-1440.dts
@@ -55,8 +55,8 @@
 	mdio {
 		/delete-node/ switch@1e;
 
-		bcm54210e: ethernet-phy@0 {
-			reg = <0>;
+		bcm54210e: ethernet-phy@25 {
+			reg = <25>;
 		};
 	};
 };
-- 
2.51.0



