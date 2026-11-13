Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585462;
	b=4dxtmLIdAok8vcPj2ydZ4H7Ep8XQDNsCwfwQb/rFGBF/9nJTLI+fsfDvJh+d1iBCG69w
	 ZbtkKgyQPewHQiWEPqPdDNxWI2SnqTVr8BQkQw3ei8o7j6v3upJSS90FpBefNplKB1H+o
	 dQkPeBhEH7ThvC7W90WFGDPbulfA3KuOtEwA2FlkG6pD/1tfT3sCClkV5QzrDL52q6FBe
	 gmdovbRdLg0tLGUmgGA5ae0tS0LQmQRGQAGnOmbXM1YMb7UlvmJ+MCqIWOxm6Aubrm60F
	 MH53uQ6DBvm8LNZKhMp9uj2qMaEpI+1c0vv8ZoKNnF0q+soJj2Ku+hHW4Olichp9ciw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6er7Nq8k1hOFD6BCdsWrMCs0ICI7DaWm5ZdWSY9gazM=;
	b=L3lb6osI1+hcuPuQxPV3N8q/EDo5mUqHUfkY/ai/rJcEEA5rzdkK3UFSC2HwMMoJxTYJ
	 7cNGgsyEEqea+2Ny5TgsT/NPa6nAfo7M5mrXHox6djKzdQ1dkf2f14vWb/0TCz2HYka37
	 og/5RFxf+KPlvXkXt2k3UwsYrzx00wO6UhpJoPZNnqK6nYL/L17+vy/CjdfdMrde8SPye
	 TdweCyyaTmuXeTR6C6qBKUZitK2ikqWiouOS5Pk1zbhEh6cU5fQSvFfWxPTSYN8xhAdgb
	 NcfN77pq4fJHcZuH2aeannHQ9JIdtU6/JLWCEFGJig7n2Z/qauAumooPCTVNTNTHxJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FrM6SYZl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDC760A6F4F;
	Fri, 13 Nov 2026 15:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FrM6SYZl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B26F61F000C6;
	Fri, 13 Nov 2026 15:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585461;
	bh=6er7Nq8k1hOFD6BCdsWrMCs0ICI7DaWm5ZdWSY9gazM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrM6SYZlzBmTSo2fSS7ovo3qluNqCG63Yo3iVkQ50mKQ54qZkt9CCfFS+HlcrHPtZ
	 7u4oeRYNpBzX9NVoBI5qHnxLiGx7CvO0xZyfND6TiCReBdZcWQdjZnqaadFPeKEoJt
	 /8mJVGz0JUubr5Vvvg0FAKbgqdjBfDZZVt6UE3WE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernelci.org bot" <bot@kernelci.org>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Rosen Penev <rosenp@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH 7.3 118/507] x86/csum: Relax the len and proto constraints in 32-bit csum_ipv6_magic()
Date: Fri, 13 Nov 2026 10:47:02 -0500
Message-ID: <20261113153758.346184062@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit f01a394fe2a00d3cb4cf2cda279c58604a2540ad ]

Building an i386 allmodconfig kernel with clang fails since allmodconfig
started building netfilter with GCOV profiling:

  In file included from net/netfilter/nf_synproxy_core.c:7:
  In file included from ./include/linux/skbuff.h:26:
  In file included from ./include/net/checksum.h:21:
  In file included from ./arch/x86/include/asm/checksum.h:9:
  ./arch/x86/include/asm/checksum_32.h:149:6: error: inline assembly requires more registers than available

The csum_ipv6_magic() asm needs five registers at once: the early-clobber sum
plus register-only inputs for saddr, daddr, htonl(len) and htonl(proto). With
frame pointers enabled, six general purpose registers are left to choose from.

In synproxy_send_tcp_ipv6(), the GCOV instrumentation lets clang's machine
scheduler move the copies of two incoming register arguments, EDX and ECX,
below the asm.

Both registers then stay live across the asm, which leaves four registers for
its five operands. This is LLVM issue #206307. The error goes away without
either GCOV or frame pointers, and it reproduces with clang 19-22.

Neither len nor proto has to be in a register: ADCL also takes a 32-bit memory
or immediate source operand. Use "g" for both, so the asm needs at most three
registers whatever the caller looks like.

ASM_INPUT_G, which normally replaces "g" to avoid clang's poor handling of it,
is not enough here. It expands to "ir" for clang, so callers that pass
a variable protocol, like nf_ip6_checksum(), would still need five registers.
With "g", clang passes a non-constant len or proto through the stack and still
turns constants into immediates.

  [ bp: Make Rosen Penev the author because of a previous identical submission
    https://lore.kernel.org/all/20260904000833.2058186-1-rosenp@gmail.com/ and
    Sasha graciously agreeing and giving his much more detailed commit message
    explaining the background of why this exists. ]

Fixes: 403cec8ab6d0 ("netfilter: add option for GCOV profiling")
Closes: https://dashboard.kernelci.org/build/maestro:6ad55fe255fda507603d2651
Closes: https://lore.kernel.org/a28df759-d0e9-41c0-97c7-5f89a18d54e2@oss.qualcomm.com
Reported-by: kernelci.org bot <bot@kernelci.org>
Reported-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/issues/206307
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/checksum_32.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/checksum_32.h b/arch/x86/include/asm/checksum_32.h
index 17da953879976..f74873a5e3510 100644
--- a/arch/x86/include/asm/checksum_32.h
+++ b/arch/x86/include/asm/checksum_32.h
@@ -159,7 +159,7 @@ static inline __sum16 csum_ipv6_magic(const struct in6_addr *saddr,
 	    "adcl $0, %0	;\n"
 	    : "=&r" (sum)
 	    : "r" (saddr), "r" (daddr),
-	      "r" (htonl(len)), "r" (htonl(proto)), "0" (sum)
+	      "g" (htonl(len)), "g" (htonl(proto)), "0" (sum)
 	    : "memory");
 
 	return csum_fold(sum);
-- 
2.53.0



