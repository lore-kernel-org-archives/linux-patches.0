Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B01214A4E9;
	Wed,  5 Feb 2025 13:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763822; cv=none; b=W2vNEKgcIYGOiQ3wx6oMR78lFf1r3/E4sf/hWY3XzUsT+YNTtl6jYbSnY25AXDpdjmaa1eJ7jbS0ag4/eGGWotBnGv0f0ph3qtG1nJtt6ZuuJzBk2kL6oisr3CYRuw2UJYbdRg1iCpomonUKfc0s54TyQexaEOxkck9+zdqMDLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763822; c=relaxed/simple;
	bh=pA4ufWrSsj2awzUW7ZREFgacDO3jvchQGHOH5l0GyXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOF1Zrfu8Pj3fmi9MJ4+pdwsG+N0GzkGINZeHP7xBijvicizR6Jo9hU0urVUMJ2rO++PbVKTCx7WpBnN952gu2lk5rUU+j+PR3lej929BJ2zV6+Y4PtrZz/0EkXnlAVFQeXXd+det1tBQANUMy6KD8t6F9V65aJYhPwQo+ZixLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jdgqNG2W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jdgqNG2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB84CC4CEDD;
	Wed,  5 Feb 2025 13:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763822;
	bh=pA4ufWrSsj2awzUW7ZREFgacDO3jvchQGHOH5l0GyXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jdgqNG2WYpEosiCRt+r000VKk/tVXHVhOGKK3pcCHHCLy8Lm4fGeQbgzTEThaZPbH
	 0Lq7rkLj4LJ5dDzluIWktJW1swfo3GxFxp37QWVJfpNNMHzWlbwPVEbszAlhE2t7qu
	 xXExqBPjp/5Vy4tl3uPPbrnsJfCASj1fpQFC4fHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragan Simic <dsimic@manjaro.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Frank Oltmanns <frank@oltmanns.dev>,
	Stuart Gathman <stuart@gathman.org>
Subject: [PATCH 6.6 090/393] dt-bindings: clock: sunxi: Export PLL_VIDEO_2X and PLL_MIPI
Date: Wed,  5 Feb 2025 14:40:09 +0100
Message-ID: <20250205134423.737283148@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Khoruzhick <anarsoul@gmail.com>

[ Upstream commit 9897831de614f1d8d5184547f0e7bf7665eed436 ]

Export PLL_VIDEO_2X and PLL_MIPI, these will be used to explicitly
select TCON0 clock parent in dts

Fixes: ca1170b69968 ("clk: sunxi-ng: a64: force select PLL_MIPI in TCON0 mux")
Reviewed-by: Dragan Simic <dsimic@manjaro.org>
Reviewed-by: Chen-Yu Tsai <wens@csie.org>
Tested-by: Frank Oltmanns <frank@oltmanns.dev> # on PinePhone
Tested-by: Stuart Gathman <stuart@gathman.org> # on OG Pinebook
Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://patch.msgid.link/20250104074035.1611136-2-anarsoul@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Stable-dep-of: 0f368cb7ef10 ("clk: sunxi-ng: a64: drop redundant CLK_PLL_VIDEO0_2X and CLK_PLL_MIPI")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/dt-bindings/clock/sun50i-a64-ccu.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/dt-bindings/clock/sun50i-a64-ccu.h b/include/dt-bindings/clock/sun50i-a64-ccu.h
index 175892189e9dc..4f220ea7a23cc 100644
--- a/include/dt-bindings/clock/sun50i-a64-ccu.h
+++ b/include/dt-bindings/clock/sun50i-a64-ccu.h
@@ -44,7 +44,9 @@
 #define _DT_BINDINGS_CLK_SUN50I_A64_H_
 
 #define CLK_PLL_VIDEO0		7
+#define CLK_PLL_VIDEO0_2X	8
 #define CLK_PLL_PERIPH0		11
+#define CLK_PLL_MIPI		17
 
 #define CLK_CPUX		21
 #define CLK_BUS_MIPI_DSI	28
-- 
2.39.5



