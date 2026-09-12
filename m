Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D53339381;
	Sat, 12 Sep 2026 10:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208559; cv=none; b=Hf37/pdegdZFoA2zpazDw4VcVZAw3aQi8PIvO4Wg7vY0XSPTs/YlJhOrO0UbMxjK/qdIBN2DaGw2E3JjK1czlskxvS5ZG2aAwcLhq8oFfMYAHgyv0/cReIHx2tLaWPId9N43CF0wVzbn4zf41P4Tl+RZ3jiIK11OPcTUWKAZNPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208559; c=relaxed/simple;
	bh=S3jQR6yzzd2A8SkP/EerG5ZP0PIgkWDULM2FgJa2SiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ak9wbSqgd4kCgv3JPnECB4pQkv1DYZGmxijhkxh2KjItmFct5yvilzgbXOhvWixK5HskB5ee2E/hRbcX5Mcr80HysznlCoFTAJr9FtT9PKfgB7xbwBlEGJJ5GMObcVfCJMSy+SKVNOBy9/Nsa3WfkvrDWFLd84cE3hqwh094O60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H2KE3ycI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H2KE3ycI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499591F00893;
	Sat, 12 Sep 2026 10:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208554;
	bh=i7gG+QS4bubovIIxYXaIF9qpMXROPQzvt6G2E9ijzPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H2KE3ycIrZQr2UL083mIdveB3zX3OdIPcHA2QJs7ShBj73LM164OJ7sHUNLII0kAz
	 uFSAW3RixovTC3uB69dJfgysnwJkgm59qVN5DBlsySk12qZxnOz7JLsHlgfCUUTSU+
	 rrdK7xlEWalOiKBDPLDZjKXvGyPLzf8cbgY5gDGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0639/1518] s390/ptrace: Rename psw_t32 to psw32_t
Date: Sat, 12 Sep 2026 08:46:48 +0200
Message-ID: <20260912065637.884724130@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <hca@linux.ibm.com>

[ Upstream commit 8c633c78c23a85a9efbabbe47d815ebdd7739905 ]

Use a standard "_t" suffix for psw_t32 and rename it to psw32_t.

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Stable-dep-of: dc161efb6df8 ("s390/vdso: Pass --eh-frame-hdr to the linker")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/boot/ipl_data.c       | 2 +-
 arch/s390/include/asm/ptrace.h  | 2 +-
 arch/s390/kernel/compat_linux.h | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/boot/ipl_data.c b/arch/s390/boot/ipl_data.c
index c4130a80b058e..7957cc6554e77 100644
--- a/arch/s390/boot/ipl_data.c
+++ b/arch/s390/boot/ipl_data.c
@@ -12,7 +12,7 @@
 #define PSW_MASK_DISABLED (PSW_MASK_WAIT | PSW_MASK_EA | PSW_MASK_BA)
 
 struct ipl_lowcore {
-	psw_t32		ipl_psw;			/* 0x0000 */
+	psw32_t		ipl_psw;			/* 0x0000 */
 	struct ccw0	ccwpgm[2];			/* 0x0008 */
 	u8		fill[56];			/* 0x0018 */
 	struct ccw0	ccwpgmcc[20];			/* 0x0050 */
diff --git a/arch/s390/include/asm/ptrace.h b/arch/s390/include/asm/ptrace.h
index dfa770b15fadb..f2ecc013a48a5 100644
--- a/arch/s390/include/asm/ptrace.h
+++ b/arch/s390/include/asm/ptrace.h
@@ -99,7 +99,7 @@ enum {
 typedef struct {
 	unsigned int mask;
 	unsigned int addr;
-} psw_t32 __aligned(8);
+} psw32_t __aligned(8);
 
 #define PGM_INT_CODE_MASK	0x7f
 #define PGM_INT_CODE_PER	0x80
diff --git a/arch/s390/kernel/compat_linux.h b/arch/s390/kernel/compat_linux.h
index ef23739b277c7..133f22b5deebc 100644
--- a/arch/s390/kernel/compat_linux.h
+++ b/arch/s390/kernel/compat_linux.h
@@ -33,7 +33,7 @@ typedef struct {
 } _s390_fp_regs32;
 
 typedef struct {
-	psw_t32		psw;
+	psw32_t		psw;
 	__u32		gprs[__NUM_GPRS];
 	__u32		acrs[__NUM_ACRS];
 } _s390_regs_common32;
-- 
2.53.0



