Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015690;
	b=kN7rG7hyisYqzj96hpRX3JV4kDdkjZ4JnVcmTS4Bdya9N56wE+Gd5F2SlOPpzBtmD+Tv
	 3slPrAav4HQBB4DFq5WhDpWtcOljNgYAiXBYihL8QocP1RrGCgs5lt61kwhRP7wjEGYlY
	 gjqRmRAE0qfzZrlN65EQyEaj2V68Lew1EroGrxoW+EaL2CQxQlweQrIHbCe3xsfYUV6oj
	 /jEw74kCtwVBp1xiGRg1UKit/9vPPFurju7C0flCMP31QOzKY53wv24Pc3QuPPERHEFi4
	 z+b8QaOmlxr1KqGyF/XDpZNXFiWC4DTlXeGhcdLB56oHVXkRo8Jr1mFbVavglLX50tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1TFOGb1IOUd5FEYgX6MVA33TzU7luPMl6sRYuR1pPno=;
	b=i5WqITItNJQ78VQMdQDDqiScbZ7ohOpZaYGj08nnF7frgmJP2czmnOmkqEkFvXommJ3t
	 OPLiX52KeOXbaRzWQlJ9MKgX5wL2i0bmisGphhw6MYUbfZPfhQZVUtgkSWLwRu10zOu+3
	 AS5l666OKIkjlW4Ve7C+1pri7TmGg1dEd94WvpfXsr3siAPhtJy8nD/YUkCT8wmk3PC/5
	 d9LGTH5yA8eLYInFAcUfnmoS7ariPF4SfPa0Ok4AQNPUZQ//A3zFjDQQFOXZ9XAQKrMSZ
	 FibqqUx1bKJpIXgCDB0BqJYqaY5wIUvvmKszu+Sq7NtHDNtQrfMO6vO9bCzVAI8voWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgAYZBzo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F78C606A331;
	Wed, 18 Nov 2026 15:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hgAYZBzo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4B71F000C4;
	Wed, 18 Nov 2026 15:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015690;
	bh=1TFOGb1IOUd5FEYgX6MVA33TzU7luPMl6sRYuR1pPno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hgAYZBzoNqSUSWIrFlBdUoo84+APmZr7jKyZrvNcbKgrGpdaJFdKqq5bVR4pDijc8
	 s0XF0xdblfiYTcTJ+x1YHeFh+tk9Rw70vQ7E6CphyRPCwZ//y+WKsoscM529VqPozc
	 v3OAeldOaHjOs8JmowRj12Ymxa1Ug6QynoRPQPT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Belwon <igor.belwon@mentallysanemainliners.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0264/2651] arm64: dts: mediatek: mt6878-pinfunc: Fix pinctrl header path
Date: Wed, 18 Nov 2026 15:25:04 +0100
Message-ID: <20261118150257.404094559@linuxfoundation.org>
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

[ Upstream commit 9b9c33336d2c25b6ef8758af3ce3c1802d26ca25 ]

The header resides in the dt-bindings directory and not in the
dts/mediatek directory. Fix it as to avoid a build failure.

Fixes: 07a9bd3079e30 ("arm64: dts: mediatek: Add MT6878 pinmux macro header file")
Signed-off-by: Igor Belwon <igor.belwon@mentallysanemainliners.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6878-pinfunc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6878-pinfunc.h b/arch/arm64/boot/dts/mediatek/mt6878-pinfunc.h
index 4e8e475a74549..5aeceb904b18d 100644
--- a/arch/arm64/boot/dts/mediatek/mt6878-pinfunc.h
+++ b/arch/arm64/boot/dts/mediatek/mt6878-pinfunc.h
@@ -9,7 +9,7 @@
 #ifndef __MT6878_PINFUNC_H
 #define __MT6878_PINFUNC_H
 
-#include "mt65xx.h"
+#include <dt-bindings/pinctrl/mt65xx.h>
 
 #define PINMUX_GPIO0__FUNC_GPIO0 (MTK_PIN_NO(0) | 0)
 #define PINMUX_GPIO0__FUNC_TP_GPIO0_AO (MTK_PIN_NO(0) | 1)
-- 
2.53.0



