Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADC1321B8;
	Mon, 11 Dec 2023 18:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KldETcGa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D210C433C7;
	Mon, 11 Dec 2023 18:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321053;
	bh=Y1er9JxquiwC02IudzWXYffbJGjzrZK+ZdIeyo7xKME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KldETcGaliDFvlfoGF0Dtj8xhmU3Bo7+E5gVjdUqJFmncuvNDl68prLQdfBl3yEtO
	 Jd7NzOLgyd4opjUEhkRp+PiV/CmPsm6gL6wtxTZw6x9XeY5yFnKlIvgNZRqE/xjX+a
	 UnTks/6sKbtMVH7ELYB1T1qIhuVvT1LuhyjS4ZuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 5.15 092/141] arm64: dts: mediatek: mt7622: fix memory node warning check
Date: Mon, 11 Dec 2023 19:22:31 +0100
Message-ID: <20231211182030.540881790@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugen Hristev <eugen.hristev@collabora.com>

commit 8e6ecbfd44b5542a7598c1c5fc9c6dcb5d367f2a upstream.

dtbs_check throws a warning at the memory node:
Warning (unit_address_vs_reg): /memory: node has a reg or ranges property, but no unit name

fix by adding the address into the node name.

Cc: stable@vger.kernel.org
Fixes: 0b6286dd96c0 ("arm64: dts: mt7622: add bananapi BPI-R64 board")
Signed-off-by: Eugen Hristev <eugen.hristev@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230814065042.4973-1-eugen.hristev@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts |    2 +-
 arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts             |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7622-bananapi-bpi-r64.dts
@@ -69,7 +69,7 @@
 		};
 	};
 
-	memory {
+	memory@40000000 {
 		reg = <0 0x40000000 0 0x40000000>;
 	};
 
--- a/arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts
+++ b/arch/arm64/boot/dts/mediatek/mt7622-rfb1.dts
@@ -55,7 +55,7 @@
 		};
 	};
 
-	memory {
+	memory@40000000 {
 		reg = <0 0x40000000 0 0x20000000>;
 	};
 


