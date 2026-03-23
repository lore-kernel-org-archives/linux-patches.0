Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D4F3ACA68;
	Mon, 23 Mar 2026 13:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274103; cv=none; b=YIXM14idT997cfCy89WAgPawRNSlTO3O8Xbt4pjSC3TZELL4NDcjhIrhpUI0vHl4qffQCYAszyXURo23iD/ndXMNK2O1fD961fCRO+mgPBepKxJ+inmYg7lvz/OxChF2Lw7a09/7Pf63N9ejFt58aEUCqf8n5IEYBitvIPJE434=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274103; c=relaxed/simple;
	bh=+y72m6ZUbbh73fEzK2vDN2c6hi2hYzUJTor0aFdu2Nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e3hhu2Y088J5Ts8p8mAyrINstDNgFA4JjSEzJHyFVyr+Jawr4tB2WC4piWFr3QRj3Zqi2m1JSfVvVaPBqK33J062MK1F+oWcSJ1GBfZ71NQW6/Zukybfpc8wAZ6AsBbpCdN46vG7qytcOxI0Fbppd4B02tLnmvtn6jkNYYvzCDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UPo2/gku; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UPo2/gku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BABC4CEF7;
	Mon, 23 Mar 2026 13:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274103;
	bh=+y72m6ZUbbh73fEzK2vDN2c6hi2hYzUJTor0aFdu2Nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UPo2/gkudyiBoB/8IIJf1kx0otFAeWhUgYWhrHoBN0z/Xxs9WnlG/RVVvaai0d02t
	 ttOOr8SUPfFA0I2/Hvc59qC7dfzweJrMuNj0c3LusKS3uuLmngtj84jP79haUC5/Od
	 oX3GJAwag2TXhXNftMLx4JysjPTAr4EZ9LmTO9kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 109/220] arm64: dts: renesas: rzv2-evk-cn15-sd: Add ramp delay for SD0 regulator
Date: Mon, 23 Mar 2026 14:44:46 +0100
Message-ID: <20260323134508.044404447@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 5c03465ecf6a56b7b261df9594f0e10612f53a50 ]

Set an appropriate ramp delay for the SD0 I/O voltage regulator in the
CN15 SD overlay to make UHS-I voltage switching reliable during card
initialization.

This issue was observed on the RZ/V2H EVK, while the same UHS-I cards
worked on the RZ/V2N EVK without problems. Adding the ramp delay makes
the behavior consistent and avoids SD init timeouts.

Before this change SD0 could fail with:

    mmc0: error -110 whilst initialising SD card

With the delay in place UHS-I cards enumerate correctly:

    mmc0: new UHS-I speed SDR104 SDXC card at address aaaa
    mmcblk0: mmc0:aaaa SR64G 59.5 GiB
     mmcblk0: p1

Fixes: 3d6c2bc7629c8 ("arm64: dts: renesas: Add CN15 eMMC and SD overlays for RZ/V2H and RZ/V2N EVKs")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20260123225957.1007089-5-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/rzv2-evk-cn15-sd.dtso | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/renesas/rzv2-evk-cn15-sd.dtso b/arch/arm64/boot/dts/renesas/rzv2-evk-cn15-sd.dtso
index 0af1e0a6c7f48..fc53c1aae3b52 100644
--- a/arch/arm64/boot/dts/renesas/rzv2-evk-cn15-sd.dtso
+++ b/arch/arm64/boot/dts/renesas/rzv2-evk-cn15-sd.dtso
@@ -25,6 +25,7 @@
 		regulator-max-microvolt = <3300000>;
 		gpios-states = <0>;
 		states = <3300000 0>, <1800000 1>;
+		regulator-ramp-delay = <60>;
 	};
 };
 
-- 
2.51.0



