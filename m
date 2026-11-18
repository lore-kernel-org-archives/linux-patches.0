Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052708;
	b=nkO9FmbZUTxQlS3E/GeyzSmXrKeST0X3E42WA5DADGaszPnXDoaOXcNSrQfRb+9Qv7Ue
	 x7rngxXTVp5DbaN0tH36/FQ5RXZDzy3+nZGbnhTYaBecC8FBDfDxe/EU9a54pkPrxLgln
	 B/su0z/4MRO0j7U/W641G9XVhVdif2BG/ILKS8C6aUnlA+YKfM4n9Rw7DVQ1mBqUR8u2V
	 vKyoCcNi5KwgycchYtfheolIW83fCXI/Vh/RSTfRYX9OpgJhOIdWV5C/QEvrRIZJ82ckV
	 VHk2etoTooxl/W3WECPiNUXKKXnCOd/ji0mfrf5dSh5QsOfkA4pLfiIPVf2yQQ3PBCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xwP3xDAcLndVAYcmNirGmDcgWZwMt3+/TG10p9w6tjo=;
	b=4Q/re1CXG9vzIdeKffcwE5LcmXjiWFoiojIryIkBkA3ZgpLxZyAXePurLaK92bbEQzS0
	 dkRRSl04d1QmpBml0HRmmzaUFAq9S+2cscEEbfCPzsWrESvu1m9osebR4SMVQU0e28e9Z
	 1n/AMwO6iao2Nx/trHxNfZ3ypzI0OC1+EpP7OQCzDwKHE7jC+R9LjrjQRpKIXvCq6n1/d
	 Ity1N0LPR+zZjDocQ63rUbSGZspv+6gtkC1bDcSkwPiaosCMLUKNAbyv9jZI00hy/Pwb4
	 zGMn3XIgG18IgEFSoEPLQlLZgdK+brd+/L8R8qgW3YJnJVBFrhIsWQJlP+z1dmFwGhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sGyrpQYu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0280606A331;
	Thu, 19 Nov 2026 01:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sGyrpQYu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9371F000C4;
	Thu, 19 Nov 2026 01:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052707;
	bh=xwP3xDAcLndVAYcmNirGmDcgWZwMt3+/TG10p9w6tjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sGyrpQYujj6UiD1YrDJs7zF7B1Mq+IZxfLDwlp2ahPJEQCwyaUKT6Vvv99CeOeF9P
	 tvhUIb5ozloJZubZZ+HyT8AA4+GRJAMnELQOgWj4SRmY8139H5zVSuLLgJBcihr8Xq
	 kOalWj01rW+Y6pV1einmRtRO7IiWsXcIy3NujJLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Turner <mattst88@gmail.com>,
	Magnus Lindholm <linmag7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0659/2214] alpha: invalidate the local context in flush_tlb_page()
Date: Wed, 18 Nov 2026 15:38:55 +0100
Message-ID: <20261118150038.033012644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Magnus Lindholm <linmag7@gmail.com>

[ Upstream commit c0db730bf05eb3c10c1fae64b19f6913dce129fc ]

When the target mm is not the calling CPU's active_mm, flush_tlb_page()
does nothing locally, and smp_call_function() reaches only the other CPUs.
This CPU may still hold translations for the mm and can later reuse the
old ASN together with them.

Add the missing else branch. flush_tlb_other() clears mm->context[cpu] so
a fresh ASN is taken at the next switch. Add this before changing the
current->active_mm test to current->mm: that change will also send lazy
callers here, so their local invalidate must already be in place.

The uniprocessor implementations of flush_tlb_mm() and
flush_icache_user_page() in asm/tlbflush.h and asm/cacheflush.h already
contain exactly this branch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Reviewed-by: Matt Turner <mattst88@gmail.com>
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Link: https://lore.kernel.org/r/20261010142533.974797-5-linmag7@gmail.com
Signed-off-by: Magnus Lindholm <linmag7@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/alpha/kernel/smp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 850974ed65cce..6c63b0d956e16 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -707,6 +707,9 @@ flush_tlb_page(struct vm_area_struct *vma, unsigned long addr)
 			preempt_enable();
 			return;
 		}
+	} else {
+		/* smp_call_function() does not call back into this CPU.  */
+		flush_tlb_other(mm);
 	}
 
 	data.vma = vma;
-- 
2.53.0



