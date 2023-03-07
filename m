Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6DB1BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F73C433A0;
	Tue,  7 Mar 2023 18:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214256;
	bh=XQH43IEFUEyBpZ12P6dRbqyGDcj7pau0VKkrw5sLbSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdjI0NC3tXX2YRZhhzPg8LgGABTA4Jot6xROrw7MM9ljwmd10Ie1kYXNk4xceiED7
	 OucxhP89ddqqk54f9X+xwruXCTRgsrTlxxl+7aXQk7Zvhs1/TMhSQ+qI86yPlsGbGI
	 1Lr8DeTgiJQEbKrgG4cP0/J3K+uY6KVE5NjCze/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 765/885] selftests: move_mount_set_group: Fix incorrect kernel headers search path
Date: Tue,  7 Mar 2023 18:01:39 +0100
Message-Id: <20230307170035.182748511@linuxfoundation.org>
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

commit 65c68af0131bfef8e395c325735b6c40638cb931 upstream.

Use $(KHDR_INCLUDES) as lookup path for kernel headers. This prevents
building against kernel headers from the build environment in scenarios
where kernel headers are installed into a specific output directory
(O=...).

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: linux-kselftest@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>
Cc: <stable@vger.kernel.org>  # 5.18+
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/move_mount_set_group/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/move_mount_set_group/Makefile
+++ b/tools/testing/selftests/move_mount_set_group/Makefile
@@ -1,6 +1,6 @@
 # SPDX-License-Identifier: GPL-2.0
 # Makefile for mount selftests.
-CFLAGS = -g -I../../../../usr/include/ -Wall -O2
+CFLAGS = -g $(KHDR_INCLUDES) -Wall -O2
 
 TEST_GEN_FILES += move_mount_set_group_test
 


