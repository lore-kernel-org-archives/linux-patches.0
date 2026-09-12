Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F44F332610;
	Sat, 12 Sep 2026 11:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212845; cv=none; b=W5EzMN20dmIy80gmOVYiSYtkIZ7oWpDkVqliEabMelbJj8rEzyhA3FNaaH1BZP4GhT3Al3uzXf9fZpZzZIk0UijBj8zudNOeNtFMy/5mYrK/wYtld2mCmPvr262J2/TH20dHmuWYMMMe4HeW04k0zyn2QDMCC9UB8Y0bKnKcU70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212845; c=relaxed/simple;
	bh=20sShSTWXbdDyV1rhQpZyzjv385O8FMQDn7NpuIrSEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HDqSKnsU/4oEwqb46biySZFB6GuXBVqFc69XKCEASaT5JsxlV2f9edcnkn+zONYi22UKol/eFJD1TdCBArSMwIBNxQ1l/vYhwaxqrUu/zGIOh/5rWecnMm/NfU79GAmAh5x91XukvgFS5N0SbGBwu7n6hGsIQti28/wWanbe1bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjSeJ/o/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjSeJ/o/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22E651F000FF;
	Sat, 12 Sep 2026 11:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212843;
	bh=XmqAXaNE/kPiMf+tBplsb/h4m8Ph1mRdWIAcUtpik+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjSeJ/o/12xomf+u5LCaXMpVdNh57M6HXlTWXOkCUZpRd+FvRgH+tReriYagglaS2
	 wBOMNYW3lD80kJ0EwwvQ2QeosdRY7OsNYh2KbRMBdjHJRxjATQRmGQsRMAZvk5hk3Q
	 r5gVn13Sei3wSJAn3t8oWbFnig8qpo7d6MD30xm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1475/1518] selftests: vDSO: getrandom: Fix path to s390 chacha implementation
Date: Sat, 12 Sep 2026 09:00:44 +0200
Message-ID: <20260912065656.923592408@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit d045e166d3c51b7aec069669bb243e057d80d04f ]

The s390 vDSO source directory was recently moved,
but this reference was not updated.

Fixes: c0087d807ae8 ("s390/vdso: Rename vdso64 to vdso")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/vDSO/vgetrandom-chacha.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/vDSO/vgetrandom-chacha.S b/tools/testing/selftests/vDSO/vgetrandom-chacha.S
index a4a82e1c28a90..8c3cbf4dfd6a1 100644
--- a/tools/testing/selftests/vDSO/vgetrandom-chacha.S
+++ b/tools/testing/selftests/vDSO/vgetrandom-chacha.S
@@ -14,7 +14,7 @@
 #elif defined(__riscv) && __riscv_xlen == 64
 #include "../../../../arch/riscv/kernel/vdso/vgetrandom-chacha.S"
 #elif defined(__s390x__)
-#include "../../../../arch/s390/kernel/vdso64/vgetrandom-chacha.S"
+#include "../../../../arch/s390/kernel/vdso/vgetrandom-chacha.S"
 #elif defined(__x86_64__)
 #include "../../../../arch/x86/entry/vdso/vgetrandom-chacha.S"
 #endif
-- 
2.53.0



