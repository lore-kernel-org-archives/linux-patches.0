Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C8518412F;
	Wed,  3 Jul 2024 11:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006267; cv=none; b=Bd8yASb7bRPz9Sk01598X8ldeTTmMExN3bScbPNAC1tOCO7Z+A4tMmcQdbtDp6nRbpAEHejJVW03lusSC0xk0/jTz+tK3lgG6T2LAlQ5DzHB7sg8VH/6Sty7ik6FGA2SckBpGvdaFGOyKwSPim20aF5bBIyl/ZRtD5jyY+fJqg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006267; c=relaxed/simple;
	bh=ZGZTABnV+CAJf44JZ7ALP/c0LGyKyvhXQ0KJR7IV2O4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeozmF5wbwkwlWyThxxhj1G5rqJ2Qx6POe9tQ2ahCGbRTE2N07Nl9Ps5YurQ8CrpimxMlOF1rcda34lBAp71SOMafL1Qm6rAyWyUNmagde4JrW98hfCExETXhtH6xHznkLvc34ERdAPp91/s0jSkC4Y9ocEs2oeunyeW/Ov+kPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFmweItY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFmweItY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E926C2BD10;
	Wed,  3 Jul 2024 11:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006267;
	bh=ZGZTABnV+CAJf44JZ7ALP/c0LGyKyvhXQ0KJR7IV2O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFmweItYOIq9+4JqA9dVKN91rY1du8BKCcEMMrBZeh0/oz1PStb3SWtGSAuT+Ydlr
	 nDJ+HJAxd+93Cm0fDvcdfQ0kcBR7Bu3a98a0wxdQ7P7jVPQxXACRHjX/W9QdvROgoS
	 /rCEkZc58CxrlnbFGdyBPoZjLU4xfsiw0sDqOKTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Zhi Yuan <kevinjone25@g.ncu.edu.tw>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15 348/356] drivers: fix typo in firmware/efi/memmap.c
Date: Wed,  3 Jul 2024 12:41:24 +0200
Message-ID: <20240703102926.276343343@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Zhi Yuan <kevinjone25@g.ncu.edu.tw>

[ Commit 1df4d1724baafa55e9803414ebcdf1ca702bc958 upstream ]

This patch fixes the spelling error in firmware/efi/memmap.c, changing
it to the correct word.

Signed-off-by: Zheng Zhi Yuan <kevinjone25@g.ncu.edu.tw>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/memmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -245,7 +245,7 @@ int __init efi_memmap_install(struct efi
  * @range: Address range (start, end) to split around
  *
  * Returns the number of additional EFI memmap entries required to
- * accomodate @range.
+ * accommodate @range.
  */
 int __init efi_memmap_split_count(efi_memory_desc_t *md, struct range *range)
 {


