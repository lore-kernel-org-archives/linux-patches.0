Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8E237F8B1;
	Sat, 12 Sep 2026 08:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203445; cv=none; b=SkZA9XAzzH/4HUC0TiNM+TBYXnyxYP+T0Nwq8F2TKLnWGXzSX3aMtXElYnmJ3URJ///fIfnseTMF03JCRSY9Im4ExwZRM8ZebRMVnpl/tLy2SVSx14HJwFnAt/mDk6sxRFmdPKUfFgga9IuTXkkAbRsOFCIgyK7THHM6VqqOyf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203445; c=relaxed/simple;
	bh=y5PE3cpJdNs8u66yRodFxRRgXWYZV5So2qsd03CdKPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3smDxqh0S4heAHTtPGCDb1OJCMqJJiNC9R3vQVfIMqyFRuskJixRGdNiuEPMk2A7xJAwK68GU8tRkIkR3UJXCVxbS+jEXy+E616/db8wZjCuIKhfL6M6UnyZyFSAZsNF92Pb19vHkenmYeH7rwxhSx+s+j8RQAaMe6I9iaBixM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEfuioZx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEfuioZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6F21F00893;
	Sat, 12 Sep 2026 08:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203442;
	bh=l19ULQDX5cCiYZYZbnyFI8rTOq1exP0LBLoHWtXCScg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cEfuioZxgDvE+o62hwqT91sz+yV6/gt/X0H/OEoAE1FgUh6/X9zlA2LMZLKyn6vO8
	 JTC5qDvz2E6bDpIOOA0nnPO0bGuh9lyLtD8T53NzTfGPtBNkgvoXOrS+IQ5Sn/6PVm
	 Y2FBjNihnEFTAvzqGKWLI8AozumfYGZDNjKpfaas=
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
Subject: [PATCH 7.2 1408/1815] selftests: harness: Mark test fixture objects __maybe_unused
Date: Sat, 12 Sep 2026 08:52:38 +0200
Message-ID: <20260912065722.076799476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 261e4df94d9d5..29a19bc870846 100644
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



