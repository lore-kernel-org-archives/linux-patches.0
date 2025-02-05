Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE8A1607B7;
	Wed,  5 Feb 2025 15:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767673; cv=none; b=WHN9zZXJD5waojQu8QukqxudJfC6RxjNYiUXHebF/EPSgnlvpEe6CMOYydEkAnd6vjztilWPJpEf6gUTJoJd8rvpst7xrUs3n7dfNtYFbxgl1sVkwJPF/bUS5dmZzXweg9QItWlwWAdxxbTRSOA9Vk4hLJEGBijiUbgaCMgE/vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767673; c=relaxed/simple;
	bh=8ZGHpF678Ild9F7KlfnLRlo4RP8DYH1cOBSH7VvW9ZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eouvKi2hbpEYWEHLiF5L1+g0WTI8z+OtVEF9lwb0TQ46kWKjPvapzVwqSQhH5w0dwMrJB9D+gOITW5bZ3X6Kiulv9kv71Rtq+ImHFwCvzw8LWKcLf6cgHNdf1ia1fQhZkSNdM/KGYGOkJMCfVEaC3iTtGIRvSEA6dLsf6jYXHxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zq8cV7pJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zq8cV7pJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B13C4CED1;
	Wed,  5 Feb 2025 15:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767673;
	bh=8ZGHpF678Ild9F7KlfnLRlo4RP8DYH1cOBSH7VvW9ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zq8cV7pJwu85yyuqD2jyjdZx8G49YZ7gVhH4pQil4HYle5K5so2tmmtbL0sxqJ/uT
	 oDtg4WrVGRFZOZ7rpnQi77rAKeFIL7cOEPOcIQ87/cUeusyNWlYjwmc5+kQSvr4xBB
	 5+2jmLHBhlfm7SZpKi5qPQOw8pRS/nbr8RpzOa20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josua Mayer <josua@solid-run.com>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 419/623] arm64: dts: marvell: cn9131-cf-solidwan: fix cp1 comphy links
Date: Wed,  5 Feb 2025 14:42:41 +0100
Message-ID: <20250205134512.255916865@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

From: Josua Mayer <josua@solid-run.com>

[ Upstream commit 09cdb973afa7a18ce8e66807daff94609cc4b8a4 ]

Marvell CN913x platforms use common phy framework for configuring and
linking serdes lanes according to their usage.
Each CP (X) features 5 serdes lanes (Y) represented by cpX_comphyY
nodes.

CN9131 SolidWAN uses CP1 serdes lanes 3 and 5 for eth1 and eth2 of CP1
respectively. Devicetree however wrongly links from these ports to the
comphy of CP0.

Replace the wrong links to cp0_comphy with cp1_comphy inside cp1_eth1,
cp1_eth2.

Fixes: 1280840d2030 ("arm64: dts: add description for solidrun cn9131 solidwan board")
Signed-off-by: Josua Mayer <josua@solid-run.com>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts b/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts
index b1ea7dcaed17d..47234d0858dd2 100644
--- a/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts
+++ b/arch/arm64/boot/dts/marvell/cn9131-cf-solidwan.dts
@@ -435,7 +435,7 @@
 	managed = "in-band-status";
 	phy-mode = "sgmii";
 	phy = <&cp1_phy0>;
-	phys = <&cp0_comphy3 1>;
+	phys = <&cp1_comphy3 1>;
 	status = "okay";
 };
 
@@ -444,7 +444,7 @@
 	managed = "in-band-status";
 	phy-mode = "sgmii";
 	phy = <&cp1_phy1>;
-	phys = <&cp0_comphy5 2>;
+	phys = <&cp1_comphy5 2>;
 	status = "okay";
 };
 
-- 
2.39.5



