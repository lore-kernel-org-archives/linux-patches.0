Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DD27B3E5;
	Mon,  8 Apr 2024 13:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582107; cv=none; b=IUaPOcPpTHamLsO+mBYLXz0hDwg9m3RsocZHcTLRCQ7fMMQkJqAji1RdjYQLB6fDBMYgxNvTLP2Z1nfBNJw7vgP1A7pVCcBBJlqr0tjOd3kzez+Gr1vTfe1QWmbdC3qOSE9hROzV1vFX+baZdTLSfPfCPWmAzL+miJZiTgJgvYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582107; c=relaxed/simple;
	bh=kP7pcnOqa0nA1jy0RYHQOLTyU9I5x8oM98oAPNGHhAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUTEV4a5OmChEegMeBV8QOYCVexGgqaQ7qIVJAwlp3MTOGDKkxJfKwNZLPMbdwZHlim9HH3/5ysFH+9Ro2fKXEZcufsx8k6R2pxavVHv3xWuycKESwBwtHj5r2VgRiJciCXZ0J37eZBZmMPXfAsRsENozK5slFHpXOGffgQs6Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m+/pBcZG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m+/pBcZG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F93C43390;
	Mon,  8 Apr 2024 13:15:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582107;
	bh=kP7pcnOqa0nA1jy0RYHQOLTyU9I5x8oM98oAPNGHhAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m+/pBcZG6N1omfB+UfQG6gxrHD1hYR4bgv8ThZ5M+tCo6qvTK9U2Etz0ME8JSF/FK
	 WAl1zidEj7WDAqUeyiTp7IuoV9zI1CbkgF7lUsi9or6T1GlmRSWHrK796deevsgRV4
	 vtTsOhNay0QSDUxzeuJrB6J1DtP5LuxvG9hyKDLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/252] x86/cpufeatures: Add new word for scattered features
Date: Mon,  8 Apr 2024 14:56:03 +0200
Message-ID: <20240408125308.626200816@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sandipan Das <sandipan.das@amd.com>

[ Upstream commit 7f274e609f3d5f45c22b1dd59053f6764458b492 ]

Add a new word for scattered features because all free bits among the
existing Linux-defined auxiliary flags have been exhausted.

Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lore.kernel.org/r/8380d2a0da469a1f0ad75b8954a79fb689599ff6.1711091584.git.sandipan.das@amd.com
Stable-dep-of: 598c2fafc06f ("perf/x86/amd/lbr: Use freeze based on availability")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/cpufeature.h        | 6 ++++--
 arch/x86/include/asm/cpufeatures.h       | 2 +-
 arch/x86/include/asm/disabled-features.h | 3 ++-
 arch/x86/include/asm/required-features.h | 3 ++-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
index a1273698fc430..42157ddcc09d4 100644
--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -91,8 +91,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 18, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 19, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 20, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(REQUIRED_MASK, 21, feature_bit) ||	\
 	   REQUIRED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 21))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 22))
 
 #define DISABLED_MASK_BIT_SET(feature_bit)				\
 	 ( CHECK_BIT_IN_MASK_WORD(DISABLED_MASK,  0, feature_bit) ||	\
@@ -116,8 +117,9 @@ extern const char * const x86_bug_flags[NBUGINTS*32];
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 18, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 19, feature_bit) ||	\
 	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 20, feature_bit) ||	\
+	   CHECK_BIT_IN_MASK_WORD(DISABLED_MASK, 21, feature_bit) ||	\
 	   DISABLED_MASK_CHECK					  ||	\
-	   BUILD_BUG_ON_ZERO(NCAPINTS != 21))
+	   BUILD_BUG_ON_ZERO(NCAPINTS != 22))
 
 #define cpu_has(c, bit)							\
 	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index bc66aec9139ea..a42db7bbe5933 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -13,7 +13,7 @@
 /*
  * Defines x86 CPU feature bits
  */
-#define NCAPINTS			21	   /* N 32-bit words worth of info */
+#define NCAPINTS			22	   /* N 32-bit words worth of info */
 #define NBUGINTS			2	   /* N 32-bit bug flags */
 
 /*
diff --git a/arch/x86/include/asm/disabled-features.h b/arch/x86/include/asm/disabled-features.h
index 702d93fdd10e8..88fcf08458d9c 100644
--- a/arch/x86/include/asm/disabled-features.h
+++ b/arch/x86/include/asm/disabled-features.h
@@ -143,6 +143,7 @@
 #define DISABLED_MASK18	(DISABLE_IBT)
 #define DISABLED_MASK19	0
 #define DISABLED_MASK20	0
-#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
+#define DISABLED_MASK21	0
+#define DISABLED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 22)
 
 #endif /* _ASM_X86_DISABLED_FEATURES_H */
diff --git a/arch/x86/include/asm/required-features.h b/arch/x86/include/asm/required-features.h
index 7ba1726b71c7b..e9187ddd3d1fd 100644
--- a/arch/x86/include/asm/required-features.h
+++ b/arch/x86/include/asm/required-features.h
@@ -99,6 +99,7 @@
 #define REQUIRED_MASK18	0
 #define REQUIRED_MASK19	0
 #define REQUIRED_MASK20	0
-#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 21)
+#define REQUIRED_MASK21	0
+#define REQUIRED_MASK_CHECK BUILD_BUG_ON_ZERO(NCAPINTS != 22)
 
 #endif /* _ASM_X86_REQUIRED_FEATURES_H */
-- 
2.43.0



