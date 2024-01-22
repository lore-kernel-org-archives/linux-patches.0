Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C451812A167;
	Tue, 23 Jan 2024 00:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971045; cv=none; b=e9/sg31op3XUSGmG0kXqzemcykH/AM/ncOgPZFo7FwTRi4/8feYUX6Io7VXwOldITJ8hAbw9awPW0+A3E6T/0fibIgSMZpY8ppMMTBrUNavLR9FT4gaEBMtGjND68LAl2nLjSfR791kxdKW/eZU4+8sUO/qrgr6c/VPTsZUZrZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971045; c=relaxed/simple;
	bh=NmZW1n1yy5VX+gKDs9pMGa2zCH8zfDZXJ/sJ6AlPOac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FponVWotANV91S8XwvhXekXKk9MlhbWytrAt+dXuTEsEit2e/ejrUtlujA8qRPwFOSRSR53wUO6hOXzxHt/d3D5S3V3GhEbKtfoonzz3ZoEjohDQ7KXmktp37YkBGTFTzP9gmVz5uz9ScG/6eges+3x5ULPsSP9ooMnn8nLsccY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7XRy2OT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7XRy2OT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F66CC43394;
	Tue, 23 Jan 2024 00:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971045;
	bh=NmZW1n1yy5VX+gKDs9pMGa2zCH8zfDZXJ/sJ6AlPOac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7XRy2OTItTNINCYfLewt8xaBH+t6eg8dJcBxlZmTtvN3uriG1uPuQcRf2v90axT8
	 hd0ovteIU4Bs1zAZ1xjdnZE8LqfTZ+fLmje4rw8PjDGmpm8qNbSgp3jnxLV2/gjJh/
	 NbiZkbNxZvj058ssLk6mi/HqtsahqsjLvp0EiktI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/286] powerpc: Remove in_kernel_text()
Date: Mon, 22 Jan 2024 15:55:58 -0800
Message-ID: <20240122235734.035425636@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 09ca497528dac12cbbceab8197011c875a96d053 ]

Last user of in_kernel_text() stopped using in with
commit 549e8152de80 ("powerpc: Make the 64-bit kernel as a
position-independent executable").

Generic function is_kernel_text() does the same.

So remote it.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/2a3a5b6f8cc0ef4e854d7b764f66aa8d2ee270d2.1624813698.git.christophe.leroy@csgroup.eu
Stable-dep-of: 1b1e38002648 ("powerpc: add crtsavres.o to always-y instead of extra-y")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/sections.h | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/powerpc/include/asm/sections.h b/arch/powerpc/include/asm/sections.h
index 324d7b298ec3..6e4af4492a14 100644
--- a/arch/powerpc/include/asm/sections.h
+++ b/arch/powerpc/include/asm/sections.h
@@ -38,14 +38,6 @@ extern char start_virt_trampolines[];
 extern char end_virt_trampolines[];
 #endif
 
-static inline int in_kernel_text(unsigned long addr)
-{
-	if (addr >= (unsigned long)_stext && addr < (unsigned long)__init_end)
-		return 1;
-
-	return 0;
-}
-
 static inline unsigned long kernel_toc_addr(void)
 {
 	/* Defined by the linker, see vmlinux.lds.S */
-- 
2.43.0



