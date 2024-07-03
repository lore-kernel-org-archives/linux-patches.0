Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F321891C9;
	Wed,  3 Jul 2024 11:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005164; cv=none; b=Mvxukw+rihT042xV90C4TVgDVlvUuPmbqyrbtseg35mwEFZrdhP9QkZR39cSL3n0lCX/VQp6keMPlmurf+tbh0tAICDqc4oVdawnr09xCnRkI53ms9OC4pDVL/bCNToLAhCWrQRdosBVJgI5tMlkO1mwo623tujdnKDHnMea9ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005164; c=relaxed/simple;
	bh=KuuyfKCEr1Ibb3zBkdMG88tIF/tyeSj8zcgGIMkh6Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAmliX+ETzC+OWmtldXQlCQsRkfbjFW+P9fUmV4XrSHahMMuzwWPlYwzXVKdWZ+tpTMP7b93EkRnJJzdIUdqZMtI4kFFA5CxKMRazVcgbAQoXyaCnMyIK5Srku8ug0r5ADFOWPgf8DZaKlyCm0bwPiyHP23AIb7iicMDiqwSEhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+QyLx84; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+QyLx84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496E7C2BD10;
	Wed,  3 Jul 2024 11:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005164;
	bh=KuuyfKCEr1Ibb3zBkdMG88tIF/tyeSj8zcgGIMkh6Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+QyLx84Lx4sabw1/OUZZr/0Ll3kpRm5wlO76Mfx90ajsDuNvEcHLzT37Dh2PvB15
	 cFb/PYYZCU8ZFYQU26hYGkoTs2UBSnXV4IyICyWHPqRyOzP406eeLMfwCJSGW+HEXd
	 wkXZKktIm4ikA3sPx2cb3D8BsqKgJBGv1UNASAOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Zhi Yuan <kevinjone25@g.ncu.edu.tw>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.10 282/290] drivers: fix typo in firmware/efi/memmap.c
Date: Wed,  3 Jul 2024 12:41:03 +0200
Message-ID: <20240703102914.802158429@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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


