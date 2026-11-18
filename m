Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045611;
	b=b/yu7t5f3gawPNbayr+wdI8YhKy1BH6+fY14tk7y3LD23Eor3/OeaTbmc+yfmW97dEB0
	 V/9YXj3Tt3j0U7/6NbA8ryAAURot/h/DK0llqto52gJ5fCE9mU86bgN8bNN0rCFoje0yj
	 vRv4kJXMN554N/FC5JAlTu7X3zIRDSWA0YcTZmIieSPFKtxGaX8d2UbVnLes4aGsAHT7g
	 2ZXQqmVucx24TPUEh/4gdFM4RFi2RoCkHNsabtANiN4j+Gmn1d1acM5kf2NSJsWBsllnk
	 Cx70GVMqLyIz4cx2y6sbgGiDB9uz1KPPbGYjvM+RCrv512cVUu6ZspBPXDtTicnYV2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045611;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OHLh/hVY1pl3bZ0PhH+bmLevl4ww+cd/w54kYuky93w=;
	b=p0xjYuBBch/UZLXIR8ko6fWwtpxAnMkX01+gNJMUdV3yKPxvn1bsMWWRHFzld8ylhrEH
	 Ub+5bmS26GMjfTuxCBZc3cQ6N+Os3MA+yR9Nv14gPhnh2mGsDPIDh4W3/Bj5wWNAlzWEU
	 hd7tKe4A9kLHDz1eSmIbjYanDkZHxNJXBMsKfdFJyeEJyxRJmdE/sFCdtbh/OtAxD8ynL
	 ClAvnBskwaMiXybqfZno03KZ0Wg8rVQlLPywrIIay7GvRjXBQA9tUxwjTxMTc0jXKwMOz
	 04tFnYhUf9o7MOyPzWN4WSSYuig6pudn1u+l00FA+1sHzu1XxH8dOTNN58ZtrJZYZqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoR9cgWu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E071606A325;
	Wed, 18 Nov 2026 23:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aoR9cgWu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFD51F000C4;
	Wed, 18 Nov 2026 23:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045611;
	bh=OHLh/hVY1pl3bZ0PhH+bmLevl4ww+cd/w54kYuky93w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoR9cgWuFBNVtg79bcD/gAyvistS7oLi1VrUIWVWeL+zYfEOQgp4ogHF2se3+HnOR
	 0ZoZthugUeCmj61+/R0DreE+Vd0Lr4DR6Jqn/3NbGDikhigYUBhXMHVYMa7am+Kvz/
	 h20t7CbKWeUC0kmFdN+CQBVTl9ULLyH6sN4o3rIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0983/2857] alpha: invalidate the local context in flush_icache_user_page()
Date: Wed, 18 Nov 2026 15:33:37 +0100
Message-ID: <20261118150236.999085471@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5f80f9682a828..afa4b990f9226 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -762,6 +762,9 @@ flush_icache_user_page(struct vm_area_struct *vma, struct page *page,
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



