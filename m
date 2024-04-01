Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDF24C624;
	Mon,  1 Apr 2024 16:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990359; cv=none; b=oFAR/LIPFiyvTHWWyOefqo9gxpnVeoWb+ZUWVU8Zp80g5B/2hLADtkmfXrYtZrwvx6JT15w6IaCjaSy0KjdI4fLnH22B1Q/wJW+EqVBKJYazB7+TdDAfZdlRZEsaYnTNMK7mZkR2NQ+f6NC07D1Gf2Jogfh6EnxxZubP7SUqE4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990359; c=relaxed/simple;
	bh=ctx01O+Woeeswjpb5RC63wPdtgjhFzxDhCL/zIX7YdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dNz0HO63WsDD+fePrglzC8FjXn58kNzWqy6B6hetWQYCweKLhp5gmrJolEc5Y5mgS5PiK4x6OPTNzJozGMgorg3DUkuZInJeUfwXWjBWd3UBOBij5xwpwrQs7Ca3117ZQfaY3kKYW+6JzMB2chVGjoaWG8yCg5yhPid7JM0ddWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J/ARIcOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J/ARIcOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF3CC433C7;
	Mon,  1 Apr 2024 16:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990359;
	bh=ctx01O+Woeeswjpb5RC63wPdtgjhFzxDhCL/zIX7YdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J/ARIcOmLqve3LN3tBxR1qTMjif9g42+GOaPvrTfWcMZvcQ+cFQc/dN8a0ytfRTsJ
	 C4P9cwARX2COs22HrIkA90OKC6hnIlQL7Mvwku+HkuV9bTtAhv9d+2iEOYFlyEbm8v
	 uMiTgmmJQIxE3e1idwBinQwB3/L4WO4+3vpES9R4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Brian Cain <bcain@quicinc.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 327/396] hexagon: vmlinux.lds.S: handle attributes section
Date: Mon,  1 Apr 2024 17:46:16 +0200
Message-ID: <20240401152557.660526261@linuxfoundation.org>
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

From: Nathan Chancellor <nathan@kernel.org>

commit 549aa9678a0b3981d4821bf244579d9937650562 upstream.

After the linked LLVM change, the build fails with
CONFIG_LD_ORPHAN_WARN_LEVEL="error", which happens with allmodconfig:

  ld.lld: error: vmlinux.a(init/main.o):(.hexagon.attributes) is being placed in '.hexagon.attributes'

Handle the attributes section in a similar manner as arm and riscv by
adding it after the primary ELF_DETAILS grouping in vmlinux.lds.S, which
fixes the error.

Link: https://lkml.kernel.org/r/20240319-hexagon-handle-attributes-section-vmlinux-lds-s-v1-1-59855dab8872@kernel.org
Fixes: 113616ec5b64 ("hexagon: select ARCH_WANT_LD_ORPHAN_WARN")
Link: https://github.com/llvm/llvm-project/commit/31f4b329c8234fab9afa59494d7f8bdaeaefeaad
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Brian Cain <bcain@quicinc.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/hexagon/kernel/vmlinux.lds.S |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/hexagon/kernel/vmlinux.lds.S
+++ b/arch/hexagon/kernel/vmlinux.lds.S
@@ -63,6 +63,7 @@ SECTIONS
 	STABS_DEBUG
 	DWARF_DEBUG
 	ELF_DETAILS
+	.hexagon.attributes 0 : { *(.hexagon.attributes) }
 
 	DISCARDS
 }


