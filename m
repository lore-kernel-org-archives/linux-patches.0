Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D461170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6891FC433C8;
	Mon, 11 Sep 2023 14:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443355;
	bh=wvZT/8yGBABBRySrzf95aou3nQ5JIscheGcgc1jCWpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKa8rIaLbvtxdT8x80KlorpQ/5+dmG0cxmUcEd3f6QaU4lw3EPnjQtsi6RqJy8fny
	 tGQevrIO8ArsBnkA4kH4F9C3Qu3+Jnk+A5Muhud5FwLdJwNT9UX3LAe8QjFfmkBgkI
	 +TG2wgmCyY9Bsewu9+pfIOzzZ85m5japz0Gi4u9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 348/737] ARM: dts: BCM53573: Fix Tenda AC9 switch CPU port
Date: Mon, 11 Sep 2023 15:43:27 +0200
Message-ID: <20230911134700.245078828@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 7141209db9c335ab261a17933809a3e660ebdc12 ]

Primary Ethernet interface is connected to the port 8 (not 5).

Fixes: 64612828628c ("ARM: dts: BCM53573: Add Tenda AC9 switch ports")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Link: https://lore.kernel.org/r/20230723195416.7831-1-zajec5@gmail.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/bcm47189-tenda-ac9.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/boot/dts/bcm47189-tenda-ac9.dts b/arch/arm/boot/dts/bcm47189-tenda-ac9.dts
index dab2e5f63a727..06b1a582809ca 100644
--- a/arch/arm/boot/dts/bcm47189-tenda-ac9.dts
+++ b/arch/arm/boot/dts/bcm47189-tenda-ac9.dts
@@ -135,8 +135,8 @@ port@4 {
 			label = "lan4";
 		};
 
-		port@5 {
-			reg = <5>;
+		port@8 {
+			reg = <8>;
 			label = "cpu";
 			ethernet = <&gmac0>;
 		};
-- 
2.40.1



