Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207730;
	b=5U/oqKbuBJik50ujaFP9nZ8EhI5/RHceHiOLk/isVQMuKmKkspEgCEcqbsqPU4aPL4dB
	 vZXe0W9N41dHQw5G9nM6Sw9T1vHXEu/VIQfzwIKapGi4V2XngjvkPYaygkxzJHGPkO2fc
	 7pEb7zruvTK7EYwiDysNusUU5OtXKAOffzm/YxIZmXRqnVImhwy381O+1SdRVOKiuEGXh
	 R4UMCl6lx4JRjf7wwjqgyRXck7mlLYHom0HOKAAwRs680fKJPBAoLr0tCl4f37VwLwtUq
	 Otc2qjVUUpiqpmwoU8KmGYkbAEVUjC00E7RAqIEnxuNi7WJo4cpY9itr4PajnNqWGLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NSD65Yew0i3iZpoG68NslzQAjrAYYwos5h4TJmfCFRw=;
	b=SMHdsN7bL5oi1JkSJ+cwthrpyS8kcC867P4wLkNEzf1IvjdHzsssUhXjBD00FALjP7uy
	 Mx4NWeI045E8/aIMswAhrKjNMG/erzT3HkPG5TO8JlIdrjTiyVBVfD2qVR5q/PdenkcC9
	 WIdd8ZrnkGOP9tYVblECKpXDUyesrAE2gIHRBKANk4VzrSa37Eft1T2DSFXHGkzxF19+A
	 bzAnQCeDTe+3tCmR5vKScoc94wTZHkpeh/xKYS5aN66fxGEm74kDJYr68UGoyg2jsIeYy
	 FM8NE85QvA2xzOUfZSXMc0/YOqM7BXy+dJUtcVUUGpXBMuMcpbh68HhFqfZZ9vgK+0A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Y/3RXb2J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C09606A325;
	Wed, 28 Oct 2026 17:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y/3RXb2J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4371F01828;
	Wed, 28 Oct 2026 17:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207730;
	bh=NSD65Yew0i3iZpoG68NslzQAjrAYYwos5h4TJmfCFRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y/3RXb2JCuTQdUGmInUk0jcsu3PhWBLPTKyHCUFIKBZRcFI/gAhTNn4ZCPHJS2jlO
	 eC/L9krNbXB69eMGq8pOKY5WcW3GdXKF9YpIa93a5D4IX4pKAgFLrZcrqkrnP8o7Lx
	 n788TW0NBUr0uvZGzdIJrfeyrrdf3hBYvaSLL87k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"kernelci.org bot" <bot@kernelci.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 118/247] Revert "s390/mm: Add missing secure storage access fixups for donated memory"
Date: Wed, 28 Oct 2026 17:58:41 +0100
Message-ID: <20261028165950.195224804@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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

This reverts commit 74ccc099f1baa9236b8fb600406457a0870c83a9.

Reported-by: kernelci.org bot <bot@kernelci.org>
Link: https://lore.kernel.org/all/179258034449.241924.15241097267562754477@kernelci.org/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/mm/fault.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/arch/s390/mm/fault.c b/arch/s390/mm/fault.c
index 2d03af60ed88f..f907e916aa20d 100644
--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -443,17 +443,10 @@ void do_secure_storage_access(struct pt_regs *regs)
 		folio = phys_to_folio(addr);
 		if (unlikely(!folio_try_get(folio)))
 			return;
-		rc = uv_convert_from_secure(folio_to_phys(folio));
-		if (!rc)
-			clear_bit(PG_arch_1, &folio->flags.f);
+		rc = arch_make_folio_accessible(folio);
 		folio_put(folio);
-		/*
-		 * There are some valid fixup types for kernel
-		 * accesses to donated secure memory. zeropad is one
-		 * of them.
-		 */
 		if (rc)
-			return handle_fault_error_nolock(regs, 0);
+			BUG();
 	} else {
 		if (faulthandler_disabled())
 			return handle_fault_error_nolock(regs, 0);
-- 
2.53.0



