Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025641;
	b=ctts+lU99WUZ99v5pnXyG2rIsXrRxaZDNCL4keNDaYUYfBkEILBJvyRTEeZbyobOzL0O
	 IACJ8IowBP6wtv52tLhA11ZyJtbEJO3ZickbijfdNxxxilJ7IT9OArujFklmuPA2qrt0D
	 fJvFINwB1Gul+j8vnG9GBU4zFMyWMWzqA2D2mkHI2HyJAYDzFGYQs5xBlkIpecVpZGqts
	 /0up6WuPS8a9J28NiUX4btWFu+upfvL6LYVvVIo/xjYt7zlS1aUM5SSSrpbYt5pkAX3ck
	 Zbpg7oN4OqZjgwuDU06wFKUIlWUR15cGLsKpV4R0JzuUYvyHuHCkDXAKhWXEWC/JcSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025641;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jMeg4IWrNiFTIOzHgMZuuWsR6C2ZloI5MzRP2T2vrYU=;
	b=dRDSX33UZES1nh3nHWBdcl6iWpiuSZjxswIBdLuRA4/Nw8wzCIlriDoU3Z0camYEmm4u
	 P+jKOZUwk2weWNoN8hqztgUgKtGwM0AMmXpsaKaZSFhBrsUWs11i5u0pIQOU150dHqwE9
	 wOHB93nTA9oZ59PIpTNshENNTg6b7cmipAcU068O4HWp9DWufFt5HUUfnb49JE92Gquly
	 yzDHbMWS/titqwco0FOtMQDVDxHHt1bq7X6pbe019B1HRkORAC8kNFAjawJKCxQZT6O7P
	 ftHE2GAXHFrFoeKG4FuzT34wPLJL3ZA3cw/2BVZ4tK828VC3o8inqjk8JPqeYD5XObg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFXhPx9z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50412606A325;
	Wed, 18 Nov 2026 18:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nFXhPx9z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C1B1F000C4;
	Wed, 18 Nov 2026 18:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025641;
	bh=jMeg4IWrNiFTIOzHgMZuuWsR6C2ZloI5MzRP2T2vrYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nFXhPx9zM9zMm8KtpbztIw7kl+bExHjtRSgrZT6dN4mRzxM7bYG6gkjgtnLFtG13/
	 yLH3SotUMWnqVMos7xQ7nM5PUzvR1kHti9fgx/HVTub2Jdr1aBhKIsVGPQwkZwt+Sn
	 btC+qXWCbx7q5on8Bv8VXJ2bCtHF+lC7FG877zzg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jisheng Zhang <jszhang@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1149/2151] riscv: fix RVG_SYSTEM_CSR_MASK width mask
Date: Wed, 18 Nov 2026 15:48:04 +0100
Message-ID: <20261118150204.037196287@linuxfoundation.org>
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

From: Aurelien Jarno <aurelien@aurel32.net>

[ Upstream commit f89e5ee4d8c6cd56499cd87e550d4d4e19cf7e17 ]

RVG_SYSTEM_CSR_MASK should be 12 bits [31:20], shifted down by 20 bits.
Replace GENMASK(12, 0) by GENMASK(11, 0).

Fixes: cd054837243b ("riscv: Allocate user's vector context in the first-use trap")
Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Reviewed-by: Jisheng Zhang <jszhang@kernel.org>
Link: https://patch.msgid.link/20260911194233.3379532-1-aurelien@aurel32.net
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/insn.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/insn.h b/arch/riscv/include/asm/insn.h
index c3005573e8c99..ad348d8b88574 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -142,7 +142,7 @@
 #define RVG_OPCODE_JAL		0x6f
 #define RVG_OPCODE_SYSTEM	0x73
 #define RVG_SYSTEM_CSR_OFF	20
-#define RVG_SYSTEM_CSR_MASK	GENMASK(12, 0)
+#define RVG_SYSTEM_CSR_MASK	GENMASK(11, 0)
 
 /* parts of opcode for RVF, RVD and RVQ */
 #define RVFDQ_FL_FS_WIDTH_OFF	12
-- 
2.53.0



