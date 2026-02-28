Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8074536C9E3
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302314; cv=none; b=kIId6ojOd7Kzx/XOrEYNFqdCR3+6A36Eoac7rBTWDJ8XVOKuMYHORNzZlV3/zd1Jy1rJ9jXCQx8xM3exdYTubEefka2Foql7LHXv7Nhaxcwga7fQd4vESZuObdKXMVHdFcq1WvWDhzyeFLyvF/kkgHno9m281MWN7nPaQ7Jiu2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302314; c=relaxed/simple;
	bh=lTrZ1UxlWld0RDje9bmE2fGWToBl1TZMJFVRd8dTZ6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HFq1RN8+/uZeEyG7GmkrmkgoKPhlFY/LLGB7cFbCJO96+84MghFf6ohJnnG2rcUNqOgdFN+3B7JlewjFrNz2UwC/lqWpPATkMRyUe6w0sn5HNomL70DYFttI5/OASRhHLg/fhKuRAr4S3Ci9HaN3NOlGdyzsAn8EPOVZ48SRWbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VMY7MABl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VMY7MABl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCCF1C19424;
	Sat, 28 Feb 2026 18:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302314;
	bh=lTrZ1UxlWld0RDje9bmE2fGWToBl1TZMJFVRd8dTZ6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMY7MABlR3xr6mo50HlOYkj9EnRKG3mqOGO23t34Zj7wIE3f06HY11HG4gWMg7lxS
	 tgFM0zjPOUmUR2VbGZnnnDW1wATP5fBnLN3yAl5YL2SgjdaEaj7835jF8GydcH+y5N
	 lq9PvwvpD9Y/Fk+Hu272dGjgq+uqKWeD8DjA1/XH/SW5J4FJzUKk7doJ7HcW68QWpW
	 2FIcGKWePQSnkwYw3xSanhuLGperfFiJTDKCBu1Acm7o5R3BYpS650BKLH5OKpsaKU
	 nhIA9RRqjwFZcAcU2OY4vqyZ9xJsVwfcShAZzaYP4C187TS7vBICbi7H+UWbtCHhR6
	 84Eumu1qJWlvA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/232] ARM: VDSO: Patch out __vdso_clock_getres() if unavailable
Date: Sat, 28 Feb 2026 13:08:04 -0500
Message-ID: <20260228181127.1592657-31-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b9fecf0dddfc55cd7d02b0011494da3c613f7cde ]

The vDSO code hides symbols which are non-functional.
__vdso_clock_getres() was not added to this list when it got introduced.

Fixes: 052e76a31b4a ("ARM: 8931/1: Add clock_getres entry point")
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20251223-vdso-compat-time32-v1-6-97ea7a06a543@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/vdso.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/kernel/vdso.c b/arch/arm/kernel/vdso.c
index 3408269d19c7d..b38f4a1bc9b8a 100644
--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -176,6 +176,7 @@ static void __init patch_vdso(void *ehdr)
 		vdso_nullpatch_one(&einfo, "__vdso_gettimeofday");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime64");
+		vdso_nullpatch_one(&einfo, "__vdso_clock_getres");
 	}
 }
 
-- 
2.51.0

