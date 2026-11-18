Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023170;
	b=FLclFTrz9wRS8K0wBNT+Vy2f6rrtHC1FDD+Hknds7t/NA/6wzIKDJFeq/7GJMqMvAkPa
	 xHsZ9/Jjw+JnDLg0DZfX98aKpB8JNKoclAc7x66fy9+kgP4bt/7z/GRHxiIUsKYfmOV3S
	 oh39CJ1eiZ/WKEMbbd9EcNv8L4MxuGsZjJgFtBsHz0CnRMWyXhUkkqvizJyPrg7qL2n2t
	 OV53xK2d+fMpCMaJskCFsjGvHLr18iDZil3AsWMFOzJALBPqfZGsePOn6qHSXZ0liRqV7
	 c6UXWrttCgXzQd5FmoYnYukNL6nyp0PSTuFu0i2X9wUxDxJOjFNT9sEc4303qdhdhjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023170;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R3nbfC3pYnSKsdxnAiXQItPmuXAR2s+t7gvO+65BqT4=;
	b=uBvHg9YQmYEdvNcn1Gwv2Xv0jJX5MNBgjLYC68XopFTYEx8T5B/4CkZfqMunC4QcPr16
	 flPcejaebZRPxm+zJKtvNEmyWpraOuuAZ5IRFXzeGCzlmpMrCEXMFdbqd8JcsYvZdeXZ/
	 DQZFW3o0WCxU3/Mq6N/6IUo4LaIwUq27tp6UZEghMdavBRDFveSKg7TQwJRNrmJioyQr3
	 jFjcvS1mtJXLU5FTiUwkBWvGsC5/GELRK5K7LCL9ud621tM8Sz22Ja9GTTpy3nabCYjid
	 WL9SNbajVYyUnE+hXEm48VkcVMV/Dw5KHwScHlS4YMBPT3EnL+173HBfYBTHbOAw9zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JXoK8Hd1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F2B606A31C;
	Wed, 18 Nov 2026 17:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JXoK8Hd1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E98C1F000C4;
	Wed, 18 Nov 2026 17:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023170;
	bh=R3nbfC3pYnSKsdxnAiXQItPmuXAR2s+t7gvO+65BqT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JXoK8Hd1hzYm01/Wm1xRj1zjChiZ6pv2Rg/lZ3u7Nvq+rESMDIVfUylA+gNK4XdDc
	 +FXKRSRdgszWWAe1YTInNrHVjrXgFU9qqQjlUG0XY6hfMdMYHRjUvhP1VnVMLCLgTS
	 3cSEcRYglrsI+J+NTpg6om5XK+0UqiStkfom41No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Belwon <igor.belwon@mentallysanemainliners.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0273/2151] arm64: dts: mediatek: mt6893-pinfunc: Fix pinctrl header path
Date: Wed, 18 Nov 2026 15:33:28 +0100
Message-ID: <20261118150131.802036287@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Belwon <igor.belwon@mentallysanemainliners.org>

[ Upstream commit 863d48714194bfcdb917b2ec35531e40df40cb87 ]

The header resides in the dt-bindings directory and not in the
dts/mediatek directory. Fix it as to avoid a build failure.

Fixes: c0f1fd9eeb317 ("arm64: dts: mediatek: Add MT6893 pinmux macro header file")
Signed-off-by: Igor Belwon <igor.belwon@mentallysanemainliners.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6893-pinfunc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6893-pinfunc.h b/arch/arm64/boot/dts/mediatek/mt6893-pinfunc.h
index 982bc95c471cc..7cda5c73fb684 100644
--- a/arch/arm64/boot/dts/mediatek/mt6893-pinfunc.h
+++ b/arch/arm64/boot/dts/mediatek/mt6893-pinfunc.h
@@ -7,7 +7,7 @@
 #ifndef __MT6893_PINFUNC_H
 #define __MT6893_PINFUNC_H
 
-#include "mt65xx.h"
+#include <dt-bindings/pinctrl/mt65xx.h>
 
 #define PINMUX_GPIO0__FUNC_GPIO0 (MTK_PIN_NO(0) | 0)
 #define PINMUX_GPIO0__FUNC_SPI6_CLK (MTK_PIN_NO(0) | 1)
-- 
2.53.0



