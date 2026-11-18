Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017140;
	b=fLYSQ8LJo0bfhrODZHOv5E+7rBEHz/zybF3gJ7oopaBz0Q+zmowrnssKKxoMJlDBFEgf
	 pDXo+QzVblN9Y2mUcF8S9lVTIWxWTOFwLLQvrOFce9ctvFkxIVgrPpd5AtXxRbyap2sy0
	 ttV95Yby5VVWYeNvvnxk7V4XRj4mrKQeCk2hXZshBlZdyOR+uVFY5Iu63ogVHqLpO2cDs
	 56SYleqJoCNqq99cSZSTs7TZu8074eOfZpN7ig5w4/rMeF52wuY5a9HLXA9rJkxMPF9Bi
	 PVjazAhfc2rFXVUDdjOsZDe3kOIR1TVPMgenIg38sc2iq+26udYmXTG5AISfINuHbEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QGwYKEODoeZ/Vn3UlndMNV6dMz5aEC8kKA6o50++hag=;
	b=CJQ4ZyHa9L9mxKUgxPQf1q8FyQ5eN3DIJWh24jql/zDTL1uZLzqGzmvP6PLYMtLcBr2Y
	 +bCuGe5uTGjftA7b9f8PhEIjfq91k8FzwbIwtqk5DMxmJK8wLTFi+XIoovYz5FaW9+4/t
	 laVT8DcRJZMYbgRqdYshsAf7hv03k9AltzG7wbObhH+0OjSqTWsltZTv+PD/fuNNEnQvz
	 /hDCMe/ovYXRAvK9gH8EQekvJZBjmSlt8VCBeoZxXK9T//b/WA8sGlCoqJ8blyY+krnRn
	 6fa96PRGDdNZqtkTJ2WCaauYBS7/vl5pI3m8OJwE51PXmYcbtewOjRIaabbIRfJGwKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Fn5eI/YO";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B388A606A31C;
	Wed, 18 Nov 2026 15:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Fn5eI/YO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13F2F1F000C4;
	Wed, 18 Nov 2026 15:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017140;
	bh=QGwYKEODoeZ/Vn3UlndMNV6dMz5aEC8kKA6o50++hag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fn5eI/YOBugl4rJy1Ap9Uv7cQuikcfgaF9tFoG8p4J96x1VrA5CFPw9awpXtLiId+
	 klsA9Z7UK/z4umeM5UAIUw74SM+RtEzCVYGnK6MS8v1iFVlSCnunfWQM/kdc+3Cn6m
	 Y/juxUy6tqJALAbMFIKe5oG3cUzovB+2JIyPIPq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0776/2651] um: Add definition of __NR_close_range for older host OSs
Date: Wed, 18 Nov 2026 15:33:36 +0100
Message-ID: <20261118150315.824854753@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



