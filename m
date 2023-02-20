Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E363B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:40:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25EB1C433EF;
	Mon, 20 Feb 2023 13:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900448;
	bh=dFL+IgG3X1F0IEiVcSdi4r0hp7lwG7+JHPS72bO8eJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQLVxhAdx0Wx1u2EgKzpBPBIDV8ObRrvOw/llRmYyoot1PfbNicsfAO+BwTHJEues
	 T+RfMtXIp2zF26fE1AloxeODHENJCaK/DDEmS8M7o7KINEtvR5qPo7gg2AyrJNOcFu
	 VJ+sNPrAH3w+U3qytxBY7Kgq/Pa8hvZluHi0A0hM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 4.19 29/89] efi: Accept version 2 of memory attributes table
Date: Mon, 20 Feb 2023 14:35:28 +0100
Message-Id: <20230220133554.194067041@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
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
@@ -35,7 +35,7 @@ int __init efi_memattr_init(void)
 		return -ENOMEM;
 	}
 
-	if (tbl->version > 1) {
+	if (tbl->version > 2) {
 		pr_warn("Unexpected EFI Memory Attributes table version %d\n",
 			tbl->version);
 		goto unmap;


