Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB5822FD1D6;
	Mon, 13 Oct 2025 15:09:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368179; cv=none; b=rZkBE4lFxtCLaCcQSRzk8AVBCDAhy/NcL8/e2lIann6Eawu61xiiZ5QEecr7aSnDSvQKttgZjImy1KHpSg5RYDzQYK/LyPA256EdrDAEpv4Y5xhkU4wrSV9IQAPa6WOxCFN52zGqU62DvMmXbQwuh9sFjctgZzptrtMwMH3r2Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368179; c=relaxed/simple;
	bh=+9iUi9FrzHRuxjxwpOF0NUyskK6oJmemITqJThWkiwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HipBxTyDoX91eWtFnUiogyudBNdaPWNI7Z7w96LJwaj1SiuDgnBmkr4euiN2vODhynV7mIyqszylpaPgSByvGT2ju6Rh/Fr1qBVFskT2drmdK7UjGOic84s8uPkm8Vf0/th3Qaj+hZz0cUwRNNoH7v+m7z3eRSsCc4Z1tC209fY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4iX74e0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4iX74e0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EA15C4CEE7;
	Mon, 13 Oct 2025 15:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368179;
	bh=+9iUi9FrzHRuxjxwpOF0NUyskK6oJmemITqJThWkiwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e4iX74e01i0cEe7OtAc9rrG05n5HLvRAQXt5Ip/UWspqFj3aiw9dc6zZn4pfo/Pn0
	 2X9gllP/G3Upsq6Pm/jLm+MPuV/ocyv3m9DX/M9HblalXXMePAQeINY6ekmANDe7Ws
	 DWFUwM8K3HIEXSwYc3fMKLsPjaqtYORWo0lqcbD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Berg <benjamin.berg@intel.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 038/262] selftests/nolibc: fix EXPECT_NZ macro
Date: Mon, 13 Oct 2025 16:43:00 +0200
Message-ID: <20251013144327.503938675@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Benjamin Berg <benjamin.berg@intel.com>

[ Upstream commit 6d33ce3634f99e0c6c9ce9fc111261f2c411cb48 ]

The expect non-zero macro was incorrect and never used. Fix its
definition.

Fixes: 362aecb2d8cfa ("selftests/nolibc: add basic infrastructure to ease creation of nolibc tests")
Signed-off-by: Benjamin Berg <benjamin.berg@intel.com>
Link: https://lore.kernel.org/r/20250731201225.323254-2-benjamin@sipsolutions.net
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/nolibc/nolibc-test.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/nolibc/nolibc-test.c b/tools/testing/selftests/nolibc/nolibc-test.c
index 6fba7025c5e3c..d73bff23c61e7 100644
--- a/tools/testing/selftests/nolibc/nolibc-test.c
+++ b/tools/testing/selftests/nolibc/nolibc-test.c
@@ -196,8 +196,8 @@ int expect_zr(int expr, int llen)
 }
 
 
-#define EXPECT_NZ(cond, expr, val)			\
-	do { if (!(cond)) result(llen, SKIPPED); else ret += expect_nz(expr, llen; } while (0)
+#define EXPECT_NZ(cond, expr)				\
+	do { if (!(cond)) result(llen, SKIPPED); else ret += expect_nz(expr, llen); } while (0)
 
 static __attribute__((unused))
 int expect_nz(int expr, int llen)
-- 
2.51.0



