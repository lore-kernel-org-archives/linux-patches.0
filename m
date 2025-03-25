Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E6525A337;
	Tue, 25 Mar 2025 12:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905887; cv=none; b=klcbNtP7uJjS4uQ1MasgYdjULSVZmtqXg9wtt0KdqCBbOpfWW5rEJcaEsXkI6q+tJsfvCd5Ql3BP6sw16F0rt98dytpUrmMJvCDso86lieqkfBQaKDMaZlq5w1I4GAM5TdO+hr1uOiLzHi8m2HBfyRDHehzOKvzXyLKSb0+Mmog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905887; c=relaxed/simple;
	bh=xX89Ma+xc08CJ++0p55284IuljKZkCcz3Q2X44tHMLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TKdblfKKzca3FzGhsLQBfCuF0xI+NmSNmlKN7qDfYFsVxz1EUwkQ6XJqp9nLUdRz7Yk+zq9A0XMCie38jijNC2GaDMukWwFDqXJGLNzljaW0b+LwMDVtlOhaiDHnt1Eq3Kzftnl1l1n2ZiGhP+uGNCSC7yWEcIqi214mAR10sxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkiH88eW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkiH88eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E4CC4CEE4;
	Tue, 25 Mar 2025 12:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905886;
	bh=xX89Ma+xc08CJ++0p55284IuljKZkCcz3Q2X44tHMLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkiH88eWmJujRNHKBeFGrsxBmtJj1IrYpfhQ/WN40SSxAG4zE48WAD0OCVlD6MEbB
	 Cfwac89NcmeiFeYlU0GePHwJ0K91h366JAVXEhEw8jEr+9g34zyseMycRHoVygErpD
	 5mAqYqfNAof64OqUkqiPKgdlHvtTq0p2pURIT51M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Brautaset <tbrautaset@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 019/119] ARM: dts: BCM5301X: Fix switch port labels of ASUS RT-AC5300
Date: Tue, 25 Mar 2025 08:21:17 -0400
Message-ID: <20250325122149.561439293@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

From: Chester A. Unal <chester.a.unal@arinc9.com>

[ Upstream commit 56e12d0c8d395b6e48f128858d4f725c1ded6c95 ]

After using the device for a while, Tom reports that he initially described
the switch port labels incorrectly. Correct them.

Reported-by: Tom Brautaset <tbrautaset@gmail.com>
Fixes: 961dedc6b4e4 ("ARM: dts: BCM5301X: Add DT for ASUS RT-AC5300")
Signed-off-by: Chester A. Unal <chester.a.unal@arinc9.com>
Link: https://lore.kernel.org/r/20250303-for-broadcom-fix-rt-ac5300-switch-ports-v1-1-e058856ef4d3@arinc9.com
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts b/arch/arm/boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts
index 6c666dc7ad23e..01ec8c03686a6 100644
--- a/arch/arm/boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts
+++ b/arch/arm/boot/dts/broadcom/bcm47094-asus-rt-ac5300.dts
@@ -126,11 +126,11 @@ &srab {
 
 	ports {
 		port@0 {
-			label = "lan4";
+			label = "wan";
 		};
 
 		port@1 {
-			label = "lan3";
+			label = "lan1";
 		};
 
 		port@2 {
@@ -138,11 +138,11 @@ port@2 {
 		};
 
 		port@3 {
-			label = "lan1";
+			label = "lan3";
 		};
 
 		port@4 {
-			label = "wan";
+			label = "lan4";
 		};
 	};
 };
-- 
2.39.5



