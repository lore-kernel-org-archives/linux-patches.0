Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96F6199255;
	Thu,  6 Jun 2024 14:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682991; cv=none; b=GqW2WpxxwznzfCJq7C1+kWDuQal9fleomMU4XYdfV49h6jRJTTP6XdxB/Z2N/jIqFubBpUL2faSGR0TMEVXZ0T+63taDPnm7KU6/qGnHCTK3oG0447KkLrKBbyGX/f9ER9RZ7WMefeImckzg7ULm9OQx0iZxAAaRyGGQ6nmknSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682991; c=relaxed/simple;
	bh=IqypKjAMUHeIW6c+JyEMV5IlAGQwjVY9nPNTe43MMpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lL9uhte5ob0vpG+KNbffeE+Q7yWbV/aAAV0mPl21cWofnnuaJ8CxF2HgyTkqTeG74teVUgrfQdhc05EDslDseAk2QPIxkdkUqMww9bea11flJRzLBhXSlXEJTNPbAoiCZl6WqikoaPtG13TYbsnmZN46QrOpVAmpmqok7GaxmOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PyeCvOmH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PyeCvOmH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3691C32782;
	Thu,  6 Jun 2024 14:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682991;
	bh=IqypKjAMUHeIW6c+JyEMV5IlAGQwjVY9nPNTe43MMpw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PyeCvOmHMzI8+y2S56llGiCC54qZ/226gZk7u0biovLGsNo6x4z1mUr4ZVdhqbjfV
	 luCZnwBjdqqAWpUSOA/iUVwBHcExPVvydFzHtfWtYNdZeHmTADohlkbwBoSYoybjaB
	 QmxH9cWMqcc1InTbqH1amlclq1EhEnwhwfDjR2xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tao Su <tao1.su@linux.intel.com>,
	Simon Horman <horms@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Bongsu Jeon <bongsu.jeon@samsung.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Edward Liaw <edliaw@google.com>,
	Eric Dumazet <edumazet@google.com>,
	Ivan Orlov <ivan.orlov0322@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Jaroslav Kysela <perex@perex.cz>,
	Mark Brown <broonie@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	Takashi Iwai <tiwai@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 143/374] selftests/harness: use 1024 in place of LINE_MAX
Date: Thu,  6 Jun 2024 16:02:02 +0200
Message-ID: <20240606131656.691910114@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

From: Tao Su <tao1.su@linux.intel.com>

[ Upstream commit 28d2188709d9c19a7c4601c6870edd9fa0527379 ]

Android was seeing a compilation error because its C library does not
define LINE_MAX.  Since LINE_MAX is only used to determine the size of
test_name[] and 1024 should be enough for the test name, use 1024 instead
of LINE_MAX.

Link: https://lkml.kernel.org/r/20240509053113.43462-3-tao1.su@linux.intel.com
Fixes: 38c957f07038 ("selftests: kselftest_harness: generate test name once")
Signed-off-by: Tao Su <tao1.su@linux.intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Edward Liaw <edliaw@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ivan Orlov <ivan.orlov0322@gmail.com>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jarkko Sakkinen <jarkko@kernel.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Mark Brown <broonie@kernel.org>
Cc: Paolo Abeni <pabeni@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Takashi Iwai <tiwai@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index e8d79e0210831..b634969cbb6f1 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -56,7 +56,6 @@
 #include <asm/types.h>
 #include <ctype.h>
 #include <errno.h>
-#include <limits.h>
 #include <stdbool.h>
 #include <stdint.h>
 #include <stdio.h>
@@ -1217,7 +1216,7 @@ void __run_test(struct __fixture_metadata *f,
 		struct __test_metadata *t)
 {
 	struct __test_xfail *xfail;
-	char test_name[LINE_MAX];
+	char test_name[1024];
 	const char *diagnostic;
 
 	/* reset test struct */
-- 
2.43.0



