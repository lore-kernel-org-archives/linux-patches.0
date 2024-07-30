Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E451BBBFE;
	Tue, 30 Jul 2024 15:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355134; cv=none; b=h5EGY0yPGF56gPk9DzA+e8wzLfRiuCbKH5M2CJGV7v/4hMwpfIGzjkYfXUoEa2GvyaUscXWhD74bJfmpuyGkvfPSRw9qoPFnwqpVfsuwKhUqQXfG2Cw6ZbulGBu13NQOtH7DHofv2plkFdF7Tr/Ns34npZzEmePOIZusP2mVQqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355134; c=relaxed/simple;
	bh=PBNB8XfHCNFZuTYSH5vUe3X551LNxyAhhCx+QfSVUgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ec94REibA8Cpqr1Eo5gnC0nWBNGqKpNLxGL9rSQQoX9pkkgEX8MVu4ef9AXyDxg3kV6sdehypNpVvQVz18pC8sg59iNwd3gylVYUogiZzcFNYfZvff86Im/LtxnVWJGnWvF+5booCcje4r+jSUSmBE3apIXXHKSQMVii9q82pG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bZwAnQAU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bZwAnQAU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C1AC4AF0A;
	Tue, 30 Jul 2024 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355133;
	bh=PBNB8XfHCNFZuTYSH5vUe3X551LNxyAhhCx+QfSVUgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bZwAnQAUhSZ6H5a20Ew9SexYy6xfqTpYufFnb4/rjh2k9KDRn0j6byd50aJ4ItbaZ
	 MgpupVdMuFLXEH3OJcD9JPUwrBW4cSW9RU9o5xhXrXzwBOhi/jrokoo4w6Y3tCVnRj
	 /5auu0bN8ahD3r0RbH5zzqe6/xxRuClbaw9awB+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Karlman <jonas@kwiboo.se>,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 061/440] arm64: dts: rockchip: Drop invalid mic-in-differential on rk3568-rock-3a
Date: Tue, 30 Jul 2024 17:44:54 +0200
Message-ID: <20240730151618.149417613@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 406a554b382200abfabd1df423a425f6efee53e0 ]

The 'mic-in-differential' DT property supported by the RK809/RK817 audio
codec driver is actually valid if prefixed with 'rockchip,':

  DTC_CHK arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dtb
  rk3568-rock-3a.dtb: pmic@20: codec: 'mic-in-differential' does not match any of the regexes: 'pinctrl-[0-9]+'
	from schema $id: http://devicetree.org/schemas/mfd/rockchip,rk809.yaml#

However, the board doesn't make use of differential signaling, hence
drop the incorrect property and the now unnecessary 'codec' node.

Fixes: 22a442e6586c ("arm64: dts: rockchip: add basic dts for the radxa rock3 model a")
Reported-by: Jonas Karlman <jonas@kwiboo.se>
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://lore.kernel.org/r/20240622-rk809-fixes-v2-3-c0db420d3639@collabora.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
index bab46db2b18cd..478620c782599 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
+++ b/arch/arm64/boot/dts/rockchip/rk3568-rock-3a.dts
@@ -481,10 +481,6 @@ regulator-state-mem {
 				};
 			};
 		};
-
-		codec {
-			mic-in-differential;
-		};
 	};
 };
 
-- 
2.43.0



