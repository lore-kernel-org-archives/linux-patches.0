Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018798;
	b=Z53uCX0d+9bExoFWuad6WwYToLrjlGCvmdI5abd/xxn6CerFPjSU71eoTMmb+jh76+Vo
	 Hi7PthJQm340Ix+L7IsirYjNMzivYdOa+5PuYBq5SbnYV6qQBKpOL7UCGMeYLCxWZa6L5
	 t2KUU5mKHelAo0BwfESJIpMD7lB7r0P+7i5hDpBSlnAc3WLmEQiu7RmUm2BFuJQZY2JAM
	 rbeAbjeAPT05Yc3d4abbfgJs1uJLhQZvl1qwU0rnpL9Kj779lY/drciIZsmF1x7Cb1LsL
	 9EozCTzGpVdli0ktk0fCqxhFhkCiRABXfSpJ1uYYTwLr7BCPM/4F6YcnxWngyFBOm2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kIRqa4ZcTT2iW6o8m+JaFXk8vN/tXLqet8WZXn7DM7M=;
	b=lBZATpvS3v5O7ru001o9vGQUUPqsC7idHTEBArIe0SVKfLhMuXECKc9CYgsaSgAWQdca
	 WMIe1AC1j7vIeJUZCJIx7j1VO1TdTM0VpsCKZJqCPkze8OUCAJqN+6ASb32sfvTOgAxvo
	 JOksFb6tnZITlcBaOl2Yq3UStUrg6RZ0NNDg49BEEO17/AIzOXCLgl2oIJ+X6ke8yRr1c
	 COPSxyRUDHUoRT1Tdqt7uneLeaT9Lt9TEoK6XXHE8iclDEuFjeFeuBv9F4NnuNq3BKzRU
	 50/hlBODB8llXOQAzPSVuUCXGxeVT+Xs/nWY4HaYRuVKbdXoRLx5cgcsaN/xicJhJUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZtFNL2Td;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EA43606A325;
	Wed, 18 Nov 2026 16:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZtFNL2Td
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0072A1F000CA;
	Wed, 18 Nov 2026 16:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018798;
	bh=kIRqa4ZcTT2iW6o8m+JaFXk8vN/tXLqet8WZXn7DM7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZtFNL2TdEgnwZ3MfPbm2SSODB6jmkYcEPRXt6O07tCbd9j9mk5QM6SJbII49K0BSE
	 DfpW3wI+WDcj/Tm5jY9NIH0nPLXhj2vLWvovUNiTislEi5sUfRiOLrZ5aK3vpj22F0
	 GjUD2TTjMOy+3tAbAeGY2gT6VfTxRFhbEa6ALmW0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jisheng Zhang <jszhang@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1368/2651] riscv: fix RVG_SYSTEM_CSR_MASK width mask
Date: Wed, 18 Nov 2026 15:43:28 +0100
Message-ID: <20261118150337.279646332@linuxfoundation.org>
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



