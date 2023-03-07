Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C21BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:36:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E130FC4339B;
	Tue,  7 Mar 2023 18:36:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214207;
	bh=ju2ZtpORtYuSME28Elg6gDh7dkpmq44zmN09G4Ru8tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UA2CqS+af+2hgpJ79BIk29n8Q6F3+OOUHgoX1GJX4wpPg/osopFSkmx8tKtK37p7X
	 B/78JSI2MrbXb9XiAbQX2Yt6VTPhyprPQZUyUPcbAOdAqgt09RPke2ghpvEeXU/sz3
	 Cr2CudmnLDAy4XI6fOFE2kNWkbsKn2qXOxMkrUJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 757/885] selftests: kcmp: Fix incorrect kernel headers search path
Date: Tue,  7 Mar 2023 18:01:31 +0100
Message-Id: <20230307170034.829713344@linuxfoundation.org>
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

commit 5d74231a2caad259f6669d8d6112814cef6bcd60 upstream.

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
 tools/testing/selftests/kcmp/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/kcmp/Makefile
+++ b/tools/testing/selftests/kcmp/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0-only
-CFLAGS += -I../../../../usr/include/
+CFLAGS += $(KHDR_INCLUDES)
 
 TEST_GEN_PROGS := kcmp_test
 


