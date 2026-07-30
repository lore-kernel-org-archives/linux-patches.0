Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EB344998D;
	Thu, 30 Jul 2026 15:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425325; cv=none; b=nkQBlRME+NMayIY4EPzTSJqQ1oI/0yCjWEQwNBtVNhWK87lHPJi0gEre0gDSfhxaQUMcLd43AqBOHYD7KinK7gA+xXljI5U83OS8vnUV7Klq2lNMprNNGZgOeoUfzNncbU1J9DVhTLxYva+rBlhB99ql14r2DUJJ+9HjtaHk0I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425325; c=relaxed/simple;
	bh=AiTP4b7MYo1Ypw9xFbVgCHyNrKaTuUrQhUiJ9fWaBek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgOXiigWX6U57LvC2+WvGxcxCGo7xPsTzqP9i2KlOJy2f2jAVxp3lQwYQ2lWcnqhYvzfiYEe3lrgBmoyL5XzHVcINbJdbKHSX9+ZxLkrVIOCpHcAz8dflkfF5wX+xBxBoggJcm1+ZmGNcPpsybO+QdIGYrZGfkx0JJhdUTmm5FU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g9cDGbgW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g9cDGbgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E70AF1F000E9;
	Thu, 30 Jul 2026 15:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425324;
	bh=8v54NUtEbsPtbPoqxTK1we7NKHOyqVo/x6dGKFIQL6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g9cDGbgWNxNZH+l3E9e1uj3oF5qimY+/+D5LwHuNgcBIViwHo1T3+7oPm0sLNTY4P
	 +s1/HN4EHZ62xZpa9RvnsIiFR/gKt7MY4zlDBFZd5coNLhy3ParGCHq+SE/SXKNoa3
	 TAfmiu8LAOfKyy9JfRCchBKsheFsSFnGcu0Rwnck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/602] Revert "arm64: dts: ti: k3-am62a7-sk: Add bootph-all tag to vqmmc"
Date: Thu, 30 Jul 2026 16:07:01 +0200
Message-ID: <20260730141436.619666694@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 1b21939117aea112f6b7fa67bba6fb43d2a8e8ec.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index f94378379447a6..0b6e371eea98d2 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -134,7 +134,6 @@ vddshv_sdio: regulator-5 {
 		gpios = <&main_gpio0 31 GPIO_ACTIVE_HIGH>;
 		states = <1800000 0x0>,
 			 <3300000 0x1>;
-		bootph-all;
 	};
 
 	leds {
@@ -382,7 +381,6 @@ pmic_irq_pins_default: pmic-irq-default-pins {
 		pinctrl-single,pins = <
 			AM62AX_MCU_IOPAD(0x000, PIN_INPUT, 7) /* (E11) MCU_GPIO0_0 */
 		>;
-		bootph-all;
 	};
 };
 
-- 
2.53.0



