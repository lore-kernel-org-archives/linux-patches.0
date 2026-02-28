Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7308035AC00
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302674; cv=none; b=bTJ8c/8Ifu6o1BTUWUjGfSKfIu/mLUhDqupcQx6NWhUivYiF4lKaocqVd7z4D0e9P/xQiUnZtQRV1jUXuEe20mz6ZsJvT9xc4OO1LidecxlPqLm0sCyd9wW+EBo4c3MzzGvKcyHpUm71vmoEoV2Si9YdzblO48E6OBdL/1Ad7gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302674; c=relaxed/simple;
	bh=zVNcQFwlUQomzsmXETWLRsmPFgEy6P2BfODQp+1bAG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D/q3tKo3sEi/97JBhndK94FebFfk/sbXfQ4BOrS0HFxG9y27LxKe86/T1OMesB2XHN9dWvYT2CAb1TBynvwpg4j3ZQqtHDCioVI9lKp2uX3f1HA5Gge4/LSs21xyX6ljXzDWQlcO3RlbrbauWQgli7HzPT0s2RtXlR8cmMPZCik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bk6M0hP+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bk6M0hP+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8287C19423;
	Sat, 28 Feb 2026 18:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302674;
	bh=zVNcQFwlUQomzsmXETWLRsmPFgEy6P2BfODQp+1bAG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bk6M0hP+MvCcVHPT72MF4/JG7burXjlvkOhZrQYS4C6rHz7nlayADTMFBi4+lArXh
	 avRabF3+PP6BZaBv70FX5WaDwUx4k/oRtzyp1AbPTVY4BY3c0RDFp0wCWp3bmTNNqL
	 dfES0dtcaaH6iYun0blju+mraBhBuj3uvtGo7GJzaeUqA5T0655PTHVULXk3UH3YJ5
	 VyfBF6pa1NQRi6RT2Lqnth7uD8H+UcZyYqi4gOfJLst1s0VL2MY7nZ1B2ct3PFDVB4
	 /KRRMReCRYyAzLvsrlbt1fNpaf7MQrnpYecO13inNX8+36tLnvHZQpjMWhAekpyrW+
	 2GvdAmmY006Bw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/147] ARM: VDSO: Patch out __vdso_clock_getres() if unavailable
Date: Sat, 28 Feb 2026 13:15:31 -0500
Message-ID: <20260228181736.1605592-23-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index fddd08a6e063e..5a64bbf119e22 100644
--- a/arch/arm/kernel/vdso.c
+++ b/arch/arm/kernel/vdso.c
@@ -185,6 +185,7 @@ static void __init patch_vdso(void *ehdr)
 		vdso_nullpatch_one(&einfo, "__vdso_gettimeofday");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime");
 		vdso_nullpatch_one(&einfo, "__vdso_clock_gettime64");
+		vdso_nullpatch_one(&einfo, "__vdso_clock_getres");
 	}
 }
 
-- 
2.51.0

