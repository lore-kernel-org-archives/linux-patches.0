Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063401;
	b=TUUMFbMUSI7oZFv1Q7lOgyMLJg/45/aL4fcg9dpuk/XQWSIneQMEgIQQd0YrXtjKLWF4
	 1nHZJnBfOWGErQMSBWo1OwYeX9pS3tgx3YEtpNYBM22/gOHMp6aanuAn/pU4qlIpjsrZT
	 94XGDcekaYlU5SRjPt1KNzfVpalD2oSCtsW5Kqc0ISv81glS+jlHUw/emCDysoeCuCDp0
	 LoyUhJBMSanTGZ7rwk2RYFy06ybm69l3UyUGtlS4X4oGFjE90tY0YRdw4q+VfAtcoQt2s
	 bQP8/VUzqo09cICla51Yjz5cLQ27WcR6xrdCiFjXTlDJLKeIrrzeTYITEXgGdeRB8UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063401;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FC8WQvGRewIibp/GFS8im38WQdXiz86qS17N20aQZ2Y=;
	b=rOnLSHWtQSsDajnMGX1Stpl4TdNsxWSGMQre0lTFBaHfMoWjAM6shLLMQgKS3Gh4vsqE
	 Dqk/R1yQh4aN8dfK1NJUyPT5hLumPxOWR2zzYv4pPTAdM2thXSL0Om3GRY2UFrYkGdXbe
	 ZkR7ZPaJndt2U0x+vmgaXi4oPSNjk/oGOSLFWpcqLpdL+oRtzd6uTb4tYHGd/tb8X6HVv
	 KOWYSZVzHmNSbsPloJxuTD8IdVcbs81TLPjm3zV3qM8qsJrdQFM5g2HOyQVhahZZy5HLf
	 BpBDc2nFi7CWkRzv3ztXpTTxIOTqPuLNQf4wPuv8jjgb8VgtvZoGUq2SO8a7VzhFdsg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DD2pSlKt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3C42606EEA1;
	Sat,  7 Nov 2026 14:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DD2pSlKt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 550F51F008A5;
	Sat,  7 Nov 2026 14:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063400;
	bh=FC8WQvGRewIibp/GFS8im38WQdXiz86qS17N20aQZ2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DD2pSlKtruRSP0/2q/KRztShCgI60AzEVLURatSyreR7zK9bOhXTr9LaEtEfKBN9t
	 aRz+cXWDPJDwl2y+H/uatWoh9HI3Nu9XfvIxQBQHQ+a8fTxiKfamispVyMidlBWk89
	 wRIfJX1ktejXR8lmqdrXtM4N+U3oRCXX7PjX2zVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 572/869] kbuild: AutoFDO: Update split machine function argument for upstream rename
Date: Sat,  7 Nov 2026 08:54:14 -0500
Message-ID: <20261107134912.629423120@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 2b358510d5cc56164f83110ca1499c95a5a352cd ]

A recent LLVM commit [1] renamed the internal LLVM plugin option
'-split-machine-functions' to '-function-splitting=all', breaking the
AutoFDO + ThinLTO build with:

  ld.lld: error: -plugin-opt=-: ld.lld: Unknown command line argument '-split-machine-functions'.  Try: 'ld.lld --help'

The plugin option is needed for in-process ThinLTO, so handle the rename
accordingly using ld-option.

Cc: stable@vger.kernel.org
Closes: https://github.com/ClangBuiltLinux/linux/issues/2186
Fixes: 2fd65f7afd5a ("AutoFDO: Enable machine function split optimization for AutoFDO")
Link: https://github.com/llvm/llvm-project/commit/3e6acc87c58843e551d6e8e4bf06c26712b04622 [1]
Link: https://patch.msgid.link/20261014-update-autofdo-split-machine-function-option-v1-1-5c71b3005e89@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/Makefile.autofdo | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.autofdo b/scripts/Makefile.autofdo
index 1caf2457e585c..0b14a05726ada 100644
--- a/scripts/Makefile.autofdo
+++ b/scripts/Makefile.autofdo
@@ -18,7 +18,7 @@ ifdef CONFIG_LTO_CLANG_THIN
     KBUILD_LDFLAGS += --lto-sample-profile=$(CLANG_AUTOFDO_PROFILE)
   endif
   KBUILD_LDFLAGS += --mllvm=-enable-fs-discriminator=true --mllvm=-improved-fs-discriminator=true -plugin-opt=thinlto
-  KBUILD_LDFLAGS += -plugin-opt=-split-machine-functions
+  KBUILD_LDFLAGS += $(call ld-option,-plugin-opt=-function-splitting=all,-plugin-opt=-split-machine-functions)
 endif
 
 export CFLAGS_AUTOFDO_CLANG
-- 
2.53.0



