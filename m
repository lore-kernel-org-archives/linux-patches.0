Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283147B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:59:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 162FDC433C1;
	Wed, 23 Nov 2022 08:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193965;
	bh=Tq6UTvV/U2fHils2tZDK+ExsX83NX/T6fR7K3h6E4wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FqTPRW7CW1wkZJBNsansQNc0i8Z1ovPEN9BSRrs5T4SEJteTaDWyh+Y6xecQWMfO7
	 2ISDdNKskT+rB0iWFTg9AudNEDRlZ/NV4xs6D6khBP3IJ6NRKQAh04+jMqFYyz4MOB
	 r5AyU9K4vhh9vmFo8GFQp9P1h7EMNwSQVrS9C/p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ricardo=20Ca=C3=B1uelo?= <ricardo.canuelo@collabora.com>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 33/88] selftests/futex: fix build for clang
Date: Wed, 23 Nov 2022 09:50:30 +0100
Message-Id: <20221123084549.622699254@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
References: <20221123084548.535439312@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ricardo Cañuelo <ricardo.canuelo@collabora.com>

[ Upstream commit 03cab65a07e083b6c1010fbc8f9b817e9aca75d9 ]

Don't use the test-specific header files as source files to force a
target dependency, as clang will complain if more than one source file
is used for a compile command with a single '-o' flag.

Use the proper Makefile variables instead as defined in
tools/testing/selftests/lib.mk.

Signed-off-by: Ricardo Cañuelo <ricardo.canuelo@collabora.com>
Reviewed-by: André Almeida <andrealmeid@igalia.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/futex/functional/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/futex/functional/Makefile b/tools/testing/selftests/futex/functional/Makefile
index ff8feca49746..ad175add3f1d 100644
--- a/tools/testing/selftests/futex/functional/Makefile
+++ b/tools/testing/selftests/futex/functional/Makefile
@@ -3,11 +3,11 @@ INCLUDES := -I../include -I../../
 CFLAGS := $(CFLAGS) -g -O2 -Wall -D_GNU_SOURCE -pthread $(INCLUDES)
 LDFLAGS := $(LDFLAGS) -pthread -lrt
 
-HEADERS := \
+LOCAL_HDRS := \
 	../include/futextest.h \
 	../include/atomic.h \
 	../include/logging.h
-TEST_GEN_FILES := \
+TEST_GEN_PROGS := \
 	futex_wait_timeout \
 	futex_wait_wouldblock \
 	futex_requeue_pi \
@@ -19,5 +19,3 @@ TEST_GEN_FILES := \
 TEST_PROGS := run.sh
 
 include ../../lib.mk
-
-$(TEST_GEN_FILES): $(HEADERS)
-- 
2.35.1



