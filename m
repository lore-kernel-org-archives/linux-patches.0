Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031017;
	b=pIhN6Pw15w70LnEQLyOadwbRnh1llDkp1OUUQcks6wwSmSkDyDkegfQJVOIkHoPutTJY
	 nhBCA6qUsM4sxviOAKW5U/Y9078wIIRcZkloQgXFvM2WUJDCgTSjtr8rZmJ1DxVy5Mjs4
	 o+7Bs/e3niCsbxw7dTuGojC+fCwbYFeefZWVTMD5eAaaymmz3FXTIgfNrX6NSNmZQBg+g
	 FJiD5mR4oOgf24h3KsoWptjOl9Xk/+f4OmEF/qkEzOEivsjIiZ4KkIngUwg6g9wDdtEhk
	 YCpn4v/CnY135uW04T8UwqP54hy8EAK4krRUA01/N5iXjYM5EtZnRjn2Z4Jt43jazZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031017;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=egsTGVjA+m/ZjrpXVaqN06KXqs7F0afOp1Q7oHLodnE=;
	b=ssk6nUQcRBaHkMMhrVCOuzQXbB+yr5GnnuwnJ3DbcyfWebaQhAro9lN6t0ceZSwvW9Na
	 IMky/FlcnNZhnOHU0MqMF4kzxFeE7CkReFZXKMBkMlWP21ifm7s6qKLL8axRuwgzSwwZV
	 L01ZAFWXhiCK6Ie+2j0JM04JcnVh7V8gWp5Sp28pR8h+pROc/dh36kWjdHS9jFcBU5o+e
	 sjVja2yNWQMEK/skj64JJvldP/mx1MF1Wt5w0vKBR3fYkg9ntqViJxAetEUxiwYi/aD9H
	 KETDh6A9mfJNiwwfES+cwY4zGYNsDp1+5eE2qe8iZVwU/Eun+kLEbb8FmV0VPCMzN2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fRv0bXQV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 825F4606A31C;
	Wed, 18 Nov 2026 19:43:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fRv0bXQV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFDE51F000C6;
	Wed, 18 Nov 2026 19:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031017;
	bh=egsTGVjA+m/ZjrpXVaqN06KXqs7F0afOp1Q7oHLodnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fRv0bXQVQR8t5gNGcvQivNwpTZdL0JD/muMb0qcHN33zIR3eYTHAP6BpdMeMGrbTf
	 5ct0gzxxPNYj0jewI9SuNnaNnXOLp/ROXJV6cJqk0Fpio3GcgnFglSihnvzK3tTdi9
	 HpuUeFKMsk756AiVN2PMK49KAJNtUvWRTZqmC75o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurelien Jarno <aurelien@aurel32.net>,
	Jisheng Zhang <jszhang@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0908/1756] riscv: fix RVG_SYSTEM_CSR_MASK width mask
Date: Wed, 18 Nov 2026 15:50:35 +0100
Message-ID: <20261118150046.126594538@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



