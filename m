Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE9571FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44987C433D2;
	Fri,  3 Feb 2023 10:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419706;
	bh=zL2k4u+Jj8vLXa5xAgk1+a1szX++mO4axPA7wz/3+pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sxLVSdKpyQO3i1btEhh3gzFR3+NhRm8yWJk/L4nkdcdYkuraUHjn3UCRlpQEHXb0K
	 IMLnH45jtynLuMGBhMv+BSrzB/6xbEg4zjJFfz9E6ocULdtQeahLGeYaIjdm+Kr41/
	 QGXrTPlLJ6GhkqYFCKdK72YoN3q6Vs2vABjgGkmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 11/28] kselftest: Fix error message for unconfigured LLVM builds
Date: Fri,  3 Feb 2023 11:12:59 +0100
Message-Id: <20230203101010.450195850@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 9fdaca2c1e157dc0a3c0faecf3a6a68e7d8d0c7b ]

We are missing a ) when we attempt to complain about not having enough
configuration for clang, resulting in the rather inscrutable error:

../lib.mk:23: *** unterminated call to function 'error': missing ')'.  Stop.

Add the required ) so we print the message we were trying to print.

Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/lib.mk | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/lib.mk b/tools/testing/selftests/lib.mk
index 291144c284fb..f7900e75d230 100644
--- a/tools/testing/selftests/lib.mk
+++ b/tools/testing/selftests/lib.mk
@@ -20,7 +20,7 @@ CLANG_TARGET_FLAGS              := $(CLANG_TARGET_FLAGS_$(ARCH))
 
 ifeq ($(CROSS_COMPILE),)
 ifeq ($(CLANG_TARGET_FLAGS),)
-$(error Specify CROSS_COMPILE or add '--target=' option to lib.mk
+$(error Specify CROSS_COMPILE or add '--target=' option to lib.mk)
 else
 CLANG_FLAGS     += --target=$(CLANG_TARGET_FLAGS)
 endif # CLANG_TARGET_FLAGS
-- 
2.39.0



