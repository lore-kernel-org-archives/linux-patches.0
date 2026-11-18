Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041028;
	b=bBWx0jJGOtexTshqXsLk5I/PyDEKoe9jjf1XelAZK3DuqtHaY/Hszsk0V24xDK5zvGMS
	 m+pOYoQrXDzD7IFkOfByGcnNCtpfa2FwVyrv7KazigpHruLNKK3dt+GJGzwGsNxfw4Cc4
	 cIgu52n7jpQhOP0wmR5GYBRVbtFckWtRPbYfTIE0WMm4m/e/tNvcrXDCYxJKOkw2wHZ4S
	 ygokRX4wf3GqxwAWJRc/Lo8MWmmieQn59WlhamdANAM/DewrKh3Bgm2/HIR8OXfFwJlox
	 xSWXguoLMFU0kGuxu9S80EIsuY2ovMpaodlkQG+ueeglyE5G3fxFJWUkmeADLhGC3tQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=84z0KklDElRJXEmo15qWVqqmBoRuYc8Tp9JC51T61Ks=;
	b=VRKDVRwP1Y9tApzQrEt5zvUQOxGvbBZ2wTNYJNikpjPMnlNRqh9dgMUNkxMDiR43sQMY
	 nQS8IFpayi+LpJejeYyw6vpKn10qiCk6+T7BFYxtMFCeiREu6Jci5+6unRv1beSklu0Ud
	 uqGH+QxN+NdPb3fn3s6UU4fLyZkUu2STK9218VPCCEkRhja1KGDXmNyHJKUTIFpApdbgd
	 pWPuCKQQ55PLrXUPOQrMneGdRw1IyQ1liZ+dv91nJmx2mrIs1hKYodpQ7FkJ7/BglZpRk
	 0xOT4nEV8FBQ3w4rFLNAAbbItocW/7LkRKlb4eVlmJOwBy0vc7umSv/t7ckVTyah07Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwgS8WhL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D7C606A31C;
	Wed, 18 Nov 2026 22:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NwgS8WhL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A7091F000C7;
	Wed, 18 Nov 2026 22:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041028;
	bh=84z0KklDElRJXEmo15qWVqqmBoRuYc8Tp9JC51T61Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwgS8WhLqIx4t0czQuaLb+olrK6eXpVRHT16G7O+nO9Xnn87oumq6rywLL/bJwrH4
	 wcG91c+24f3/kKvy6qFCAi73+drpWZd7p52WunWj02HdE9w5VDQ4yo36uj+B21tQJ1
	 ukyxtBk8+Aq4aECL/XSoeFrg3A4gpYzhUoI4z3f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jisheng Zhang <jszhang@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2630/3318] riscv: fix RVG_SYSTEM_CSR_MASK width mask
Date: Wed, 18 Nov 2026 15:54:12 +0100
Message-ID: <20261118150439.992794350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 09fde95a5e8f7..b4feda0622f63 100644
--- a/arch/riscv/include/asm/insn.h
+++ b/arch/riscv/include/asm/insn.h
@@ -141,7 +141,7 @@
 #define RVG_OPCODE_JAL		0x6f
 #define RVG_OPCODE_SYSTEM	0x73
 #define RVG_SYSTEM_CSR_OFF	20
-#define RVG_SYSTEM_CSR_MASK	GENMASK(12, 0)
+#define RVG_SYSTEM_CSR_MASK	GENMASK(11, 0)
 
 /* parts of opcode for RVF, RVD and RVQ */
 #define RVFDQ_FL_FS_WIDTH_OFF	12
-- 
2.53.0



