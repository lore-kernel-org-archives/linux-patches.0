Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217195;
	b=Z9zd1sJSk+V7Li8tIPz0+IGbUKRNpGUvcIIfgxe1xdByqoduepfaYuc9Hqpf53IgR8Hn
	 oTQ9iw3rQDL+HOOIdpeQSQ/JOV2ceIoahsIHYQQnmEc2/dHaab5yXpflCnoJlzitJ/z/o
	 CGkGiIlajpCJDAEfNiparn0iMp8LE4/WuMoI34YfsxbA0htUdRe13LnTQwzl09BDPEufL
	 o/wBINgH4Y61yO1o5XMj4TlS/Qu+DCjZaDK5Ac8hUy1BirTnW0LFXxjAYz4K2YdzRAE7a
	 L56gBdEdhCxVbv2qOb5rkHvSqP1/xVVz3xHL3ObLdbW7eZLAHkmyPvpgSHqur5gnP+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=nc6EqFxmuzfT4So7E6/fA2IXoIWuL/XlJOYTp2DO9vo=;
	b=fHSfw7uiAIo6IGYxJ4CTbiPvrOR/hGgEMs66Om+d5cGuBm/PvWeajTifTl41KFpG7sw3
	 TY4V9ZBjbAseONmvnHkUhritCtZ8LhnsvOc039Dp3SCKeqRYw/gGb5141OV8THiZEv+2g
	 j7ofg5UsppX0I+WQrmgXOevmDLv8Hx5/mnsLtfvjug8ZGFX6FC0BrunVzF3g5q4fwICqm
	 2ubbOa0OvEq2FBpn0JlgVzCIcJwNw69h6D4MTt/s9lzfHcNcwrHEteEdZAgjCYQEuzmLt
	 gaWyJiBNMiPOb8v4YH8p0rfzxTId/W3xBF8Fdix9Vkqktrn2Vfv4V/+aEg3lxS8xm3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n3N+LnRm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732C3606A31A;
	Wed, 28 Oct 2026 19:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n3N+LnRm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDF61F01825;
	Wed, 28 Oct 2026 19:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217195;
	bh=nc6EqFxmuzfT4So7E6/fA2IXoIWuL/XlJOYTp2DO9vo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n3N+LnRmOL6+0oAZ2p/bmVk0T+KWvUKWBeNVLO3uML6vZPOuMnz0+mFnjctbhFENo
	 Xd5luavNDDUDKIJ805c6EdQSCKv6rOxlBzJ3b5Em6P/zjcENVSLOHWMTpWoV2nRHQu
	 lklesxaJz37DaGTHZdPOxnsHw1ZUyKyOPMjwChC8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	=?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@ventanamicro.com>,
	Paul Walmsley <pjw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1820/1887] riscv: use lw when reading int cpu in asm_per_cpu
Date: Wed, 28 Oct 2026 18:05:16 +0100
Message-ID: <20261028170540.857528094@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Radim Krčmář <rkrcmar@ventanamicro.com>

[ Upstream commit f4ea67a722e8c9e1fb8109adebb9fb881ff0793a ]

REG_L is wrong, because thread_info.cpu is 32-bit, not xlen-bit wide.
The struct currently has a hole after cpu, so little endian accesses
seemed fine.

Fixes: be97d0db5f44 ("riscv: VMAP_STACK overflow detection thread-safe")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Signed-off-by: Radim Krčmář <rkrcmar@ventanamicro.com>
Link: https://lore.kernel.org/r/20250725165410.2896641-5-rkrcmar@ventanamicro.com
Signed-off-by: Paul Walmsley <pjw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/asm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/include/asm/asm.h b/arch/riscv/include/asm/asm.h
index 9890a42c18103..c61f56fa3ff30 100644
--- a/arch/riscv/include/asm/asm.h
+++ b/arch/riscv/include/asm/asm.h
@@ -90,7 +90,7 @@
 #endif
 
 .macro asm_per_cpu dst sym tmp
-	REG_L \tmp, TASK_TI_CPU_NUM(tp)
+	lw    \tmp, TASK_TI_CPU_NUM(tp)
 	slli  \tmp, \tmp, PER_CPU_OFFSET_SHIFT
 	la    \dst, __per_cpu_offset
 	add   \dst, \dst, \tmp
-- 
2.53.0



