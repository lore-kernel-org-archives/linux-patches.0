Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062441;
	b=mFGF5/VkBvMt+4cM69zAzePHGfxK4Vt9w9gYrwHITVkbI+9GJ+3FGfyZGw97jEH0CipD
	 sEdUVZx/ujPz2miPJHW8Agh+wWRQ4TcBNHRZl71TK7MNQKVcbN6iymQNqw1/CtQz3/qRa
	 j+xcdO8Xo7pETnmdA8oVl2TvLl88DevRaZhuLeNw4dnUIOm7qzLt/Wd0kgi8xEojvezOy
	 DyIh7ji2VPZaBeEc+qC/FPrrNtdXE6/ntt3eLhDHoYI8bvm+Bt7voC50Qx5NRrGxHVXdu
	 C14pLyKflXyQkc7djDXVNQx5nlND0dQMCqbdXHcBOjD62jdWyOhnz7+DJrPZgxkNB1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062441;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M6frXLO1mpzIzg3YUQ+6oTOZRW8HdX9+JUxilkiKOT4=;
	b=0zntFmLPLmOTGNt14oy4RWPmvSBd4wi7qJbhWiOOIWE9GSBThcFVKt4syS5mMO9ZA0ut
	 lC0AOSPily/GBx+m/NzOysYQCacCJ0li3uJgDCVL+Rb9+nty7/2xSinE21lM+dZ+AC53n
	 WWSSRspXEsllJa2GQZbRbwEYfIpAvsk4QPAe12TKNP0l3YmXMQ3drDeJi0nCN555JKVA3
	 VVukXFD9fuVgX59OOPqqJEAX/qWTfD3VZcvmtbeTJ0o8E1cLCx070dvSsF3TI10nTGxKE
	 c5hm3CBWiQyWPHGJ/rXZMtJuRem98IdQvRSzqGIVLMrTePHwzA6hpH3MhQn6+ZYWlKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMCwmaDb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2FB606EEA9;
	Sat,  7 Nov 2026 14:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pMCwmaDb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 097E41F0089F;
	Sat,  7 Nov 2026 14:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062441;
	bh=M6frXLO1mpzIzg3YUQ+6oTOZRW8HdX9+JUxilkiKOT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pMCwmaDbGP8Ko/a+QjJrvvce3K4hJkV+mUmT1kAEXFhFWEn9jMa/9UBGLjTvtWjbK
	 6EuCLoJLT8wKfk6N63QXSq8oviJ/kfjMT8uffXX0SIbQ+PR0Pi6NFX1F0Ns8nBm4hc
	 9bPLqX9CN/Z8Y/S4jEceWNv1liwr+ZtFi/hGWXDg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1350/1536] alpha: invalidate the local context in flush_icache_user_page()
Date: Sat,  7 Nov 2026 08:56:06 -0500
Message-ID: <20261107135035.744862147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit 4244c555ac440a445cc168f860b2677099d761f9 ]

flush_icache_user_page() has the same caller-CPU omission that the
previous patch fixed in flush_tlb_mm(): when the target mm is not the
calling CPU's active_mm nothing happens locally, and smp_call_function()
handles only the other CPUs, so this CPU may later reuse the old ASN
together with the translations it still holds.

This matters here in particular because the function exists for
operating on another process's mappings: the comment above it describes
setting breakpoints through ptrace, and access_remote_vm() reaches it
through copy_to_user_page(). The calling CPU is therefore often running
something other than the target mm.

As in flush_tlb_mm(), the uniprocessor implementation in
asm/cacheflush.h already has the missing case.

No imb() is needed, here or in ipi_flush_icache_page(). Alpha's
user-space I-cache flush works by allocating a new ASN rather than by
invalidating the I-cache: the entries stay, but they are tagged with the
old ASN and can no longer match. An imb() is only required when the ASN
space wraps and numbers are reused, and __get_new_mm_context() already
does one in that case.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-9-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 988e397b0b8a7..e21bc3920bece 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -758,6 +758,9 @@ flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	smp_call_function(ipi_flush_icache_page, mm, 1);
-- 
2.53.0



