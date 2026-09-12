Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135F924CEEA;
	Sat, 12 Sep 2026 11:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211089; cv=none; b=l93msJETP2YNrZA2BuNbb5LZUwFqa5tsjp9ksEznrXg2EP7YQdKnyQOeNn1K6WowvIqxMsCyxf+dFHOSSjcECLkqYucGXItAqYabBQtljhfLgFN8lTC4K8+9bnoy4Wf58EqNq0j/FsxoOIDSQVh2QWrCBsvauALLE9HeYH/mf2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211089; c=relaxed/simple;
	bh=oGj1BHIcg3rcaktUfbF0BwVnVmLuX/vl3sajWYSjuxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dA0vY/1hoGedmFz3Qp2bQUJYMnlHPBSidEGXpwiHULWVV3Slk4ZbbzENGl3i7dgflLwf5+2LndOy5KhINomEeW6Omw4IxL9jJP7Ddvs/s874TvN1vgYdDow9XUb9tNCSL88Mu5Yz16nZsqWRQLzuVLGn2VvcTYkfzVydewoTZhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXZKFRr0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXZKFRr0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0048C1F000FF;
	Sat, 12 Sep 2026 11:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211088;
	bh=8VHKIzk+cODP+Uoj6uunzCFRaz3+gxMlyOAPpxkwWsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXZKFRr0wMatr7a1k6f1REfciYMuXbqCG6tMczXuN93h12fHBRAEGHYMkWKeSM9Xh
	 N7PmYYaW8CTsgGQqHOg11izImZr2ziyDWnGjeXWDi7HBudOKbzdOHKiq551wjAS5Ie
	 QBXo5k80leAw7TGKeg4BJ1Ek/45V0ViEqjhURWhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Aaron Lewis <aaronlewis@google.com>,
	Alex Williamson <alex@shazbot.org>,
	David Matlack <dmatlack@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1160/1518] selftests: harness: Mark test fixture objects __maybe_unused
Date: Sat, 12 Sep 2026 08:55:29 +0200
Message-ID: <20260912065649.698685210@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Matlack <dmatlack@google.com>

[ Upstream commit 37ffa24c9d07edcd414d34283e02af3f3866cf12 ]

Mark _##fixture_name##_##test_name##_object __maybe_unused since it may
not ever be read. This pointer is only read in XFAIL_ADD(), which tests
are not required to use.

clang made a change to -Wunused-but-set-variable (split out into its own
subwarning, -Wunused-but-set-global) that causes this warning to be
emitted for various selftests and can be upgraded to an error in
selftest that set -Werror.

VFIO selftests have been broken since commit ff556bd98348 ("vfio:
selftests: Add -Wall and -Werror to the Makefile"), and the net
selftests builds have been noisy due to -Wall.

Fixes: 24cf65a62266 ("selftests/harness: Share _metadata between forked processes")
Reported-by: Kuniyuki Iwashima <kuniyu@google.com>
Reported-by: Aaron Lewis <aaronlewis@google.com>
Reviewed-by: Alex Williamson <alex@shazbot.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Link: https://lore.kernel.org/r/20260706183154.2660394-1-dmatlack@google.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/kselftest_harness.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kselftest_harness.h b/tools/testing/selftests/kselftest_harness.h
index 6904c22d14f41..be7f0ecab7704 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -467,7 +467,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 				!__atomic_test_and_set(_metadata->no_teardown, __ATOMIC_RELAXED)) \
 			fixture_name##_teardown(_metadata, self, variant); \
 	} \
-	static struct __test_metadata *_##fixture_name##_##test_name##_object; \
+	static struct __test_metadata *_##fixture_name##_##test_name##_object __maybe_unused; \
 	static void __attribute__((constructor(KSELFTEST_PRIO_TEST))) \
 			_register_##fixture_name##_##test_name(void) \
 	{ \
-- 
2.53.0



