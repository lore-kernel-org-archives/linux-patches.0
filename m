Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523245FF18;
	Tue, 13 Feb 2024 17:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845908; cv=none; b=PA6kfsJVoY2foS14qgFt7FCIswPJeSwv4RbDUp8s2g6/3DIBGJGUncRIfrrgOV1wV0eRVtdnULDwDMBcQaKp0HTYRfRwn/aBZO4g0fZxBBUYyl7broQM4haWAUDiOftXMYRihrCq1SFOW3xM6Pi+tvbQG2VPxIjwTn1Ni/yltDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845908; c=relaxed/simple;
	bh=dWh0uc1pyR5NZGyZad5RK7sv18av9y+SCc9gL2gg0hE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WT70cbWyS9Fy59+RpTQISlbPjvO0YekCHznWfeLjcV5t83EBip8hyV7hKwpBRhQak1u5k309E6XjVI59B2F9Afx7GZqvZ8yFpQFB/7Ke34wqBQ9SmNK74MfM9kAk01LXO2npurCRTxt3yn+D3tS3HY73EyZgMyQF94xQTYp3JfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaOOZPri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaOOZPri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB39EC433F1;
	Tue, 13 Feb 2024 17:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845908;
	bh=dWh0uc1pyR5NZGyZad5RK7sv18av9y+SCc9gL2gg0hE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaOOZPriuFSCeIofpo9v1I55+R1wHkhoBow1r2JbHCG0j6E2+P4v9Zn6GJ5tF9W32
	 kPKWrBWXXWQDwcfqU7sJHWZi8hi7hG+NOGnfQOZ1J7VORYATsTffQoEDXSzEDhZj6R
	 hKNPEO7/lS+4BBZF6DP7DvTxraueZPrl0dqmUchY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aishwarya TCV <aishwarya.tcv@arm.com>,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 085/124] selftests: core: include linux/close_range.h for CLOSE_RANGE_* macros
Date: Tue, 13 Feb 2024 18:21:47 +0100
Message-ID: <20240213171856.216203045@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit 01c1484ac04790fe27a37f89dd3a350f99646815 ]

Correct header file is needed for getting CLOSE_RANGE_* macros.
Previously it was tested with newer glibc which didn't show the need to
include the header which was a mistake.

Link: https://lkml.kernel.org/r/20231024155137.219700-1-usama.anjum@collabora.com
Fixes: ec54424923cf ("selftests: core: remove duplicate defines")
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Link: https://lore.kernel.org/all/7161219e-0223-d699-d6f3-81abd9abf13b@arm.com
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/core/close_range_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/core/close_range_test.c b/tools/testing/selftests/core/close_range_test.c
index 534576f06df1..c59e4adb905d 100644
--- a/tools/testing/selftests/core/close_range_test.c
+++ b/tools/testing/selftests/core/close_range_test.c
@@ -12,6 +12,7 @@
 #include <syscall.h>
 #include <unistd.h>
 #include <sys/resource.h>
+#include <linux/close_range.h>
 
 #include "../kselftest_harness.h"
 #include "../clone3/clone3_selftests.h"
-- 
2.43.0



