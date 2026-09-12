Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFD629B78F;
	Sat, 12 Sep 2026 13:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218209; cv=none; b=ZMgsDhcrxJiV7fES+zjYYkd/unrobzoTxIzQmpLU2eWHogoE4Xszq8PVAdT5+sZUsbLVoyoEgQEdsIUpT9+JIS5toSlRAAwimVnm1pbeGGgFD5VAq1puCjZXMiwiqirEUgBfJuSnoiki7HRU7R3eKjU1JnOsP92thWiS+zneUT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218209; c=relaxed/simple;
	bh=YgVxT825DeCmJ+x4kwQwAgF5foQTEcjVQj+JsBt2c1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdIfS3Vos0qsQlSJ8uDjLeZvojY9BqB8Aj+mxUrnilAybcA6QEtWd4kNQ/VvCWNjPifeuFj27pn3LJZyxqAto+JRAwcYOr2GrCaHHkFro08m48YD9+WJmMomBeJKKs5baiI9aKVKNPbLWYIUAKSkTNFPQxpd9P/PbNUz3c4vvNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JiXlSJ3A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JiXlSJ3A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52F61F000FF;
	Sat, 12 Sep 2026 13:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218208;
	bh=XXaPNitjVh1TQJvQjJSs1sNXo4Q0Oa9BHBfxi/8E/Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JiXlSJ3AMmilz56Hi3zbtQvMHa8eX5V2ynTUr5GVVJOKMF959hcWvt/aIVO5tuDCw
	 hVxmdl8Ip8+clsXxvXm/38rcGHMGIJSGTvGmxlJOb098XUAkpMY8iuvs76fB2bh+kU
	 BpveJK6sZJv2MXUIGRysgrYStbfOGhFCiyHBlWuQ=
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
Subject: [PATCH 6.12 1096/1376] selftests: harness: Mark test fixture objects __maybe_unused
Date: Sat, 12 Sep 2026 08:58:42 +0200
Message-ID: <20260912065631.987140971@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cdf1e75ef0f73..4c652d2a80766 100644
--- a/tools/testing/selftests/kselftest_harness.h
+++ b/tools/testing/selftests/kselftest_harness.h
@@ -467,7 +467,7 @@ static inline void __kselftest_memset_safe(void *s, int c, size_t n)
 		} \
 		__test_check_assert(_metadata); \
 	} \
-	static struct __test_metadata *_##fixture_name##_##test_name##_object; \
+	static struct __test_metadata *_##fixture_name##_##test_name##_object __maybe_unused; \
 	static void __attribute__((constructor(KSELFTEST_PRIO_TEST))) \
 			_register_##fixture_name##_##test_name(void) \
 	{ \
-- 
2.53.0



