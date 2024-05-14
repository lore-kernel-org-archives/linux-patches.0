Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19DEDDC0;
	Tue, 14 May 2024 10:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682965; cv=none; b=D+N6oW8OFeWSiS/5xZNj2sYGMloldlMUaDO9T2LgP2H2BoHNnkvbQXDCuOB5AVDb7hwbb6ra+vwZGPlxEMH0/u0Eiea4C1t6Bs00a9wjyhUCmt2yzJzlR4ENz5gGZ5wSuyok+p8BmaJQmZ8PZnV02nhF9/OLfCybFF6JUhwY3p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682965; c=relaxed/simple;
	bh=YstC1Fy93IZqNND+Q3dFnFgYLlnaWAtErexliKNuqfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aB7ONwCrfqEvGlze8vluK3kVhbwWF3Bj3yP9fXMRejTkKULVpxaTCEOTL+BrV02kF6D2z5zMiENlUqXrBfOC0aTwghHR6oJvrefCr3xogUnnJb5njWj2tzDZocqteF3Lr+OrvMSr6Ysv1LUK1c/CUDJl4owDNxPQ3VerJwLx+rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5u5/wOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5u5/wOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0694C2BD10;
	Tue, 14 May 2024 10:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682965;
	bh=YstC1Fy93IZqNND+Q3dFnFgYLlnaWAtErexliKNuqfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N5u5/wOLwe9McWRMrYU9xzSClHmsefB5QrCRnStgAsg/E9rO/D5xxv2bR5qgRAf6j
	 4nn22OCU7s+cKYKjnvC4Ybzxm0b2ATN7K/3JHc1WaH0JZa/eBV8LYt80AG8+A3xzWi
	 cDEsRyVWQhi6pJHS2M3Ckd/UMMyuHeJTzGmNkE7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Jani Nikula <jani.nikula@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 111/336] drm/xe: Fix END redefinition
Date: Tue, 14 May 2024 12:15:15 +0200
Message-ID: <20240514101042.795065770@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 0d8cf0c924732a045273c6aca6900a340ac88529 ]

mips declares an END macro in its headers so it can't be used without
namespace in a driver like xe.

Instead of coming up with a longer name, just remove the macro and
replace its use with 0 since it's still clear what that means:
set_offsets() was already using that implicitly when checking the data
variable.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Closes: http://kisskb.ellerman.id.au/kisskb/buildresult/15143996/
Tested-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240322145037.196548-1-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit 35b22649eb4155ca6bcffcb2c6e2a1d311aaaf72)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_lrc.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index b38319d2801e0..0aa4bcfb90d9d 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -95,7 +95,6 @@ static void set_offsets(u32 *regs,
 #define REG16(x) \
 	(((x) >> 9) | BIT(7) | BUILD_BUG_ON_ZERO(x >= 0x10000)), \
 	(((x) >> 2) & 0x7f)
-#define END 0
 {
 	const u32 base = hwe->mmio_base;
 
@@ -166,7 +165,7 @@ static const u8 gen12_xcs_offsets[] = {
 	REG16(0x274),
 	REG16(0x270),
 
-	END
+	0
 };
 
 static const u8 dg2_xcs_offsets[] = {
@@ -200,7 +199,7 @@ static const u8 dg2_xcs_offsets[] = {
 	REG16(0x274),
 	REG16(0x270),
 
-	END
+	0
 };
 
 static const u8 gen12_rcs_offsets[] = {
@@ -296,7 +295,7 @@ static const u8 gen12_rcs_offsets[] = {
 	REG(0x084),
 	NOP(1),
 
-	END
+	0
 };
 
 static const u8 xehp_rcs_offsets[] = {
@@ -337,7 +336,7 @@ static const u8 xehp_rcs_offsets[] = {
 	LRI(1, 0),
 	REG(0x0c8),
 
-	END
+	0
 };
 
 static const u8 dg2_rcs_offsets[] = {
@@ -380,7 +379,7 @@ static const u8 dg2_rcs_offsets[] = {
 	LRI(1, 0),
 	REG(0x0c8),
 
-	END
+	0
 };
 
 static const u8 mtl_rcs_offsets[] = {
@@ -423,7 +422,7 @@ static const u8 mtl_rcs_offsets[] = {
 	LRI(1, 0),
 	REG(0x0c8),
 
-	END
+	0
 };
 
 #define XE2_CTX_COMMON \
@@ -469,7 +468,7 @@ static const u8 xe2_rcs_offsets[] = {
 	LRI(1, 0),              /* [0x47] */
 	REG(0x0c8),             /* [0x48] R_PWR_CLK_STATE */
 
-	END
+	0
 };
 
 static const u8 xe2_bcs_offsets[] = {
@@ -480,16 +479,15 @@ static const u8 xe2_bcs_offsets[] = {
 	REG16(0x200),           /* [0x42] BCS_SWCTRL */
 	REG16(0x204),           /* [0x44] BLIT_CCTL */
 
-	END
+	0
 };
 
 static const u8 xe2_xcs_offsets[] = {
 	XE2_CTX_COMMON,
 
-	END
+	0
 };
 
-#undef END
 #undef REG16
 #undef REG
 #undef LRI
-- 
2.43.0



