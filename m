Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C94123AB86;
	Thu,  3 Jul 2025 15:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554905; cv=none; b=HHNNM2bOhYc/tdPvYcO5AApGHTlfcAW1cEkvedLiT9CAzNbBNU0R7RZXkzS8FAq8EOwRCiSZEzZsjfjFc5aMP62ePu5g9PLZjTOASUQE6y6AiAYGTzb0yj1IzRB+lUoKBXbqCAnZkDD7Tzhx1oAPuD51EUYjaUBeTnyeDn63pB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554905; c=relaxed/simple;
	bh=5WTw0QummOcopUAAkhJF2auLxxBWPF0kgaVSOlnMaHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKHUIN1xDf0sAB5udEZG70g9qyKi245OBgD75efBXGNnYk+QwYghRBUJjkdr9GftlfRJVI+0fHZicw5bDKRwA7FUO7IEJ7Xj2s9xdJwYYaH5+1vhzuZnQuYMp24BbYUSzGKsbBdX4HpJC+BpIrPPILeY5y/5Flz3lEjdgqC4kfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xuHkbkRE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xuHkbkRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF6AC4CEE3;
	Thu,  3 Jul 2025 15:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554905;
	bh=5WTw0QummOcopUAAkhJF2auLxxBWPF0kgaVSOlnMaHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xuHkbkREzcKlgvvKEj1D/iNqM7asuODjFnn1gLnRY9kLa5USyANGVAfOnx/scK3/h
	 YpNinOxVBJMyCg2aBn4Zp45HbHTdXWgkSxJ+fX1GzSdC5dOJi2icTJYX3nfVYJwYMT
	 9P6Hzw5oygZCSGSdfS4eN8qxC22Q9BShqTOI4bWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Klara Modin <klarasmodin@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@dabbelt.com>
Subject: [PATCH 6.15 115/263] riscv: export boot_cpu_hartid
Date: Thu,  3 Jul 2025 16:40:35 +0200
Message-ID: <20250703144008.953359344@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Klara Modin <klarasmodin@gmail.com>

commit c5136add3f9b4c23b8bbe5f4d722c95d4cfb936e upstream.

The mailbox controller driver for the Microchip Inter-processor
Communication can be built as a module. It uses cpuid_to_hartid_map and
commit 4783ce32b080 ("riscv: export __cpuid_to_hartid_map") enables that
to work for SMP. However, cpuid_to_hartid_map uses boot_cpu_hartid on
non-SMP kernels and this driver can be useful in such configurations[1].

Export boot_cpu_hartid so the driver can be built as a module on non-SMP
kernels as well.

Link: https://lore.kernel.org/lkml/20250617-confess-reimburse-876101e099cb@spud/ [1]
Cc: stable@vger.kernel.org
Fixes: e4b1d67e7141 ("mailbox: add Microchip IPC support")
Signed-off-by: Klara Modin <klarasmodin@gmail.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://lore.kernel.org/r/20250617125847.23829-1-klarasmodin@gmail.com
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/riscv/kernel/setup.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/riscv/kernel/setup.c b/arch/riscv/kernel/setup.c
index f7c9a1caa83e..14888e5ea19a 100644
--- a/arch/riscv/kernel/setup.c
+++ b/arch/riscv/kernel/setup.c
@@ -50,6 +50,7 @@ atomic_t hart_lottery __section(".sdata")
 #endif
 ;
 unsigned long boot_cpu_hartid;
+EXPORT_SYMBOL_GPL(boot_cpu_hartid);
 
 /*
  * Place kernel memory regions on the resource tree so that
-- 
2.50.0



