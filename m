Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E270BBA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:36:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD72C43329;
	Tue,  7 Mar 2023 18:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214213;
	bh=5HPV5A2n+wX8FaESr1ESZ5sZPXmSk506fMceRtKFuNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4L8/HS/NUi8HpkqwJtp2kHRhZ/RIeGyEQOKZzyK30mmEsSR3QLzvKnY9631joonB
	 INAwTEGe9y/FOHm9+1d5Ur5qEC0Sve6BVM8BEGNLQJsnFtLh0FsSM0TueAx0RXIuHG
	 TT5BeqwK0jK30Up//iTiV2OfDFgWXc28yZrvrcdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-kselftest@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 6.1 759/885] selftests: gpio: Fix incorrect kernel headers search path
Date: Tue,  7 Mar 2023 18:01:33 +0100
Message-Id: <20230307170034.917655007@linuxfoundation.org>
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

commit 8bb9c1808628babcc7b99ec2439bf102379bd4ac upstream.

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
 tools/testing/selftests/gpio/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/gpio/Makefile
+++ b/tools/testing/selftests/gpio/Makefile
@@ -3,6 +3,6 @@
 TEST_PROGS := gpio-mockup.sh gpio-sim.sh
 TEST_FILES := gpio-mockup-sysfs.sh
 TEST_GEN_PROGS_EXTENDED := gpio-mockup-cdev gpio-chip-info gpio-line-name
-CFLAGS += -O2 -g -Wall -I../../../../usr/include/ $(KHDR_INCLUDES)
+CFLAGS += -O2 -g -Wall $(KHDR_INCLUDES)
 
 include ../lib.mk


