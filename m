Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B584343F1;
	Tue, 21 Jul 2026 19:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663389; cv=none; b=EMSupZDeO8+JYPJ5nmFLqp3b7UMMqpTjVpDDwG6BQY/zY+UTN7kak0uyFmrUopulA77bSGUw9liWS32LtpkbTXQc7UrXDKrLK6QrBPMJbHVWV6POmTDamcp8VHhDVAhHMbnvk9g8Wk+4JrngvnmVoOjkMj9PkCZz2MglXqu1Mjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663389; c=relaxed/simple;
	bh=/Ch3XhKgSLq//w5IR1mzSQ5e3FVZcGdofk4aDZ1JEs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=R1cF2/YrUOiUeltsfZphkFE9dChqhIQsf+UKW4elnf7ZqmwyjQ9Npw+eCVombfqDdvdLVKulUG4RlFyP2Ckiic+k9cNzm+Z3QoGrw822Rxqw/zyM9sLRUSO9kR8yNcZyrtgBc4IdtdwI4mttLlzh5U3X19Uol69XZNgOsZjcbRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F44tcvvj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F44tcvvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 466541F00A3A;
	Tue, 21 Jul 2026 19:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663387;
	bh=N9ojgcAsDvjl9lpfp+cdhMEqD99Q44MmR391WHNF/WE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F44tcvvjut7ydtvI+xgZ1onXSHcfqxpKHf/bHMOF1D1VC0lOp0B5ABs8Y2H0/GXQS
	 aqX/X1XuMRoSrCm5zByNp+B7NgiSLpwc2wgFTRCBsnXsQAPGoBnT/jWxw+Q5Dt9Xqi
	 mtkPRx07dszwRaW6rKtTdw8KNwvbyRdJEldiZ+dc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anas Khan <anxkhn28@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0804/1276] drm/xe: remove duplicate <kunit/test-bug.h> include
Date: Tue, 21 Jul 2026 17:20:47 +0200
Message-ID: <20260721152504.065322229@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Anas Khan <anxkhn28@gmail.com>

[ Upstream commit 91426ce50d14a49bde53b3ad1e48393556ba92cd ]

xe_pci.c includes <kunit/test-bug.h> twice, separated only by the
<kunit/test.h> include. Drop the redundant second include; this is a
non-functional cleanup flagged by scripts/checkincludes.pl.

Fixes: 6cad22853cb8 ("drm/xe/kunit: Add stub to read_gmdid")
Signed-off-by: Anas Khan <anxkhn28@gmail.com>
Link: https://patch.msgid.link/20260702112820.34675-1-anxkhn28@gmail.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 84ed5b0a925721aaf069d36e18a99db966ff4e80)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/tests/xe_pci.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/tests/xe_pci.c b/drivers/gpu/drm/xe/tests/xe_pci.c
index 67404863087e78..69493e36de1376 100644
--- a/drivers/gpu/drm/xe/tests/xe_pci.c
+++ b/drivers/gpu/drm/xe/tests/xe_pci.c
@@ -9,7 +9,6 @@
 
 #include <kunit/test-bug.h>
 #include <kunit/test.h>
-#include <kunit/test-bug.h>
 #include <kunit/visibility.h>
 
 /**
-- 
2.53.0



