Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7C61482F5;
	Wed,  7 May 2025 18:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644334; cv=none; b=LPjxE+8hWJwkcIaWGc85MWdlb+HSK6a5t2P46DVJt+fuWwXS9fOoHtSC0yO6bK49ffPwAQngBJVtbSjiEBLb/40bfJsGmTLalZGHR9pznPnWKHbCUwtiu3w+8pHE4dEttWoNg2fBC2V9/Q4nWqdzrvchKwWejfanE4Ndj/59psc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644334; c=relaxed/simple;
	bh=8sjSiCUiobMuq18+AzgNqp1ggpvmfhn2wppcpPa2hUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hZ6bg2ivh1mXecwDFcKo0qbRfmPhivp0GZQCbTpGIe3TUqcgrA0hZAXu9GrNFUcgp3UsDIT3jPDpq/MwbGN4lnxgfZbEMbjWo0Dk3UFjVY9ohmSSXNcVYQywVra/yNwkHABH5aOyrMv9h/CFvluH7SB4fasOcTeh/U9zEk9qIbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DauwfkOw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DauwfkOw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1709C4CEE2;
	Wed,  7 May 2025 18:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644334;
	bh=8sjSiCUiobMuq18+AzgNqp1ggpvmfhn2wppcpPa2hUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DauwfkOwNWv6lOdLZt9Ig1Joh3jgDV00oeviCkVSU6M4DR9UHMRYTduepQ6Gfldr9
	 H6GXkgM2gzrGIft8YwFuXDjG3VM6pEqhAzt69CnVzY/h/6YkM8Kq087/x3+k9BMQt8
	 liy9mLaOyb6Rc+mglUDsXifenr2IIk6J1Ox23Klo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Tiffany Y. Yang" <ynaffit@google.com>,
	stable <stable@kernel.org>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.12 010/164] binder: fix offset calculation in debug log
Date: Wed,  7 May 2025 20:38:15 +0200
Message-ID: <20250507183821.249364866@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Carlos Llamas <cmllamas@google.com>

commit 170d1a3738908eef6a0dbf378ea77fb4ae8e294d upstream.

The vma start address should be substracted from the buffer's user data
address and not the other way around.

Cc: Tiffany Y. Yang <ynaffit@google.com>
Cc: stable <stable@kernel.org>
Fixes: 162c79731448 ("binder: avoid user addresses in debug logs")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Tiffany Y. Yang <ynaffit@google.com>
Link: https://lore.kernel.org/r/20250325184902.587138-1-cmllamas@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[cmllamas: fix conflicts due to alloc->buffer renaming]
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/android/binder.c
+++ b/drivers/android/binder.c
@@ -6374,7 +6374,7 @@ static void print_binder_transaction_ilo
 		seq_printf(m, " node %d", buffer->target_node->debug_id);
 	seq_printf(m, " size %zd:%zd offset %lx\n",
 		   buffer->data_size, buffer->offsets_size,
-		   proc->alloc.buffer - buffer->user_data);
+		   buffer->user_data - proc->alloc.buffer);
 }
 
 static void print_binder_work_ilocked(struct seq_file *m,


