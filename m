Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507652571B2;
	Thu, 17 Apr 2025 18:56:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916210; cv=none; b=mvN+QBnWOfYRFO2UQ3fb/OKl7o6QVYxclvv1PY4+ZHvzbRsianv9wAwmerqgUZkLYYN5O94ehjCVIB/PG6/GlK5kug3pBTRKq1p4zEW3PIvJhliGC96jsW+n+7LG+03uSBHFauPr1YIYvZomm+FEZTrq3raBBgyVy5ws5MhgMRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916210; c=relaxed/simple;
	bh=17Rj0koySIycvAjAZxkZKoaLtuGGnBsRhUR8K3JQbEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hon7WGQ2wxOxTfl8Ky9zMjeiV+diI1DRYq+3mBzoFkFyJyO5V7+yWGk8S6FwWTLDDnhnMId/RkI/g6MWpaeXAgN3+LulSy9/qZFHulOk1dRwm59+Jp/9VBqwga5Ap+bd86c+NCgzLJdqXr1vPDrRl5mSR5cyP1xDoKon+z+52G0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqWVxLws; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqWVxLws"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BBAC4CEE4;
	Thu, 17 Apr 2025 18:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916210;
	bh=17Rj0koySIycvAjAZxkZKoaLtuGGnBsRhUR8K3JQbEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oqWVxLwssFFNK+QHO2DRa4jnmU/nbFHKB/Ligmx040GPW7KpSTbcGwY94YuNkcNSz
	 AsPAF3Etvhee9w7Vz6j1ZmqsVnjM5hPK+Sj636PyUeuLVwS0iw9rq5X4GXLhg5FhNs
	 mlRmcQ1IMgH34IWOZhpkpf+m+JIUpOsm56fvq6HE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack@google.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH 6.12 351/393] landlock: Prepare to add second errata
Date: Thu, 17 Apr 2025 19:52:40 +0200
Message-ID: <20250417175121.719948407@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Mickaël Salaün <mic@digikod.net>

commit 6d9ac5e4d70eba3e336f9809ba91ab2c49de6d87 upstream.

Potentially include errata for Landlock ABI v5 (Linux 6.10) and v6
(Linux 6.12).  That will be useful for the following signal scoping
erratum.

As explained in errata.h, this commit should be backportable without
conflict down to ABI v5.  It must then not include the errata/abi-6.h
file.

Fixes: 54a6e6bbf3be ("landlock: Add signal scoping")
Cc: Günther Noack <gnoack@google.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250318161443.279194-5-mic@digikod.net
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/landlock/errata.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/security/landlock/errata.h b/security/landlock/errata.h
index f26b28b9873d..8e626accac10 100644
--- a/security/landlock/errata.h
+++ b/security/landlock/errata.h
@@ -63,6 +63,18 @@ static const struct landlock_erratum landlock_errata_init[] __initconst = {
 #endif
 #undef LANDLOCK_ERRATA_ABI
 
+#define LANDLOCK_ERRATA_ABI 5
+#if __has_include("errata/abi-5.h")
+#include "errata/abi-5.h"
+#endif
+#undef LANDLOCK_ERRATA_ABI
+
+#define LANDLOCK_ERRATA_ABI 6
+#if __has_include("errata/abi-6.h")
+#include "errata/abi-6.h"
+#endif
+#undef LANDLOCK_ERRATA_ABI
+
 /*
  * For each new erratum, we need to include all the ABI files up to the impacted
  * ABI to make all potential future intermediate errata easy to backport.
-- 
2.49.0



