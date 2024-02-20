Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D40614A4E6;
	Tue, 20 Feb 2024 21:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464414; cv=none; b=nsfBhFcJvIrGrl7saGwY7kyDSN7zalpfSPeReVo4DU1iTdhSnPsWQ+nW6wjfPEMIHcrdlSy8rruyORDUomdTfMqUEqSBXnVwYVyH8VJ4OYdrwIZj30deISj3GhmoLZC6KKuL9ctircjZVEooLbhb6tAM8emKYs+yY8VTtzjqslU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464414; c=relaxed/simple;
	bh=qZB1WY9/GiOnpRpFJiC3No44lIzZoovOzxkvERzS31g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dGaFv7OlVSVkE3svf5V0YfBn9TGe5Ft7QaIatW5GU+O87iMDct4yXwhOrCogEF54vgjEdzP70AIP1rm4s422oV0UuIaaiD2F7y7bBf8o3qfXVnXdJspFeNiLbX2nxS/a4I/PuNTvmW060OnkgxJwz6pWcH5COfoV5r7h35R3YgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0eaxnuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0eaxnuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8220C433F1;
	Tue, 20 Feb 2024 21:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464414;
	bh=qZB1WY9/GiOnpRpFJiC3No44lIzZoovOzxkvERzS31g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0eaxnuu9nvVgRfI53V9eArYW2nC253XIvEMYTgsDchfs/FYKTvre3KJUA6tF1IyW
	 rZ/2SU5gPOCfnzsYj3GJGOhKoOtzdNgp2tp8/SQ8BW1+BODhvz/ZV9syrO+mEBztY7
	 HaA/j3FfaPVFCFDXrCpJ8kEj7zUy/Ga19dHQ4nOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hu Yadi <hu.yadi@h3c.com>,
	Jiao <jiaoxupo@h3c.com>,
	Berlin <berlin@h3c.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 018/309] selftests/landlock: Fix net_test build with old libc
Date: Tue, 20 Feb 2024 21:52:57 +0100
Message-ID: <20240220205633.740983970@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hu Yadi <hu.yadi@h3c.com>

[ Upstream commit 116099ed345c932a8ae4a0d884a8f6cc54fd5fed ]

One issue comes up while building selftest/landlock/net_test on my side
(gcc 7.3/glibc-2.28/kernel-4.19).

net_test.c: In function ‘set_service’:
net_test.c:91:45: warning: implicit declaration of function ‘gettid’; [-Wimplicit-function-declaration]
    "_selftests-landlock-net-tid%d-index%d", gettid(),
                                             ^~~~~~
                                             getgid
net_test.c:(.text+0x4e0): undefined reference to `gettid'

Signed-off-by: Hu Yadi <hu.yadi@h3c.com>
Suggested-by: Jiao <jiaoxupo@h3c.com>
Reviewed-by: Berlin <berlin@h3c.com>
Fixes: a549d055a22e ("selftests/landlock: Add network tests")
Link: https://lore.kernel.org/r/20240123062621.25082-1-hu.yadi@h3c.com
[mic: Cosmetic fixes]
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/landlock/net_test.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/landlock/net_test.c b/tools/testing/selftests/landlock/net_test.c
index 929e21c4db05..e07267acbc9a 100644
--- a/tools/testing/selftests/landlock/net_test.c
+++ b/tools/testing/selftests/landlock/net_test.c
@@ -17,6 +17,7 @@
 #include <string.h>
 #include <sys/prctl.h>
 #include <sys/socket.h>
+#include <sys/syscall.h>
 #include <sys/un.h>
 
 #include "common.h"
@@ -54,6 +55,11 @@ struct service_fixture {
 	};
 };
 
+static pid_t sys_gettid(void)
+{
+	return syscall(__NR_gettid);
+}
+
 static int set_service(struct service_fixture *const srv,
 		       const struct protocol_variant prot,
 		       const unsigned short index)
@@ -88,7 +94,7 @@ static int set_service(struct service_fixture *const srv,
 	case AF_UNIX:
 		srv->unix_addr.sun_family = prot.domain;
 		sprintf(srv->unix_addr.sun_path,
-			"_selftests-landlock-net-tid%d-index%d", gettid(),
+			"_selftests-landlock-net-tid%d-index%d", sys_gettid(),
 			index);
 		srv->unix_addr_len = SUN_LEN(&srv->unix_addr);
 		srv->unix_addr.sun_path[0] = '\0';
-- 
2.43.0



