Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B0B383BA;
	Mon,  1 Apr 2024 16:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987449; cv=none; b=fDHi8VzzRo6lhwutFJ7ucA+TKqe2ZrQJ5b+hfGTJpW8KT64Dk/C5tV9hotaBrz697g1sJ/3+q6s4I4twMlaiwlz3ADWWQoVyn14+An77eKnkkkGcqyJDbrzSjas9FsQif4d7dLE+CkNh0wO6z6+thnuuUrZbt5n78IZugkWG/Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987449; c=relaxed/simple;
	bh=gOOrfy0lt5SCrRi9EVifj4mVQ4STzTDkuqxzX/ofQPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=djv1zZ+dtyZrkp8JKV9PkvhWcHnMNJ1i2076055CfS3ZyZFdX1JH0SxXPlKtwWxNCiS5W0Sb/gRZBRekkEvij8TGzvQm6gFwMTpRvtGgwY3I8boYlcuyvVHs6RgmxwoEFY85qARU2UgSAXNZGX6BVD03SHL+14JSz4SBYSChKMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrN1MctZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrN1MctZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5D6C433C7;
	Mon,  1 Apr 2024 16:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987449;
	bh=gOOrfy0lt5SCrRi9EVifj4mVQ4STzTDkuqxzX/ofQPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrN1MctZ1qxDHXZqbSg7fXwD5TcTEW64RkoiwEdl+3mUQLV1qfAiFLpZ+RYxcrdrh
	 R0RR6nInfqJYQ0hlLs/TVZZzUgwFC/st16qIdnMZA8HGGBdRT1+5LqUa7wAXbPMdMK
	 9azmYoqClv0ZEKCwm2f2aTc4QNPkpj/uhxQasn+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [PATCH 6.8 289/399] efi/libstub: Cast away type warning in use of max()
Date: Mon,  1 Apr 2024 17:44:15 +0200
Message-ID: <20240401152557.812304793@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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


