Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B4246D2C9;
	Tue, 21 Jul 2026 18:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658305; cv=none; b=SMp3Wk9E7JSNSyst7jLxOegk+boYOs2ExLcvNpQcO+QeB6djF5bgGVmipo4onc/IAhBCDUN76vgzHZBpsrUsah2fHxpgdKXKp8pe9AUK0K/93C0nnkXGyUTLjJjl2gwRaStZiMjGLaIq0FWyMzx02OqltFqq167bMA/LH+g+rD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658305; c=relaxed/simple;
	bh=GSYgNzshE1ThI3ZkiSe9QYkdbARNzHYaORGc5MKUeOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g1cj+oZt45FYQFRrhKbLB28pS1MTREtDOndjleXLl2fz8OIUH1UjXRfkKJWGdwnKSTT3JjkbOa9+7TX7pRACaXSn1RSOQIeI+L7jyb3UWpuIrHcOrN16X6PY7IfunG72sVribnD2qjbZsOrNiVfGcTX/2Zq0FAjrxfkgGzNtXRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fooV9SPt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fooV9SPt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970101F00A3A;
	Tue, 21 Jul 2026 18:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658303;
	bh=4TxGrVltiBU61CK0ydbQo/fDWWowb9RpviJ3wFo+D04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fooV9SPtpxsbGWFG7rcPxilNSJyuMt11ga5sRMkzLeYeIOiMqxmIXay3AOx+C6Lzd
	 PqM6FLas1UnrCgwRVPSolBJ/ETNnYLZcpEL4S4fee5vRPF4JrQaddbeWnJ8W9Yz4mA
	 MyDwEi0ZsT/kKfGbFJG6SILgnR7ie1UY0fvOxiX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anas Khan <anxkhn28@gmail.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1093/1611] drm/xe: remove duplicate <kunit/test-bug.h> include
Date: Tue, 21 Jul 2026 17:20:09 +0200
Message-ID: <20260721152540.002171836@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 663a79ec960d9f..b607d9422ef8d0 100644
--- a/drivers/gpu/drm/xe/tests/xe_pci.c
+++ b/drivers/gpu/drm/xe/tests/xe_pci.c
@@ -9,7 +9,6 @@
 
 #include <kunit/test-bug.h>
 #include <kunit/test.h>
-#include <kunit/test-bug.h>
 #include <kunit/visibility.h>
 
 #define PLATFORM_CASE(platform__, graphics_step__)					\
-- 
2.53.0



