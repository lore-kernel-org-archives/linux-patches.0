Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2597B2686B9;
	Tue,  8 Apr 2025 11:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113335; cv=none; b=N9N2RYTABDCj973EsGYDZ1XJyDhk6emH6z/ahPsA1lLoH/ZAJ5giXXMHmXoMHg19pFexKzkzY9MEE5AgwTAMbseTRZ2hqAPtsrr00nVYv0hbRhGl1kUW/QkC2J9KijEG7vTNGR60L4npGM7rhovN8t5IH49Iiu5yRgYa0Jps9RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113335; c=relaxed/simple;
	bh=Nq+a6ozyNXG0C1juDcIasXze3cF1giTw3V+ljzE/nXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=COHooLvFMSgLJkxeJxfIIxVK+lIgjY6E57k+QgNpcuPYHIXcjsWBCUzaNbLNSuRkZ8LkF5FXAVGi7gpRN5SKjMrn3DiauO69vhNWMAXWJAOuDj3PshPlrC+HQmuGVwFQaw1LOPNgrOAOc+LvzODycf7MjiO/OmlXkYPDN4ySADI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWVJKdA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWVJKdA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A863DC4CEE5;
	Tue,  8 Apr 2025 11:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113335;
	bh=Nq+a6ozyNXG0C1juDcIasXze3cF1giTw3V+ljzE/nXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HWVJKdA8anBJEv7M8zlmwB39Hh0g0ZfoqnmdR9L2SciY/JdWrCeWMVl26DONUPM4s
	 +RY2GcEV5vvH0k5eIM5b/NhUWXOsAM1O9lObxTqISHoxhZ5MvERuHmMv9gCkJCEiWO
	 9jCghtX3JBDWv503oNN/+ZUJH7gdgBFI7pTv1tcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/268] perf units: Fix insufficient array space
Date: Tue,  8 Apr 2025 12:48:53 +0200
Message-ID: <20250408104831.786685518@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cf67629f7f637fb988228abdb3aae46d0c1748fe ]

No need to specify the array size, let the compiler figure that out.

This addresses this compiler warning that was noticed while build
testing on fedora rawhide:

  31    15.81 fedora:rawhide                : FAIL gcc version 15.0.1 20250225 (Red Hat 15.0.1-0) (GCC)
    util/units.c: In function 'unit_number__scnprintf':
    util/units.c:67:24: error: initializer-string for array of 'char' is too long [-Werror=unterminated-string-initialization]
       67 |         char unit[4] = "BKMG";
          |                        ^~~~~~
    cc1: all warnings being treated as errors

Fixes: 9808143ba2e54818 ("perf tools: Add unit_number__scnprintf function")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250310194534.265487-3-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/units.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/units.c b/tools/perf/util/units.c
index 32c39cfe209b3..4c6a86e1cb54b 100644
--- a/tools/perf/util/units.c
+++ b/tools/perf/util/units.c
@@ -64,7 +64,7 @@ unsigned long convert_unit(unsigned long value, char *unit)
 
 int unit_number__scnprintf(char *buf, size_t size, u64 n)
 {
-	char unit[4] = "BKMG";
+	char unit[] = "BKMG";
 	int i = 0;
 
 	while (((n / 1024) > 1) && (i < 3)) {
-- 
2.39.5



