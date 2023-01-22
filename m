Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6432590
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395BBC433D2;
	Sun, 22 Jan 2023 15:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400503;
	bh=BEG/IMQo3ViR1MKiqcXqv6YmJl0zKDvag+6myi/QtHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zj/ItRLualqYGcYRQi+MmoeBkmTvyHST9teWQJssvzhOnXqs0URnIx89pNZ86Ojzn
	 tzE5QwaaF3HVg09jNFk1LgSEWyZXeoK+pzmzZlN8T9ZOgThbddvrQebrXHnT1MCdA5
	 4Njn67j5v4HrTkjg5UpMZnUFlR4gmfUtM7kwEiZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 5.10 81/98] efi: rt-wrapper: Add missing include
Date: Sun, 22 Jan 2023 16:04:37 +0100
Message-Id: <20230122150232.862319265@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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

commit 18bba1843fc7f264f58c9345d00827d082f9c558 upstream.

Add the missing #include of asm/assembler.h, which is where the ldr_l
macro is defined.

Fixes: ff7a167961d1b97e ("arm64: efi: Execute runtime services from a dedicated stack")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Cc: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/efi-rt-wrapper.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -4,6 +4,7 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/assembler.h>
 
 SYM_FUNC_START(__efi_rt_asm_wrapper)
 	stp	x29, x30, [sp, #-32]!


