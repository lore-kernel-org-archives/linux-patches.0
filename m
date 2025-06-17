Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E58723B633;
	Tue, 17 Jun 2025 15:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174959; cv=none; b=SWP5798CmpgblwjltnjfIwGDkhRhpR8ESiNllaTtpaSRDrHwnawp/l39yJ7IOyOaPBBvmF8IR7pHubZiS7vqa1UoaK345yM+n5hPcqdcBmwMRTjlog8DdXIMle7R6fBseroN2Ag2NeZ8kZK86JKPpDr4pHs5b5eQS91EJojU2SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174959; c=relaxed/simple;
	bh=Y6qQlkWsIJMwfzAw5Ali3e6Cwg9X89uOHxfpxWA6+pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Tn5ysl2Dnd8+q0j1KAa6bdhhZfw4BL6RWOwMKDr0PixD1uSF0IPr+bgXC4yytkRrTiXAHRQMmEVX+RTXi+rvhFSXjrXdYP4CcYZvcy83dtS9HNHz1FlwWMz9rslO/+0EagG5VrtbMIOE7B5N/aRncECyvPyybjnLkQvsldvfkqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cG0StmVV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cG0StmVV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3BDC4CEE3;
	Tue, 17 Jun 2025 15:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174959;
	bh=Y6qQlkWsIJMwfzAw5Ali3e6Cwg9X89uOHxfpxWA6+pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cG0StmVV1orvzYRvb+T0ctEFDLMLluZSjkWZB7LSB1bz2uyGa3umaWfyqeR4Q3gJj
	 gSTq4hKIrpE/hjYannf9nbECAuRhxkitFq1l94yvwP6FuR7xIyQTWDpJx63Lgi3FTS
	 +OzcE4ji+xDS2bV4GTT+UvV8vhC0z2yryzV9sR04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Kees Cook <kees@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 080/512] kunit/usercopy: Disable u64 test on 32-bit SPARC
Date: Tue, 17 Jun 2025 17:20:46 +0200
Message-ID: <20250617152422.821795403@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit 0d6efa20e384a41a7f4afdcd8a0aec442c19d33e ]

usercopy of 64 bit values does not work on 32-bit SPARC:

    # usercopy_test_valid: EXPECTATION FAILED at lib/tests/usercopy_kunit.c:209
    Expected val_u64 == 0x5a5b5c5d6a6b6c6d, but
        val_u64 == 1515936861 (0x5a5b5c5d)
        0x5a5b5c5d6a6b6c6d == 6510899242581322861 (0x5a5b5c5d6a6b6c6d)

Disable the test.

Fixes: 4c5d7bc63775 ("usercopy: Add tests for all get_user() sizes")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250416-kunit-sparc-usercopy-v1-1-a772054db3af@linutronix.de
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/usercopy_kunit.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/usercopy_kunit.c b/lib/usercopy_kunit.c
index 77fa00a13df77..80f8abe10968c 100644
--- a/lib/usercopy_kunit.c
+++ b/lib/usercopy_kunit.c
@@ -27,6 +27,7 @@
 			    !defined(CONFIG_MICROBLAZE) &&	\
 			    !defined(CONFIG_NIOS2) &&		\
 			    !defined(CONFIG_PPC32) &&		\
+			    !defined(CONFIG_SPARC32) &&		\
 			    !defined(CONFIG_SUPERH))
 # define TEST_U64
 #endif
-- 
2.39.5



