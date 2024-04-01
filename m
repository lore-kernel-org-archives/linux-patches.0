Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F5D1CA8F;
	Mon,  1 Apr 2024 16:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987505; cv=none; b=k7vFucozxcerBdIwvYJWtQLwKQgcpMad9cA7oAESiA++S72QOBts/JfRAcVH/aRNqSfoFZQYYoTbNVZ5e0tYrxsnP/Jruw3VjR/ccypLBK2Z7HCBKkz7/b0d5ohKDP0hv2g5vnRGnzB74J+99FyUKGFvQu3oD3kdCM8CjO7pm40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987505; c=relaxed/simple;
	bh=NVT7NE2bQzqMOrIKkivoaTR0uMDikq+g1WQXctmy4Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZJYJ2V1ApgzT6OYouTbAjHUrltLOCsztLLXVPsMl8ZkwS/pL4mToeI/nlCOdxtk24w6pMKN4o9LThuXOpFwqVsVdDjjfsqIgecduBg+DNR1+cJr7CXzPe3zcTfaa++zueHVQ/RakEJRSXn3jODwnhAqCa4DSgfFQhJvpH+2VUFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZHn0BtBs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZHn0BtBs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F29AC433C7;
	Mon,  1 Apr 2024 16:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987505;
	bh=NVT7NE2bQzqMOrIKkivoaTR0uMDikq+g1WQXctmy4Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHn0BtBserTG7qi1euZn8BO1ya3sVaUReiOyoB0ysI/V1tGdUIArsedIhr57S+hpv
	 oRKF8cvzJXr6NqMl7jPeQZTTlOtK8nQCmQVEC9ojRduV8pq3vA62xO5IUbE3t0ks2E
	 4c1e3lL+oetxc4xNLD9RTovEh74POKU/1krxuA5o=
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
Subject: [PATCH 6.8 308/399] hexagon: vmlinux.lds.S: handle attributes section
Date: Mon,  1 Apr 2024 17:44:34 +0200
Message-ID: <20240401152558.382209597@linuxfoundation.org>
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


