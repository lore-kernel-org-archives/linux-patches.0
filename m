Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AA72DFF08;
	Tue, 17 Jun 2025 15:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175937; cv=none; b=TkoeBQ7pVzDz6oYPBmulzBsN6QvxRqNSxPVmKATIaOXlDuZ2Ic7N7kSGV1wrS3Jq3S8zwUo2DW9fhPq65TnaZpxNQRoBQuaRt017c4cNi8bJsA+uiv+v5mdPaCfBkISQgc5NPymgCluOQuiVSvj+fSJNVzhDWL2yZ7Aw01UZbnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175937; c=relaxed/simple;
	bh=7WKD1cS+S58nUAIYZQGSqyJr8ZKnJCLdfYHDamKSMb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFHlt1OgSAu1qHfbwILFI5QH8lNCNCpbxB25HvhgYPlasEXXnhqIaqmD1y5oNDh/HpQxPdz+THynVtNrKIps6OOItI3VjMi13Z13xgphEeRqspeGhZ/xIlo3w+SOmoqC6p4qGSjMxbHzjIborcG1JKcOO6GJY2MA58xIkeJ06HY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNaPnPEW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNaPnPEW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B1FC4CEE3;
	Tue, 17 Jun 2025 15:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175936;
	bh=7WKD1cS+S58nUAIYZQGSqyJr8ZKnJCLdfYHDamKSMb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNaPnPEWwodcFVZOLqM+42JxV5QZuaf5yAftrdYakO3dYVkzKEYmkeNVMtfb0o2ru
	 9xjHWfaqHkff4Ba0yJJ0qalww+apmvmDEfo5ERE02xRRjmATbRu9J7vGqDTljwT4z1
	 6vle69/lPFUWb8ShMwYSXQi4iW4ccknSJ87roLfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Leo Li <sunpeng.li@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 136/780] drm/amd/display: Dont check for NULL divisor in fixpt code
Date: Tue, 17 Jun 2025 17:17:24 +0200
Message-ID: <20250617152457.039274013@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit d01ca8708d95a561f6462a15cad94a2c0bec7042 ]

[Why]
We check for a NULL divisor but don't act on it.
This check does nothing other than throw a warning.
It does confuse static checkers though:
See https://lkml.org/lkml/2025/4/26/371

[How]
Drop the ASSERTs in both DC and SPL variants.

Fixes: 4562236b3bc0 ("drm/amd/dc: Add dc display driver (v2)")
Fixes: 6efc0ab3b05d ("drm/amd/display: add back quality EASF and ISHARP and dc dependency changes")
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/basics/fixpt31_32.c   | 5 -----
 drivers/gpu/drm/amd/display/dc/sspl/spl_fixpt31_32.c | 4 ----
 2 files changed, 9 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/basics/fixpt31_32.c b/drivers/gpu/drm/amd/display/dc/basics/fixpt31_32.c
index 88d3f9d7dd556..452206b5095eb 100644
--- a/drivers/gpu/drm/amd/display/dc/basics/fixpt31_32.c
+++ b/drivers/gpu/drm/amd/display/dc/basics/fixpt31_32.c
@@ -51,8 +51,6 @@ static inline unsigned long long complete_integer_division_u64(
 {
 	unsigned long long result;
 
-	ASSERT(divisor);
-
 	result = div64_u64_rem(dividend, divisor, remainder);
 
 	return result;
@@ -213,9 +211,6 @@ struct fixed31_32 dc_fixpt_recip(struct fixed31_32 arg)
 	 * @note
 	 * Good idea to use Newton's method
 	 */
-
-	ASSERT(arg.value);
-
 	return dc_fixpt_from_fraction(
 		dc_fixpt_one.value,
 		arg.value);
diff --git a/drivers/gpu/drm/amd/display/dc/sspl/spl_fixpt31_32.c b/drivers/gpu/drm/amd/display/dc/sspl/spl_fixpt31_32.c
index 52d97918a3bd2..ebf0287417e0e 100644
--- a/drivers/gpu/drm/amd/display/dc/sspl/spl_fixpt31_32.c
+++ b/drivers/gpu/drm/amd/display/dc/sspl/spl_fixpt31_32.c
@@ -29,8 +29,6 @@ static inline unsigned long long spl_complete_integer_division_u64(
 {
 	unsigned long long result;
 
-	SPL_ASSERT(divisor);
-
 	result = spl_div64_u64_rem(dividend, divisor, remainder);
 
 	return result;
@@ -196,8 +194,6 @@ struct spl_fixed31_32 spl_fixpt_recip(struct spl_fixed31_32 arg)
 	 * Good idea to use Newton's method
 	 */
 
-	SPL_ASSERT(arg.value);
-
 	return spl_fixpt_from_fraction(
 		spl_fixpt_one.value,
 		arg.value);
-- 
2.39.5



