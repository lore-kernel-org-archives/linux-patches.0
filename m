Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 680CA17E90E;
	Mon, 27 May 2024 19:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837007; cv=none; b=Tcxw23qgJ9CjUaWt+Z6CEyiCK+JpBa3Bs9XfmGFCLkDFb/RMys7D8BbnRuwngIQp6HbmEv8jS/2cS2b20XR9ltCTfNN+81dDq0KW8iAnzL+EsKc3K+VbbSC0VT9BD4vkpipunc6RcYDQoNm+fp5CxQrOg3n1/GWu1LTD7pHIp6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837007; c=relaxed/simple;
	bh=37G+OoQCRz9xLz4i30K1Xq5Us2Rq6Ln0LyjXY3drSKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ricZDg6rynI7OdGoRZlqutXZAl6UZfQkVuN/C0eIxIbIyMIMhh9l1ckH4E3HJI3lVY6fVEIHZxqbsxZbeqqFJLD5TDpLsm72m5Def/rmtn8tQvfiHEX6OWkpXUftstv3vYVdfRsEp7K4u08jwj+h2pNo0V06P6IAq9VuRIU/N5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2e7wCZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2e7wCZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0574C2BBFC;
	Mon, 27 May 2024 19:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837007;
	bh=37G+OoQCRz9xLz4i30K1Xq5Us2Rq6Ln0LyjXY3drSKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2e7wCZGoWuCGkSRd2FjBw/rpF74VgFCX1js9JxlJnegCJpe7AS5UIdBlvVxy1+R5
	 ihOT2QFTAxvOFfElzwBw3p91eriwQ1mDSeXEEVc1pkYlfjop4YpecBXFo5MAL0XoIp
	 xbp59m9U3mrg1u+zWAPzwPtapNJ/uGta/LmToxyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Edward Liaw <edliaw@google.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 232/427] selftests/sgx: Include KHDR_INCLUDES in Makefile
Date: Mon, 27 May 2024 20:54:39 +0200
Message-ID: <20240527185624.147695746@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Liaw <edliaw@google.com>

[ Upstream commit 2c3b8f8f37c6c0c926d584cf4158db95e62b960c ]

Add KHDR_INCLUDES to the CFLAGS to pull in the kselftest harness
dependencies (-D_GNU_SOURCE).

Also, remove redefinitions of _GNU_SOURCE in the source code.

Fixes: 809216233555 ("selftests/harness: remove use of LINE_MAX")
Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202404301040.3bea5782-oliver.sang@intel.com
Signed-off-by: Edward Liaw <edliaw@google.com>
Reviewed-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/Makefile    | 2 +-
 tools/testing/selftests/sgx/sigstruct.c | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
index 867f88ce2570a..26ea30fae23ca 100644
--- a/tools/testing/selftests/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -12,7 +12,7 @@ OBJCOPY := $(CROSS_COMPILE)objcopy
 endif
 
 INCLUDES := -I$(top_srcdir)/tools/include
-HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC
+HOST_CFLAGS := -Wall -Werror $(KHDR_INCLUDES) -g $(INCLUDES) -fPIC
 HOST_LDFLAGS := -z noexecstack -lcrypto
 ENCL_CFLAGS += -Wall -Werror -static-pie -nostdlib -ffreestanding -fPIE \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
index d73b29becf5b0..200034a0fee51 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -1,7 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
-#define _GNU_SOURCE
 #include <assert.h>
 #include <getopt.h>
 #include <stdbool.h>
-- 
2.43.0



