Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024327;
	b=aLRyNdHH3zVAzSLj6ullosZrIUvJCXHfEPtgLOu+8mDIc56n6gFsjxxkYjcTZLytK4oM
	 TWflxlv0ZqDLtdBZDqIQWLZ2OC4NTGkDsiSgTnonGVn+5509nf1B7WmE0k9CjY3BYQvuZ
	 hGJC/0LroLdqHeMtI8MMHQSR5/wkNeQZhefu+hCJEDOoVpKZL/bHICSok40KvR0uAhyx4
	 D0h/SC/eEUDtIVUYBIhm1SMCGbJYoI3ZyZGjvG5FiwRhMR1eQ6bbft+y4/NNYuCBwTuQJ
	 Dzs5YY5yHCkjBMR5EZuzCo5HEWfhqx+k9RcNeJ1znb4ucRIqXmMx0KI+aFo7cL2V14g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X0pFYAUtbNjsQx0/lSHFsF5mVG4b4rtY6PWIOkALsFY=;
	b=Gwoh/lL4IftF/I6cnr2pvPDmYPfVwev0CNTFxtc/wiKO5MCUOsWvnSlsNzhJ5hfKJbVZ
	 HD8Mzma+rA8lZ9pep2dggcT3dj7Hixhwnoms0GDYunGHQmk4U+JK1wfmKPaaqjCZgXIRX
	 eCKE1xZ/khW5LYD7Cug7md/D+nzXkERgO2I7w3c5Jc0ja3E9q8aIxK5yMn7ZRQG3xk4wK
	 B2+3tWniDTzTZIyIekUfsUo3sCo1qSW4I9mB97T2FPqDXRC9RwTSwBAj/dLPtTXtsA4it
	 bi3E/dH+QzfmeY4CEoaZjlc8XQQCvFKvlz2DG5tTQ69cApvQl1mHh40AE+S/AXkhUBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWT634fb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBD6606A33B;
	Wed, 18 Nov 2026 17:52:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iWT634fb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B4171F000C4;
	Wed, 18 Nov 2026 17:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024327;
	bh=X0pFYAUtbNjsQx0/lSHFsF5mVG4b4rtY6PWIOkALsFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iWT634fbcrbly+1z04PX9sloPNd56LnrMdLapXQNolN37Ze/Q6K5NjMWYB8hxv3fq
	 VNDNO0kOHz9+dhZU3c68wlqYFML+kWQTvS6vVqGTWiz4cqgWpzSDwsZYZSa+5ATL4P
	 2d7a6k6BECgrcScVGuX6/PZxE3nOB4Mh2pqvyGGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0685/2151] um: Add definition of __NR_close_range for older host OSs
Date: Wed, 18 Nov 2026 15:40:20 +0100
Message-ID: <20261118150146.756344463@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 03dcf7bd302c9bae0c75a21a3004a44b4940317e ]

__NR_close_range was introduced with
278a5fbaed89dacd04e9d052f4594ffd0e0585de ("open: add close_range()")
which is present in Linux >= 5.9. Older hosts running a kernel version
prior to that range currently fail to build due to that missing system
call number definition.

Fixes: f82a9e7b9fa9 ("um: fix execve stub execution on old host OSs")
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260812173249.98435-1-florian.fainelli@broadcom.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/include/shared/skas/stub-data.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/um/include/shared/skas/stub-data.h b/arch/um/include/shared/skas/stub-data.h
index 27db38e95df91..1230a325debcd 100644
--- a/arch/um/include/shared/skas/stub-data.h
+++ b/arch/um/include/shared/skas/stub-data.h
@@ -9,11 +9,20 @@
 #define __STUB_DATA_H
 
 #include <linux/compiler_types.h>
+#include <asm/unistd.h>
 #include <as-layout.h>
 #include <sysdep/tls.h>
 #include <sysdep/stub-data.h>
 #include <mm_id.h>
 
+#ifndef __NR_close_range
+# if defined(__alpha__)
+#  define __NR_close_range 546
+# else
+#  define __NR_close_range 436
+# endif
+#endif
+
 #define FUTEX_IN_CHILD 0
 #define FUTEX_IN_KERN 1
 
-- 
2.53.0



