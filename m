Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEEEA184120;
	Wed,  3 Jul 2024 11:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720006270; cv=none; b=J1vng/2EExIbx+YmE2Cth6asaPnexKDG6izfmSKfKy5IgQ+jdofd1b0AeXKjUheWzF5z6JD7mnpzA9B+WHNkHLyE2j8yJxC/+NqdpodqiNkaKPfLU7U0ykWqnODJ9EauA7ZL4Goui45emUJlmqQcSsigTwbGkN+FFFeZGJnVe1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720006270; c=relaxed/simple;
	bh=jiTki0E9CRIQS1iBCFcvmyLb5ztXWPHzDvwQk/eN4Nk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MvE7n/PPHFKT2Ny96davoZ7IML9GtUd8KNWIVyWfMLiGMrlsRZ8l1KsQGgKJNbp7EERx2oi844WuPn7yIaSPWqpLub4fGG3AMtrRZ8X6LBMZa2cUZHE4wV74kxvjT/lM9dq6kCS7HvhxBvPTBq/slaRMeaW02UHUQbmCmddPL5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dFEmReZH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dFEmReZH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F314DC2BD10;
	Wed,  3 Jul 2024 11:31:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720006270;
	bh=jiTki0E9CRIQS1iBCFcvmyLb5ztXWPHzDvwQk/eN4Nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dFEmReZHyN68oE2r7SeCdYQLnP4KJpB9Mv/lRhHCUiNlIjYAjDj6vFdTcjI8zjn0I
	 G84GuP8BZv9HaONKf9xWQrXUAOzL3K9i4EMKyr4MlaXLGnLf6dm77FiDq8LgnRSaUW
	 M0+5hNKikwlISPSEpktifGhCbjHciYacVFvmV2jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Zixian <liuzixian4@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.15 349/356] efi: Correct comment on efi_memmap_alloc
Date: Wed,  3 Jul 2024 12:41:25 +0200
Message-ID: <20240703102926.313529937@linuxfoundation.org>
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

From: Liu Zixian <liuzixian4@huawei.com>

[ Commit db01ea882bf601252dad57242655da17fd9ad2f5 upstream ]

Returning zero means success now.

Signed-off-by: Liu Zixian <liuzixian4@huawei.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/memmap.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/firmware/efi/memmap.c
+++ b/drivers/firmware/efi/memmap.c
@@ -59,8 +59,7 @@ static void __init efi_memmap_free(void)
  * Depending on whether mm_init() has already been invoked or not,
  * either memblock or "normal" page allocation is used.
  *
- * Returns the physical address of the allocated memory map on
- * success, zero on failure.
+ * Returns zero on success, a negative error code on failure.
  */
 int __init efi_memmap_alloc(unsigned int num_entries,
 		struct efi_memory_map_data *data)


