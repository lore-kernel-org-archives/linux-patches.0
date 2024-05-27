Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FDC1863F;
	Mon, 27 May 2024 19:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837403; cv=none; b=B3SfqU6DY5CgQUeRMYOIl1HOAvcamVEZjppvbPlZQDknsA3zfhWTefpB39MA/CcuOiZ4vcgcN21uAHMm0n3G9xbmnUbnJ7epifcpSHTe4D6Uakn1uRrh7n5jYE4JBBiyoI5nBZIxWEO5HVtNuN/78qgI0dFZVzOYk3/j4UBIpEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837403; c=relaxed/simple;
	bh=Mpo2sFmU+MHmROoNcsKdsghXNqfVklfW63vCg/LNIdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qck0fW9/pLl0QAIs1P2d3T6ixHpYMB+SbC8ON3kJLwP18x8izood2Y6SJ1H2V372JFbQtg/LdO8WT1BEKcVOH6JdmNvJk42tQ9sYP2imx0ZpnWuuFMhI7Zwqoq8DB6AEL9kl5SwbFjM/Ib8JKKUpSE9L1CBlaK/y0Toj19wf4yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nqIdC/Jr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nqIdC/Jr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0641C2BBFC;
	Mon, 27 May 2024 19:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837403;
	bh=Mpo2sFmU+MHmROoNcsKdsghXNqfVklfW63vCg/LNIdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nqIdC/JrAgmu2m23xZvl3YHvZ429wpXT+ObJXutKSpLe+xUt/j1eHcMTOJJQoeUpc
	 caryQUflYGn7uyu1EsNWIzTs4zwSSGg6tjDVNh5aEHokgB5Z9cmwkjDdv551f5kUXy
	 yLBLDI+OCc+bigIXjLPffo0/ftGYvtfb4RrMi6Lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 427/427] Revert "selftests/sgx: Include KHDR_INCLUDES in Makefile"
Date: Mon, 27 May 2024 20:57:54 +0200
Message-ID: <20240527185635.911134140@linuxfoundation.org>
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

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit 3da164023582969280df17636a9d829752787b1c ]

This reverts commit 2c3b8f8f37c6c0c926d584cf4158db95e62b960c.

The framework change to add D_GNU_SOURCE to KHDR_INCLUDES
to Makefile, lib.mk, and kselftest_harness.h is reverted
as it is causing build failures and warnings.

Revert this change as this change depends on the framework
change.

Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/sgx/Makefile    | 2 +-
 tools/testing/selftests/sgx/sigstruct.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/sgx/Makefile b/tools/testing/selftests/sgx/Makefile
index 26ea30fae23ca..867f88ce2570a 100644
--- a/tools/testing/selftests/sgx/Makefile
+++ b/tools/testing/selftests/sgx/Makefile
@@ -12,7 +12,7 @@ OBJCOPY := $(CROSS_COMPILE)objcopy
 endif
 
 INCLUDES := -I$(top_srcdir)/tools/include
-HOST_CFLAGS := -Wall -Werror $(KHDR_INCLUDES) -g $(INCLUDES) -fPIC
+HOST_CFLAGS := -Wall -Werror -g $(INCLUDES) -fPIC
 HOST_LDFLAGS := -z noexecstack -lcrypto
 ENCL_CFLAGS += -Wall -Werror -static-pie -nostdlib -ffreestanding -fPIE \
 	       -fno-stack-protector -mrdrnd $(INCLUDES)
diff --git a/tools/testing/selftests/sgx/sigstruct.c b/tools/testing/selftests/sgx/sigstruct.c
index 200034a0fee51..d73b29becf5b0 100644
--- a/tools/testing/selftests/sgx/sigstruct.c
+++ b/tools/testing/selftests/sgx/sigstruct.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*  Copyright(c) 2016-20 Intel Corporation. */
 
+#define _GNU_SOURCE
 #include <assert.h>
 #include <getopt.h>
 #include <stdbool.h>
-- 
2.43.0



