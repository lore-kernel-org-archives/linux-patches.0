Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822E947A5D;
	Mon,  1 Apr 2024 17:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711991353; cv=none; b=cGU88u/6m7symdTyqygACYm75dmqRMLivb1eYQVLR5DDzk6C0HDSKYcitFvggLvgTplImfs16tQmYr79sNMauFRziDWA+fKKgHHl8SlhOYpBvCFY326m8pkiKPOD04SmApWHYcRrYQwzWaavm4MCldH15U+TTv/tODkFZfbQt2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711991353; c=relaxed/simple;
	bh=eSo3IKlA+zREdDvBaG1kr1cJjQkhuHSfc/9EH5YaHOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQPdqbJov+M7KSXZPbflnt2gqsMpHO3SAZGeJHHbh6Diet1aXeA80/BbFMcs3RnXU8ke+euz1nbfbJsM2oqRnJE4B1E4OJi797o1eyD4yXCEI4LvpOKOZCHUQ6S9pl6qP4L8K+YWgdoS1Ux/VdeUnHkWfuk9rMaTZEyHetDUZjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eE5KCnaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eE5KCnaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02116C433F1;
	Mon,  1 Apr 2024 17:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711991353;
	bh=eSo3IKlA+zREdDvBaG1kr1cJjQkhuHSfc/9EH5YaHOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eE5KCnafdgVZi8ZT7TsPrJSb20w60Z+cRsHds+SatlC9po7TfP03QYNEa6QafThZg
	 7fqrj+PHmI1q6Pq9BDMbd4yaaz07670UzFCZRwSrw/eBjbd/mHuf6JBZ1z/qSt2PU+
	 d2p7W1peBfKvOZIxx/OSyhF5k34iOwHtz5eXjr70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.1 212/272] efi/libstub: Cast away type warning in use of max()
Date: Mon,  1 Apr 2024 17:46:42 +0200
Message-ID: <20240401152537.550993533@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ard Biesheuvel <ardb@kernel.org>

commit 61d130f261a3c15ae2c4b6f3ac3517d5d5b78855 upstream.

Avoid a type mismatch warning in max() by switching to max_t() and
providing the type explicitly.

Fixes: 3cb4a4827596abc82e ("efi/libstub: fix efi_random_alloc() ...")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/libstub/randomalloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/libstub/randomalloc.c
+++ b/drivers/firmware/efi/libstub/randomalloc.c
@@ -119,7 +119,7 @@ efi_status_t efi_random_alloc(unsigned l
 			continue;
 		}
 
-		target = round_up(max(md->phys_addr, alloc_min), align) + target_slot * align;
+		target = round_up(max_t(u64, md->phys_addr, alloc_min), align) + target_slot * align;
 		pages = size / EFI_PAGE_SIZE;
 
 		status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,


