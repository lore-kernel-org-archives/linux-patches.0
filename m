Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F00781509BC;
	Tue, 20 Feb 2024 21:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462953; cv=none; b=h94rgC9jqF3yn07KJl/fA4tgCC+niqxRNwRIOvWTQucrHOQgsAKyy4ch26cjJoORTAI6uZKu1DyjJLoSTqA14LxtYGG7s47pfsKheXAUgxjRurqp3v1Fp1+uN5Vdp2gWsmecJy/FeZtGIKoPnPpUJwoY80iriIeAtHlNeRvWLJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462953; c=relaxed/simple;
	bh=kT0cJNeuJIRdkYR3Y1xU+NCMdijcsbL2j4Poqz6Eufs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T1Na1CfRmoKRmjRWYK2MG7IHb6wb/phrq6YDLH6bqaMBqfa1x2sUij3jMvvwCNo83YALMO4NdQVRrcHa3eg8v0KN89gdVKTtNxFlXwzt44w6vBViBoIAO2HfxaGZR1K/d4S/MLaTvO2296+v5g3zC6qBjOfnA0VoFUsGhMQKCjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X6iaSgrE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X6iaSgrE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A332C433F1;
	Tue, 20 Feb 2024 21:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462952;
	bh=kT0cJNeuJIRdkYR3Y1xU+NCMdijcsbL2j4Poqz6Eufs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X6iaSgrEDO4+tt7aiWf5/5mYIx5zK43w1xUyZBTZtjiE/5kP/W3KLWwlWN3pWsKUg
	 Xwv+eBMWJwchpDzoXnEe7sGoHOa19ySbyYXDwORpFqR0hwzW5L/i3m2Rh2O1x0hSVt
	 Vcafq9Uzyx5KnR3CFwjoUxOjcScMd7PAGQmR++D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 6.1 088/197] linux/init: remove __memexit* annotations
Date: Tue, 20 Feb 2024 21:50:47 +0100
Message-ID: <20240220204843.720743283@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masahiro Yamada <masahiroy@kernel.org>

commit 6a4e59eeedc3018cb57722eecfcbb49431aeb05f upstream.

We have never used __memexit, __memexitdata, or __memexitconst.

These were unneeded.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Arnd Bergmann <arnd@arndb.de>
[nathan: Remove additional case of XXXEXIT_TO_SOME_EXIT due to lack of
         78dac1a22944 in 6.1]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Stable-dep-of: 846cfbeed09b ("um: Fix adding '-no-pie' for clang")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/asm-generic/vmlinux.lds.h |    6 ------
 include/linux/init.h              |    3 ---
 scripts/mod/modpost.c             |   16 +++-------------
 3 files changed, 3 insertions(+), 22 deletions(-)

--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -351,7 +351,6 @@
 	*(.ref.data)							\
 	*(.data..shared_aligned) /* percpu related */			\
 	MEM_KEEP(init.data*)						\
-	MEM_KEEP(exit.data*)						\
 	*(.data.unlikely)						\
 	__start_once = .;						\
 	*(.data.once)							\
@@ -546,7 +545,6 @@
 	__init_rodata : AT(ADDR(__init_rodata) - LOAD_OFFSET) {		\
 		*(.ref.rodata)						\
 		MEM_KEEP(init.rodata)					\
-		MEM_KEEP(exit.rodata)					\
 	}								\
 									\
 	/* Built-in module parameters. */				\
@@ -601,7 +599,6 @@
 		*(.ref.text)						\
 		*(.text.asan.* .text.tsan.*)				\
 	MEM_KEEP(init.text*)						\
-	MEM_KEEP(exit.text*)						\
 
 
 /* sched.text is aling to function alignment to secure we have same
@@ -751,13 +748,10 @@
 	*(.exit.data .exit.data.*)					\
 	*(.fini_array .fini_array.*)					\
 	*(.dtors .dtors.*)						\
-	MEM_DISCARD(exit.data*)						\
-	MEM_DISCARD(exit.rodata*)
 
 #define EXIT_TEXT							\
 	*(.exit.text)							\
 	*(.text.exit)							\
-	MEM_DISCARD(exit.text)
 
 #define EXIT_CALL							\
 	*(.exitcall.exit)
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -87,9 +87,6 @@
 						  __latent_entropy
 #define __meminitdata    __section(".meminit.data")
 #define __meminitconst   __section(".meminit.rodata")
-#define __memexit        __section(".memexit.text") __exitused __cold notrace
-#define __memexitdata    __section(".memexit.data")
-#define __memexitconst   __section(".memexit.rodata")
 
 /* For assembly routines */
 #define __HEAD		.section	".head.text","ax"
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -811,7 +811,7 @@ static void check_section(const char *mo
 #define ALL_INIT_TEXT_SECTIONS \
 	".init.text", ".meminit.text"
 #define ALL_EXIT_TEXT_SECTIONS \
-	".exit.text", ".memexit.text"
+	".exit.text"
 
 #define ALL_PCI_INIT_SECTIONS	\
 	".pci_fixup_early", ".pci_fixup_header", ".pci_fixup_final", \
@@ -819,10 +819,9 @@ static void check_section(const char *mo
 	".pci_fixup_resume_early", ".pci_fixup_suspend"
 
 #define ALL_XXXINIT_SECTIONS MEM_INIT_SECTIONS
-#define ALL_XXXEXIT_SECTIONS MEM_EXIT_SECTIONS
 
 #define ALL_INIT_SECTIONS INIT_SECTIONS, ALL_XXXINIT_SECTIONS
-#define ALL_EXIT_SECTIONS EXIT_SECTIONS, ALL_XXXEXIT_SECTIONS
+#define ALL_EXIT_SECTIONS EXIT_SECTIONS
 
 #define DATA_SECTIONS ".data", ".data.rel"
 #define TEXT_SECTIONS ".text", ".text.unlikely", ".sched.text", \
@@ -835,7 +834,6 @@ static void check_section(const char *mo
 #define MEM_INIT_SECTIONS  ".meminit.*"
 
 #define EXIT_SECTIONS      ".exit.*"
-#define MEM_EXIT_SECTIONS  ".memexit.*"
 
 #define ALL_TEXT_SECTIONS  ALL_INIT_TEXT_SECTIONS, ALL_EXIT_TEXT_SECTIONS, \
 		TEXT_SECTIONS, OTHER_TEXT_SECTIONS
@@ -864,7 +862,6 @@ enum mismatch {
 	TEXT_TO_ANY_EXIT,
 	DATA_TO_ANY_EXIT,
 	XXXINIT_TO_SOME_INIT,
-	XXXEXIT_TO_SOME_EXIT,
 	ANY_INIT_TO_ANY_EXIT,
 	ANY_EXIT_TO_ANY_INIT,
 	EXPORT_TO_INIT_EXIT,
@@ -939,12 +936,6 @@ static const struct sectioncheck section
 	.bad_tosec = { INIT_SECTIONS, NULL },
 	.mismatch = XXXINIT_TO_SOME_INIT,
 },
-/* Do not reference exit code/data from memexit code/data */
-{
-	.fromsec = { ALL_XXXEXIT_SECTIONS, NULL },
-	.bad_tosec = { EXIT_SECTIONS, NULL },
-	.mismatch = XXXEXIT_TO_SOME_EXIT,
-},
 /* Do not use exit code/data from init code */
 {
 	.fromsec = { ALL_INIT_SECTIONS, NULL },
@@ -1089,7 +1080,7 @@ static int secref_whitelist(const struct
 
 	/* symbols in data sections that may refer to meminit sections */
 	if (match(fromsec, PATTERNS(DATA_SECTIONS)) &&
-	    match(tosec, PATTERNS(ALL_XXXINIT_SECTIONS, ALL_XXXEXIT_SECTIONS)) &&
+	    match(tosec, PATTERNS(ALL_XXXINIT_SECTIONS)) &&
 	    match(fromsym, PATTERNS("*driver")))
 		return 0;
 
@@ -1267,7 +1258,6 @@ static void report_sec_mismatch(const ch
 	case TEXT_TO_ANY_EXIT:
 	case DATA_TO_ANY_EXIT:
 	case XXXINIT_TO_SOME_INIT:
-	case XXXEXIT_TO_SOME_EXIT:
 	case ANY_INIT_TO_ANY_EXIT:
 	case ANY_EXIT_TO_ANY_INIT:
 		warn("%s: section mismatch in reference: %s (section: %s) -> %s (section: %s)\n",


