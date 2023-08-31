Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19D7D8F5D
	for <patches@lists.linux.dev>; Thu, 31 Aug 2023 11:11:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A28BC433C9;
	Thu, 31 Aug 2023 11:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693480259;
	bh=6FjTWO7+B0Jkj/UpwbUddISXb/rl3ATRj8nMW+eUiQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M2HNAXsXKfBiFKZ7jr/b5fZG4WAg9fiiHbaAAeOmRNpqcLwR/T9Jniw5t81YcgHyP
	 XEigYkounMEJ9DeIbrT/g2D/S32vxcjsF+zN7JxMixTmOxI119tN9xR3go9m9yiQQc
	 xcsogfDZLIuJH9qQSb0iiR6It3LJD1w1PX6zAJVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <keescook@chromium.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 3/9] arm64: module-plts: inline linux/moduleloader.h
Date: Thu, 31 Aug 2023 13:10:11 +0200
Message-ID: <20230831110830.206503977@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230831110830.039135096@linuxfoundation.org>
References: <20230831110830.039135096@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 60a0aab7463ee69296692d980b96510ccce3934e upstream.

module_frob_arch_sections() is declared in moduleloader.h, but
that is not included before the definition:

arch/arm64/kernel/module-plts.c:286:5: error: no previous prototype for 'module_frob_arch_sections' [-Werror=missing-prototypes]

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20230516160642.523862-11-arnd@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/module-plts.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/arm64/kernel/module-plts.c
+++ b/arch/arm64/kernel/module-plts.c
@@ -7,6 +7,7 @@
 #include <linux/ftrace.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/moduleloader.h>
 #include <linux/sort.h>
 
 static struct plt_entry __get_adrp_add_pair(u64 dst, u64 pc,


