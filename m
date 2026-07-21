Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD41E46AA9A;
	Tue, 21 Jul 2026 15:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648385; cv=none; b=BhceU8oxW1zSef4T9SScfoflwu6hi3DXl2Fw9GBp/30atgHES97x+wAUUNK5pquXb2CEDHxFOA0rx7HCPpYCWB2Snr9ccZbC4mjJHYiuVNwWc7dY/9puWbqKQIkVQGQuPeRpEfehSM7NJ3s/dORDO6o55ct4yKZm5gB9x9SoCW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648385; c=relaxed/simple;
	bh=scUKIcSSoGF/2x0enJxbdc59PQQ4JgY3H0yipSUKUYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMUbYPYXcMQHQFrF5k+EMGA31nsZuSJ2eSw7Ff3O2m/eb57vIa6TJfYSJM7ZXSkwZ4c+5NexHqG2gsslNjdbYLG2/jXTxXtoX6Si0Ae+2+yjtRiaSKkNJ7swc39P07sfVBU4QuNlEiykhmsFPnwOOqDjccEY+sGqrkoojejD63c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BKSU0pkV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BKSU0pkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE821F000E9;
	Tue, 21 Jul 2026 15:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648383;
	bh=9yaHJ5icR4b0AeoTAxrRUmN8ALlRuBOdKEgBMq6IzhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BKSU0pkVZXvEwP9jdctI8kLRi6oUQRraOZz8GD1ZUIAis5SYN3T3GwXP2R1aNCShn
	 M+EfZ1R32oLggftAEfwwSEyfI7/n2z5BNfTZsh0Wy1NBsb+mq0YLt6WiGC3TjVibkz
	 c3CCDt3RMmjeW161UEY9gTy1268dr9udscSOj6nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vivian Wang <wangruikang@iscas.ac.cn>,
	Conor Dooley <conor.dooley@microchip.com>,
	Yixun Lan <dlan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0135/2077] dts: spacemit: set console baud rate on bpif3
Date: Tue, 21 Jul 2026 16:56:48 +0200
Message-ID: <20260721152555.874027365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Conor Dooley <conor.dooley@microchip.com>

[ Upstream commit 24c12ca43b12c104389d9a159207d0b25779d0af ]

Because the default console's baud rate is not set, defconfig kernels do
not have any serial output on this platform. Set the baud rate to
115200, matching what is used by U-Boot etc on this platform.

Suggested-by: Vivian Wang <wangruikang@iscas.ac.cn>
Fixes: d60d57ab6b2a8 ("riscv: dts: spacemit: add Banana Pi BPI-F3 board device tree")
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Reviewed-by: Yixun Lan <dlan@kernel.org>
Link: https://lore.kernel.org/r/20260430-reword-overstep-3be08b7eab25@spud
Signed-off-by: Yixun Lan <dlan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts b/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
index 5790d927b93db3..333ac8ebf3f516 100644
--- a/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
+++ b/arch/riscv/boot/dts/spacemit/k1-bananapi-f3.dts
@@ -19,7 +19,7 @@ aliases {
 	};
 
 	chosen {
-		stdout-path = "serial0";
+		stdout-path = "serial0:115200n8";
 	};
 
 	leds {
-- 
2.53.0



