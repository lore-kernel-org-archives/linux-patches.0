Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717F537703F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301655; cv=none; b=XAJFGe6H+4KZtnTtFKQYKPLnBexyK+QR4aaBlnG7XuTFCQcY7DZ6smeHISfMJVT7MfW9eje6eSy0MkJtyd/BZHGSpQkpX4REkKWLI9wyOcoeS94CyoBIXfRetBthqIA3XZyHilMnWGzvW+glsVpJaCvle9Yy/3NKS9d5chj3E+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301655; c=relaxed/simple;
	bh=RzUr7pWp4i4xTDZ2pQ7q38Bt1Dlk0BJbTbPMT5r1jsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qh2dfucZ2yP1eEaaZrQ9O+yaftxgSgiOrf3/t6OT5YCspyuWLmGeGexqfn2pyacS3wZvvkazyNEFeLLs6F4C4W8V/7DBTwMhqvmeNvDDCbyDJRUtb+bVfZ78MiKm2AaGua+/7LfcjYz8NM3LUggBisPs+UCyWXjrA3ZzinOzAiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qj5zPL3C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qj5zPL3C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D34C6C19423;
	Sat, 28 Feb 2026 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301655;
	bh=RzUr7pWp4i4xTDZ2pQ7q38Bt1Dlk0BJbTbPMT5r1jsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qj5zPL3CCz4m7ARo+Ocryi/+fUAktG9knQviUsPepTeqn2oJUUgKTJb3pHYrraw/v
	 SK5nSHZMR+UfSXppfoxv7hRyrP5E42IwVIiZyUGxjmemH0IHDtSXBr8CMCFofoKc5j
	 q39X8ASu1g1nKVqzNuRx+ykUmTVstJC8D2AWkThyTS19D/7+X+qcvOJgaEg4EE13dt
	 mkzrPFM1FCwz7xZPqZgda84NlZS2hDSAjjVCF/bRR6541ODF2tcNPiY0Acrn/VjNO/
	 +nvUfwCJ8LjD0jru4jsrmIxjlHApm5fYeZVBJNnrm8vRuSMEg1zrKV0n+OQCaYdSXP
	 OQFwjQ8s2psWA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/385] ARM: VDSO: Patch out __vdso_clock_getres() if unavailable
Date: Sat, 28 Feb 2026 12:54:34 -0500
Message-ID: <20260228180011.1568201-52-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index d499ad461b004..6e5494bf5a24d 100644
--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -172,6 +172,7 @@ static void __init patch_vdso(void *ehdr)
 		vdso_nullpatch_one(&einfo, "__vdso_gettimeofday");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime64");
+		vdso_nullpatch_one(&einfo, "__vdso_clock_getres");
 	}
 }
 
-- 
2.51.0

