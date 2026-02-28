Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B51037524F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302522; cv=none; b=AzGDLHS5O+hDgFsbQwGAbWnmyxf7ujznkho+LGTtYzj2ZtVPNSVAPDenz0c4j1zPdZA753j4Jv5FT29wtJMdcHl9Zj/1Kl0OJVYMENZ+dLg89a93EusqBdRgj8bDWTrxWy29iDjGsneRYeKt85LNIZoDvzgk5u6mmg7sOD/fcRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302522; c=relaxed/simple;
	bh=lTrZ1UxlWld0RDje9bmE2fGWToBl1TZMJFVRd8dTZ6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LCFhfr5RWYonlWa5JwC2AUmBcNQ7h3KMppSpgW77NdlvD9aQ3RdeeAhwT8YafkALWj0ytkbnaSX2RlbVxZfi6LD0wb+eaH8TEFcxw02HqRUbFTy+JTJ7d2QCCodR2AI0cFlWpoykQSpX5++OF/c8Ng/CYNnE5LrR60l2M9/vKEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h1Gr+v0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h1Gr+v0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD373C116D0;
	Sat, 28 Feb 2026 18:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302522;
	bh=lTrZ1UxlWld0RDje9bmE2fGWToBl1TZMJFVRd8dTZ6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h1Gr+v0GnCMHYOwb8YIVwhF8Yj4pyKeyAIYzS/h78bFawCRH/6CB50KkKgPE2+lYK
	 1hO6f83GrZzA7a6Tr6yxyEhioq6sJtaYC/sg6RGZZtS2Ko2A1CirDBYHBSfAJfFj+K
	 OpN2KtzG3mAy6WNaBo/E3E7CmCGjcOhL0ekCm/XGqRdKkabUvyXoZYwJbRLBle0Qpr
	 Skg9u4UsakuEvvmTIWC0hl7InO+t9nZ4kuoO8zePT+cNfakWXf4sF0QlFIg7IIOQ6C
	 6AubsbHhmuJ4F6tQmbcrdUEwXDM8A/lWxeMKBc0BmntyW1SI1OfkBQ2kTqwi5hTyRJ
	 AzyhlURhOdMAA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 020/164] ARM: VDSO: Patch out __vdso_clock_getres() if unavailable
Date: Sat, 28 Feb 2026 13:12:39 -0500
Message-ID: <20260228181505.1600663-20-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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

