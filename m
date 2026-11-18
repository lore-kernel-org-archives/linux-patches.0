Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029582;
	b=S37TdtMtp3nvcRXn/S9Rn8LVW+lJaEHwo6TROGGvoTYKpz6tDXWHSw3c28PP1icWtiDp
	 9WqRj3fN+LXSzFmiNr2OS02zjYLOkYtAUcl0N7ZUQuV22EbQIEDfSxlBIYNw2D4pf8DDn
	 Bhk/M8u4hHjFhAklHKIG5y5FJAu8wo481xJlhLF8UuYtCi2a+JyLJ90v9iFx/d0oKf2+E
	 iPyxJHsiSaN4PcxDBYq+0TNLCwXy/fGQBPdrHCrF+16DUGl/KBNTKRij5gOJF77ZVxIXb
	 841cZXdQSFzvkhdK3LZHalOtO1VXH+jvNlePR/nbhvqbYcHTiskhLYfJUcCBPcMCFxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029582;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4UvlmhAXVXQlOW5gw56rhLWKRxuPYJq267WUcmQAJVQ=;
	b=lWHVFucM26LbOTQnkK3ZxzsB1JxeVgF5x19LYi/eOwvf2yIafQBA9YgzSPOBoGqVTP6a
	 2hRFfZxgtoC7YXn39O2dpK8H7T0SfBULhk5lwugGAZSv9xEToRrsIs/Tcn38hRRz8l9ez
	 qdBslW4iVCpPb+Yzh9dPh0rCwk8LusyRXHnv32hNw65X2qwmfUqDNLZKOWUPPBMcXzhUy
	 RuoA4kAcAdU0LmHaOj6LC6bPLxarVpyVT+JlCiqTVtbfx3U8oklg4ZfZ3IRf/SzW2BMSP
	 eTlvuK8gw/zpR7qk38o2FthS26k22PGPF5dBUvJJhaGJUhb/IXPVzd6Qxw6N7fr5Gtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XEzDy7zx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F31860A2600;
	Wed, 18 Nov 2026 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XEzDy7zx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686781F000C7;
	Wed, 18 Nov 2026 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029581;
	bh=4UvlmhAXVXQlOW5gw56rhLWKRxuPYJq267WUcmQAJVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XEzDy7zxFCWcf7e8TxTki+xAzSGj+rIUN8I4ryPC3ZR1RLtvdwWaJ/U9+0bP1pVmG
	 fRZJ9UZzUuMZSRgI8/DgneKVjZK2+NN02vt5m6JtamfHQMZDOQ9Uayl/k6UgpDJZEc
	 nYxs5+AbDECR0Y1KGU+2+D77lQyPMzlguOh76xUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Zyngier <maz@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0401/1756] arm64: pi: Run the source checker on the libfdt objects under C=2
Date: Wed, 18 Nov 2026 15:42:08 +0100
Message-ID: <20261118150024.728694343@linuxfoundation.org>
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

From: Fuad Tabba <fuad.tabba@linux.dev>

[ Upstream commit 44b14ff4aebeae98663d0fd424b4ef88237ee981 ]

The custom lib-%.o rule reuses rule_cc_o_c, which hooks the source
checker only for C=1, and that only when the object is rebuilt. The
C=2 hook, cmd_force_checksrc, hangs off the standard %.o rule, so
"make C=2" silently skips the two libfdt objects. Call
cmd_force_checksrc after the compile rule, as the standard rule does.

Fixes: aacd149b6238 ("arm64: head: avoid relocating the kernel twice for KASLR")
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
Link: https://patch.msgid.link/20260901140326.3812068-7-fuad.tabba@linux.dev
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/pi/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/pi/Makefile b/arch/arm64/kernel/pi/Makefile
index 4d11a8c291816..8a475ef279fa1 100644
--- a/arch/arm64/kernel/pi/Makefile
+++ b/arch/arm64/kernel/pi/Makefile
@@ -34,6 +34,7 @@ $(obj)/lib-%.pi.o: OBJCOPYFLAGS += --prefix-alloc-sections=.init
 
 $(obj)/lib-%.o: $(srctree)/lib/%.c FORCE
 	$(call if_changed_rule,cc_o_c)
+	$(call cmd,force_checksrc)
 
 obj-y					:= idreg-override.pi.o \
 					   map_kernel.pi.o map_range.pi.o \
-- 
2.53.0



