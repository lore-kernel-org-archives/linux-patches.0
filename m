Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB41BA4C
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:36:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7730C4339B;
	Tue,  7 Mar 2023 18:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214201;
	bh=0/FxfKa+D6jU4s2roRUp6voKNROUjD0Ib4RCyc9aZm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BhAd7SUpilOeoJN7nNLdgiHfzkVg2iZQKK2mJGa0EovSQ8hR6n0amIWpJ40j3ylWV
	 FF0pCnnsu81YSoZ7g58drxD3Kg2A45mt3Sls4mAJ2F6Llo38x3MVRPc1cElSmtn0Ye
	 0rLlcv91Sy+CWCnSoAJJSdyR7ZoH6g+R6YSmgE84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 755/885] selftests: pidfd: Fix incorrect kernel headers search path
Date: Tue,  7 Mar 2023 18:01:29 +0100
Message-Id: <20230307170034.736789030@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

commit 3f7d71768795c386019f2295c1986d00035c9f0f upstream.

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org> # 5.18+
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/pidfd/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/pidfd/Makefile
+++ b/tools/testing/selftests/pidfd/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -g -I../../../../usr/include/ -pthread -Wall
+CFLAGS += -g $(KHDR_INCLUDES) -pthread -Wall
 
 TEST_GEN_PROGS := pidfd_test pidfd_fdinfo_test pidfd_open_test \
 	pidfd_poll_test pidfd_wait pidfd_getfd_test pidfd_setns_test


