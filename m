Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4138163B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B95CFC433D2;
	Mon, 20 Feb 2023 13:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900731;
	bh=UOOkRQP3xdihmk2mxo/A8RZ5+6uk72dVJDxpNLg40sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+76jolzkNDsUrR11MobBXsnoPar+hLdv+5+qbj0xf9HbHaJwGuGoKe24nN9td6S5
	 zhYfmN0nWR+wSLXepbqcuNUCO/PQjR+4OyqdT7YiRRUbPZZevbR3K7QscPL4+bEWQo
	 1LsvIJ2hoAwTUjuhV7QtfL2HCtqk9h791p+SyHBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 5.4 039/156] efi: Accept version 2 of memory attributes table
Date: Mon, 20 Feb 2023 14:34:43 +0100
Message-Id: <20230220133604.016903583@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ard Biesheuvel <ardb@kernel.org>

commit 636ab417a7aec4ee993916e688eb5c5977570836 upstream.

UEFI v2.10 introduces version 2 of the memory attributes table, which
turns the reserved field into a flags field, but is compatible with
version 1 in all other respects. So let's not complain about version 2
if we encounter it.

Cc: <stable@vger.kernel.org>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/efi/memattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/firmware/efi/memattr.c
+++ b/drivers/firmware/efi/memattr.c
@@ -32,7 +32,7 @@ int __init efi_memattr_init(void)
 		return -ENOMEM;
 	}
 
-	if (tbl->version > 1) {
+	if (tbl->version > 2) {
 		pr_warn("Unexpected EFI Memory Attributes table version %d\n",
 			tbl->version);
 		goto unmap;


