Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FCA2E7BD4;
	Tue, 12 Aug 2025 18:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023251; cv=none; b=TuCD3E3vf2o0iteMOPWgbg8zUvG49r4xSKN9EmSRWn8MoCBo9ZYsd0ZTJ1HfsIbBHwOC+fji9KHg0V2iZwGkh2mcCvWKiQilrvCDv6whN5czNzoKF9iYdxpdKcIDCDK72vbfNlpDytP0Mtm7DBdf3vhh9+sPXTfEqkPtcFoA3IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023251; c=relaxed/simple;
	bh=yjD3ud9trxCsm/dBfmg22jHOIRlt0yf0dJ0BOifYSPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=glKCDqTMZ1pjneNv+pICkpfbDXLUXrUyny8UJZAybx9Tf2/y8jZHwSgIr4N/IlqCFqg06qErCzXDiYo/Ua/CjGcRAeJfd41rrwKMAJIzXh6LLLohb7YX8OjIzXRtX86D0cwkRChIj2vXRZ0n7I0Cc9K50mHkSJv9tLlHN4iJREU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3ujw1if; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3ujw1if"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 373E6C4CEF1;
	Tue, 12 Aug 2025 18:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023251;
	bh=yjD3ud9trxCsm/dBfmg22jHOIRlt0yf0dJ0BOifYSPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3ujw1if0p+BaGjlrrs+YESjLKqn20INoLqED30mUuqXLmybx9iud1SpgP6F6fcCB
	 VMPf71t+3X7yoV8vFn0pinPDkTeMhIptVudiXfy+KKpowDP6bzLJ9pTnF5hYrmJ1Ni
	 7eJsX0dq0Yr4IRrK0P5FdLjclccJbBy44bNWmLVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Liu <song@kernel.org>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 005/627] selftests/landlock: Fix build of audit_test
Date: Tue, 12 Aug 2025 19:25:00 +0200
Message-ID: <20250812173419.523658139@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Song Liu <song@kernel.org>

[ Upstream commit dc58130bc38f09b162aa3b216f8b8f1e0a56127b ]

We are hitting build error on CentOS 9:

audit_test.c:232:40: error: ‘O_CLOEXEC’ undeclared (...)

Fix this by including fcntl.h.

Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20250605214416.1885878-1-song@kernel.org
Fixes: 6b4566400a29 ("selftests/landlock: Add PID tests for audit records")
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/audit_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/landlock/audit_test.c b/tools/testing/selftests/landlock/audit_test.c
index cfc571afd0eb..46d02d49835a 100644
--- a/tools/testing/selftests/landlock/audit_test.c
+++ b/tools/testing/selftests/landlock/audit_test.c
@@ -7,6 +7,7 @@
 
 #define _GNU_SOURCE
 #include <errno.h>
+#include <fcntl.h>
 #include <limits.h>
 #include <linux/landlock.h>
 #include <pthread.h>
-- 
2.39.5



