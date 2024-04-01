Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8959BA3F;
	Mon,  1 Apr 2024 16:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990309; cv=none; b=nyyd11lyEmbH0eX7/s+KAmY3s0FyBc+EUz7Go/C4rC3FMA3zN2OYyUXCYoQOu3qQXrn0XhocJkTnEdk7fNRrFYhejjK0BI5PoS4RhcUvKHzXCq7nJ9mtwLDB6kPBu4ZNif7SK1w3PT8n2I9IpRBSlA3IC+v6Wk/jmviXtqunsGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990309; c=relaxed/simple;
	bh=z3qp5Ewi9OAf8pNitvySjqDOX5zFokcOyQg3j0F9Uic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKu4t92udIOqE4FC+IoIm4JMMMrZPdMsQ6OHTGzaT6Mr7nziWz1hIbgFSCpSI6wq5y7S75qTHfin+QgwfG/T0MSSQCgTYAjp0xYOcvWlFDad2IszSnJTEJn+eYscoO4CBPXJjoo1Ic/V5U7qrTEpj8k2rNAcR4ENDCXcgN0LjgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HktDGKpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HktDGKpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A77C433C7;
	Mon,  1 Apr 2024 16:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990309;
	bh=z3qp5Ewi9OAf8pNitvySjqDOX5zFokcOyQg3j0F9Uic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HktDGKpWcgZXRWNfIMgoMpVa8S9YeW6/LD68haJOXFEQ3G/0GIeoS/X/0egJzfhLO
	 IupPWnRDNmMQxqTdnZN+RvQQto22ZrUGc0FtCemKZ863qJh/2G2GtXbFkDF7yADtxQ
	 GScBPrDEQyFFZQHfIVx31i0Emzd60ORg8VySGlVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.6 312/396] efi/libstub: Cast away type warning in use of max()
Date: Mon,  1 Apr 2024 17:46:01 +0200
Message-ID: <20240401152557.215765538@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -120,7 +120,7 @@ efi_status_t efi_random_alloc(unsigned l
 			continue;
 		}
 
-		target = round_up(max(md->phys_addr, alloc_min), align) + target_slot * align;
+		target = round_up(max_t(u64, md->phys_addr, alloc_min), align) + target_slot * align;
 		pages = size / EFI_PAGE_SIZE;
 
 		status = efi_bs_call(allocate_pages, EFI_ALLOCATE_ADDRESS,


