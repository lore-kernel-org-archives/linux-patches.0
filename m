Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015693;
	b=f/vZqGHwFAeC9IQhI1YMNEr9YQNv9cJ9KvIndHrmefmhr3YKJj/0I0nAs9PRtZ5/SJID
	 /Sce0+NE/CocygIaDz2ydUSz8PaBxu97h75XAFURpWxe/6ORdWeSlKy/11tjBqcrP79sk
	 3dRM6isujeWRjf+UFzimpQ4jd7/zfE5nsf3heiGkfiI6OSLLDi/V4a5UaTcJfpHFhznOj
	 pyGVRkMgBa0sL+hxsI1P+XpbYapgUTkpT3A8XiKrVrX2YRWUiQweSmoacRDDLkM/6LHWW
	 /D0vzH7SkXXJkbbvQQH5Bu/N+DqXPkDAM59n71wYnVx5PuEuVEd/wHLPkIxG1KnT2hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=koMBIe43R8FztBPM0YRsBSECBkx/jo5T/MpHagMsq3c=;
	b=BYY3agHGtE6nvvVT4i30M7fPCGqTJKyfwJMFiqNCSpjJo+apLFoMzvAfnkv5UFxwd/V/
	 PwN9GMxYkraJIocMtVhNzVKc3rxvZPpU9VN/mY/qFVzdzwnVRUsxb3QnyY8OKD+ZQS+PH
	 pyMTGvb8walU/n+y1R6PU3Mgr2BMtCIcPGf5CGk0pCSl0eHxumB+42yLlfT4eYHG9aWMw
	 IzR0GyzayeCyMNkU45R5+gH6j1oAupW3g/gKgndaeQbCxptMMRzlq+tswme4o+wEfT3LF
	 Dmp9rRavBJuDdrC2I8BaP74sBaivi13JQ70OPnzxmpYMXzx7fWD1qL0mWH4kqOGL5eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j04GfdWQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6896A60A2634;
	Wed, 18 Nov 2026 15:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j04GfdWQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CB561F000C6;
	Wed, 18 Nov 2026 15:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015693;
	bh=koMBIe43R8FztBPM0YRsBSECBkx/jo5T/MpHagMsq3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j04GfdWQ7ib7bhy/0ezqjGF3vF3lojQQ3bSHJ/zUZqADo3FUlIHpr3HqOI9ryM9+9
	 lmZLnEMuB7BFVAnpmKNTo/8cJFqBPectmRWyUV/rBlNaEB0UtcJJEHI68Ec8XOuH8I
	 CrbMTGEbCQBNswnixFkZ4OZPx8qvthEdrvLF+w64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Belwon <igor.belwon@mentallysanemainliners.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0265/2651] arm64: dts: mediatek: mt6893-pinfunc: Fix pinctrl header path
Date: Wed, 18 Nov 2026 15:25:05 +0100
Message-ID: <20261118150257.440075545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



