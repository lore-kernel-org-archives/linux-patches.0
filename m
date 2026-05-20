Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F1A3B3886;
	Wed, 20 May 2026 16:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294914; cv=none; b=SgAJvSZJd47zZSb7dxs4oZVmBgbwbPOut22wRb5o9c7kc6M/Ap8fWJngONk0PXFLfEOO882+/Ir32T5rcgfAczy4Dx7MBXkmjdxdNovaNCILCvNs6dOnw/DtUCiMn2z6DXsvv2LVs+XF1LvzUMqwUDsvcR0Ie0ezQyZbZajfGZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294914; c=relaxed/simple;
	bh=kIavojjj7+2xkl5kpgU+sZ4DbVg2jp8nWvQ6udu5lFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftbJ6S3J+d7tslz5kogYMQlh8AhEp5/lFVB3VSNzPfH54c7ZdrAavY5BREYZHTKmJk4qHhvyI7oDJlcn5TkMAtxzi8jCM3MFNRkYeCoY0NI8ze7T9MclpWsdDNALzY17EGsbwCSZztm1zoTLZydfokITaPuiNC3UfEP+4p6b/9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDKJz7xL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDKJz7xL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2454C1F000E9;
	Wed, 20 May 2026 16:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294913;
	bh=7AT/EfZVZqQu59+72RJGeEp8O92Xx5DT67DP+ccm3Ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDKJz7xL3M6Szf0W/sp796enoRpOihF9qNoqCGKmGFHD2dgFllaAFCCY4hAQeeMJ+
	 co5mPdD3x6dHj1kR1KzrqPzim18HnQeB2DHkxTpYLyulEJNMdEfUy7O9AA4voHV4yD
	 4wd7WQiSDnov5G8cuMITtOix8vt5JuvU9P0JImWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0221/1146] selftests/namespaces: remove unused utils.h include from listns_efault_test
Date: Wed, 20 May 2026 18:07:51 +0200
Message-ID: <20260520162153.258465937@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit cad3bf1c330274d11f25f1b7afae9b9dba13fbd3 ]

Remove the inclusion of ../filesystems/utils.h from listns_efault_test.c.
The test doesn't use any symbols from that header. Including it alongside
../pidfd/pidfd.h causes a build failure because both headers define
wait_for_pid() with conflicting linkage:

  ../filesystems/utils.h:  extern int wait_for_pid(pid_t pid);
  ../pidfd/pidfd.h:        static inline int wait_for_pid(pid_t pid)

All symbols the test actually uses (create_child, read_nointr,
write_nointr, sys_pidfd_send_signal) come from pidfd.h.

Reported-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/all/acPV19IY3Gna6Ira@sirena.org.uk
Fixes: 07d7ad46dad4 ("selftests/namespaces: test for efault")
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/namespaces/listns_efault_test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/namespaces/listns_efault_test.c b/tools/testing/selftests/namespaces/listns_efault_test.c
index c7ed4023d7a85..b570746e917c1 100644
--- a/tools/testing/selftests/namespaces/listns_efault_test.c
+++ b/tools/testing/selftests/namespaces/listns_efault_test.c
@@ -19,7 +19,6 @@
 #include <sys/wait.h>
 #include <unistd.h>
 #include "../kselftest_harness.h"
-#include "../filesystems/utils.h"
 #include "../pidfd/pidfd.h"
 #include "wrappers.h"
 
-- 
2.53.0



