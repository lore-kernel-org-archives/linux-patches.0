Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5CF17A2EC;
	Mon, 13 Oct 2025 15:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369419; cv=none; b=T9G9/219yUikACCG1y7NXh+BaqJLRIXYS7Oo3eHKhjxdrSchDimGcbHIIR7d3BPCedxxyUb7+i1Tv9eqOdehi+tqoNPSvsSmQBHbpuG5CgC+thYf4QiOj+cqDkoBE1WZb3jO1qeGc8hKD09Pf9iSySKqnXeOGc+HgdfKcc7hGsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369419; c=relaxed/simple;
	bh=Kg5M21oNZxnu2rV3Xpio2/Xtg2xv/38Qr5PoDCMFsUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Gfg9Iu4iDlOX18uxZDlfQ5r62Z0I/mJRbecKeQIN8isTGPXYzB4lKJmsJ3dtGkcsNKCZEWmXWmLfuLJQA2Y1+KU8ihPqaQVFR/0W7eYFMg7dXQq+KIX/FX+e1JFktLrnha6OhjgoBE9xuEmOB4qqRVT7UNQdjGPantwFrJ2g3K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c70r3fL/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c70r3fL/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6222C2BCB6;
	Mon, 13 Oct 2025 15:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369419;
	bh=Kg5M21oNZxnu2rV3Xpio2/Xtg2xv/38Qr5PoDCMFsUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c70r3fL/CjTuetOX0rmuxosXgQehWUFlSEEhBscbtS2J+yXdFBP0/7Oga9a1ahFIK
	 /QW4j4XcL7c+ljn/GVLOf/QaYtX48P4P2pAguBoMsQyFpegxfZ3DwReBIZrdFgiiel
	 +H1OMdo52f/juIpJoTYeAv4Wd+h4A6dhE8eSs5gY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 196/563] tools/nolibc: add stdbool.h to nolibc includes
Date: Mon, 13 Oct 2025 16:40:57 +0200
Message-ID: <20251013144418.383414566@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Almeida <andrealmeid@igalia.com>

[ Upstream commit 2d965c1ae4135ed6f505661458f6dabd39488dac ]

Otherwise tests compiled with only "-include nolibc.h" will fail with
"error: unknown type name 'bool'", even though a stdbool.h is available
from nolibc.

Fixes: ae1f550efc11 ("tools/nolibc: add stdbool.h header")
Fixes: f2662ec26b26 ("selftests: kselftest: Create ksft_print_dbg_msg()")
Reported-by: Mark Brown <broonie@kernel.org>
Closes: https://lore.kernel.org/lkml/833f5ae5-190e-47ec-9ad9-127ad166c80c@sirena.org.uk/
Signed-off-by: André Almeida <andrealmeid@igalia.com>
[Thomas: add Fixes tags and massage commit message a bit]
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/nolibc.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/nolibc/nolibc.h b/tools/include/nolibc/nolibc.h
index c199ade200c24..d2f5aa085f8e3 100644
--- a/tools/include/nolibc/nolibc.h
+++ b/tools/include/nolibc/nolibc.h
@@ -116,6 +116,7 @@
 #include "sched.h"
 #include "signal.h"
 #include "unistd.h"
+#include "stdbool.h"
 #include "stdio.h"
 #include "stdlib.h"
 #include "string.h"
-- 
2.51.0



