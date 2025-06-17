Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCE52E92C9;
	Tue, 17 Jun 2025 15:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175743; cv=none; b=hUoSg/VQrQlkTmCLIbg1wtMhdMBaafGWdRcApCpGL0wA62kqbFjX+cmJ5qA5EBPC/s11l2UMi11H7pfRvR0BmBlqZE6GLMD2ot7VtzkslEcyVBin1ofBjYpXUjPqE7/rY+J2dF86cvfLZCY73Ic15M2vIqQAH0mNh7TDXKD+aow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175743; c=relaxed/simple;
	bh=T4brOIoOA4m9fPKnjT1Ao4RAmNuXM5eBxtNefsYqfpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpIz+N/K6XjLLTgL44w72E6+WR61/ccYzaGjC0R9JeRjrbPDPo6ip1+HpPOdSk/Ual8UOUarDWGKf48uB+GuP/GlwakQAlS+0zfNEJvjVkjutn0k1bhNhovFd2eYutj9czIfAPfFaZwSPbgrjqKs1J3VrCsg6OHQqNUXeKvoofc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0avpF9KL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0avpF9KL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E0DEC4CEF0;
	Tue, 17 Jun 2025 15:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175743;
	bh=T4brOIoOA4m9fPKnjT1Ao4RAmNuXM5eBxtNefsYqfpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0avpF9KLLldQ9FXRFWDP5ZbKLEG1WnoCi6LoO4mncAAve+y+0XI/stN3u4NbW+VYK
	 qgfHfrIlaJXmXoOJN0O8HH9IRJBY5wQdMO/H4t1cXKQCLthBcxu3Smq0Mh4P0IEc1L
	 MoX1Q2y7ahnYSvRmPjN/Fb4Y4GHxI3UV/ZKAMhW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Zhang <18255117159@163.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 159/512] efi/libstub: Describe missing out parameter in efi_load_initrd
Date: Tue, 17 Jun 2025 17:22:05 +0200
Message-ID: <20250617152426.055947502@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Zhang <18255117159@163.com>

[ Upstream commit c8e1927e7f7d63721e32ec41d27ccb0eb1a1b0fc ]

The function efi_load_initrd() had a documentation warning due to
the missing description for the 'out' parameter. Add the parameter
description to the kernel-doc comment to resolve the warning and
improve API documentation.

Fixes the following compiler warning:
drivers/firmware/efi/libstub/efi-stub-helper.c:611: warning: Function parameter or struct member 'out' not described in 'efi_load_initrd'

Fixes: f4dc7fffa987 ("efi: libstub: unify initrd loading between architectures")
Signed-off-by: Hans Zhang <18255117159@163.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/efi/libstub/efi-stub-helper.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index de659f6a815fd..1ad414da9920a 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -603,6 +603,7 @@ efi_status_t efi_load_initrd_cmdline(efi_loaded_image_t *image,
  * @image:	EFI loaded image protocol
  * @soft_limit:	preferred address for loading the initrd
  * @hard_limit:	upper limit address for loading the initrd
+ * @out:	pointer to store the address of the initrd table
  *
  * Return:	status code
  */
-- 
2.39.5



